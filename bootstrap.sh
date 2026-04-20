#!/usr/bin/env bash
# bootstrap.sh — provision a fresh Linux box with this dotfiles setup.
#
# Idempotent: safe to re-run. Installs system packages, the JetBrainsMono
# Nerd Font, stows config symlinks into ~/.config and ~/.local/bin, and
# enables the PipeWire user services.
#
# Usage:
#   git clone git@github.com:ya-nsh/dotfiles.git ~/dotfiles
#   cd ~/dotfiles && ./bootstrap.sh
#
# Env overrides:
#   DOTFILES_DIR   — where the repo lives (default: ~/dotfiles)
#   SKIP_PACKAGES  — set to 1 to skip the apt/pacman step
#   SKIP_FONTS     — set to 1 to skip font install

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
SKIP_PACKAGES="${SKIP_PACKAGES:-0}"
SKIP_FONTS="${SKIP_FONTS:-0}"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31mxx\033[0m %s\n' "$*" >&2; exit 1; }

[[ -d "$DOTFILES_DIR" ]] || die "DOTFILES_DIR not found: $DOTFILES_DIR"

############################################
# 1. System packages
############################################
install_apt() {
    sudo apt update
    # Grouped for readability; -y on the whole list, missing packages on the
    # user's distro version are tolerated with || true at the end.
    sudo apt install -y \
        stow curl wget unzip git \
        hyprland hyprpaper waybar mako-notifier swaylock \
        rofi wofi grim slurp wl-clipboard cliphist \
        pipewire pipewire-pulse wireplumber pulseaudio-utils playerctl \
        ptyxis nautilus \
        network-manager-gnome blueman \
        polkitd-pkla policykit-1-gnome \
        dex gammastep \
        tmux zsh neovim \
        jq ripgrep fd-find \
        xdg-desktop-portal-hyprland \
        || warn "some apt packages failed — check names on this Ubuntu release"
}

install_pacman() {
    sudo pacman -S --needed --noconfirm \
        stow curl wget unzip git \
        hyprland hyprpaper waybar mako swaylock \
        rofi wofi grim slurp wl-clipboard cliphist \
        pipewire pipewire-pulse wireplumber libpulse playerctl \
        nautilus network-manager-applet blueman \
        polkit-kde-agent dex gammastep \
        tmux zsh neovim \
        jq ripgrep fd \
        xdg-desktop-portal-hyprland \
        || warn "some pacman packages failed"
}

if [[ "$SKIP_PACKAGES" == "1" ]]; then
    log "SKIP_PACKAGES=1 — skipping package install"
elif command -v apt >/dev/null;   then log "apt detected — installing packages";   install_apt
elif command -v pacman >/dev/null; then log "pacman detected — installing packages"; install_pacman
else warn "no apt/pacman — install packages manually for your distro"
fi

############################################
# 2. JetBrainsMono Nerd Font
############################################
if [[ "$SKIP_FONTS" == "1" ]]; then
    log "SKIP_FONTS=1 — skipping font install"
elif fc-list 2>/dev/null | grep -q "JetBrainsMono Nerd Font Mono"; then
    log "JetBrainsMono Nerd Font Mono already present"
else
    log "Installing JetBrainsMono Nerd Font…"
    FONT_DIR="$HOME/.local/share/fonts/JetBrainsMonoNerd"
    TMP="$(mktemp -d)"
    trap 'rm -rf "$TMP"' EXIT
    mkdir -p "$FONT_DIR"
    curl -fL --progress-bar -o "$TMP/jbm.zip" \
        "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    unzip -oq "$TMP/jbm.zip" -d "$FONT_DIR"
    fc-cache -f "$FONT_DIR" >/dev/null
    log "Font cache refreshed"
fi

############################################
# 3. WhiteSur cursor theme (not in apt/pacman)
############################################
if [[ -d "$HOME/.local/share/icons/WhiteSur-cursors" ]]; then
    log "WhiteSur cursors already installed"
elif [[ "$SKIP_FONTS" == "1" ]]; then
    log "SKIP_FONTS=1 — also skipping cursor install"
else
    log "Installing WhiteSur cursor theme…"
    TMP_CUR="$(mktemp -d)"
    git clone --depth 1 https://github.com/vinceliuice/WhiteSur-cursors.git "$TMP_CUR/ws" \
        && (cd "$TMP_CUR/ws" && ./install.sh >/dev/null) \
        || warn "WhiteSur install failed — falling back to Bibata"
    rm -rf "$TMP_CUR"
fi

############################################
# 4. Stow symlinks
############################################
mkdir -p "$HOME/.config" "$HOME/.local/bin"

# Packages that should expand into ~/.config/<pkg>
CONFIG_PKGS=(
    hypr waybar mako swaylock dunst
    gtk-3.0 gtk-4.0 i3 i3status-rust picom xsettingsd
)

log "Stowing config packages into ~/.config…"
cd "$DOTFILES_DIR"
for pkg in "${CONFIG_PKGS[@]}"; do
    if [[ -d "$pkg" && -n "$(ls -A "$pkg" 2>/dev/null)" ]]; then
        stow --restow --target="$HOME/.config" "$pkg"
        echo "  linked: $pkg → ~/.config/$pkg"
    fi
done

# bin/ → ~/.local/bin/* (file-by-file so it coexists with other bins)
if [[ -d bin ]]; then
    log "Linking bin/ into ~/.local/bin…"
    for f in bin/*; do
        [[ -f "$f" ]] || continue
        chmod +x "$f"
        ln -sfn "$DOTFILES_DIR/$f" "$HOME/.local/bin/$(basename "$f")"
    done
fi

# Xresources/Xresources → ~/.Xresources (non-standard layout)
if [[ -f Xresources/Xresources ]]; then
    ln -sfn "$DOTFILES_DIR/Xresources/Xresources" "$HOME/.Xresources"
    log "Linked ~/.Xresources"
fi

# Scripts under hypr/ need executable bit after a fresh clone
find hypr/scripts -type f -name '*.sh' -exec chmod +x {} + 2>/dev/null || true
find i3/scripts   -type f -name '*.sh' -exec chmod +x {} + 2>/dev/null || true

############################################
# 5. User services
############################################
if command -v systemctl >/dev/null; then
    log "Enabling PipeWire user services…"
    systemctl --user daemon-reload || true
    systemctl --user enable --now \
        pipewire.socket pipewire-pulse.socket wireplumber.service \
        >/dev/null 2>&1 || warn "couldn't enable pipewire services — check they're installed"
fi

############################################
# 6. Post-install hints
############################################
cat <<EOF

$(log "Bootstrap complete.")

Next steps:
  1. Log out and pick "Hyprland" at the display-manager session menu.
  2. Once in, press  Super+F1  to confirm the keybind helper loads.
  3. tmux plugins:   git clone https://github.com/tmux-plugins/tpm \\
                       ~/.tmux/plugins/tpm
     Start tmux and hit  Ctrl+b I  to install plugins.

Re-run this script any time — it's idempotent.
EOF
