# dotfiles

Personal Hyprland + Waybar + zsh + tmux setup for Wayland on NVIDIA. Managed
with [GNU Stow](https://www.gnu.org/software/stow/) and a single bootstrap
script that handles packages, fonts, symlinks, and user services.

## One-command install

```bash
git clone git@github.com:ya-nsh/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./bootstrap.sh
```

The script:

1. Detects `apt` or `pacman` and installs Hyprland, Waybar, PipeWire, rofi,
   wofi, grim/slurp, mako, swaylock, ptyxis, polkit agent, dex, gammastep,
   tmux, zsh, nvim, jq, rg, fd, and the `xdg-desktop-portal-hyprland`.
2. Downloads the JetBrainsMono Nerd Font from the upstream release if
   `fc-list` doesn't already have the `Mono` variant.
3. `stow --restow`es each package below into `~/.config/<pkg>`, symlinks
   `bin/*` into `~/.local/bin/`, and links `~/.Xresources`.
4. Enables the `pipewire`, `pipewire-pulse`, and `wireplumber` user
   services.

It's idempotent — re-run it after pulling new changes to re-link anything
added or renamed. Env flags: `SKIP_PACKAGES=1`, `SKIP_FONTS=1`.

## What gets linked

| Package          | Symlink target                      |
| ---------------- | ----------------------------------- |
| `hypr/`          | `~/.config/hypr/`                   |
| `waybar/`        | `~/.config/waybar/`                 |
| `mako/`          | `~/.config/mako/`                   |
| `swaylock/`      | `~/.config/swaylock/`               |
| `dunst/`         | `~/.config/dunst/`                  |
| `gtk-3.0/` `gtk-4.0/` | `~/.config/gtk-3.0/` `~/.config/gtk-4.0/` |
| `i3/` `i3status-rust/` `picom/` `xsettingsd/` | `~/.config/<pkg>/` (legacy X11) |
| `bin/*`          | `~/.local/bin/<script>`             |
| `Xresources/Xresources` | `~/.Xresources`              |

`zsh/`, `git/`, `nvim/` are empty placeholders — add configs then re-run
`bootstrap.sh` to link them in.

## Hyprland cheatsheet

| Key                | Action                                   |
| ------------------ | ---------------------------------------- |
| `Super+Return`     | Terminal (ptyxis)                        |
| `Super+d`          | App launcher (wofi drun)                 |
| `Super+Shift+q`    | Kill focused window                      |
| `Super+Shift+Space`| Toggle floating                          |
| `Super+f`          | Fullscreen                               |
| `Super+1..0`       | Switch workspace                         |
| `Super+Shift+1..0` | Move window to workspace                 |
| `Super+←↓↑→`       | Focus direction                          |
| `Super+Shift+←↓↑→` | Move window direction                    |
| `Super+r`          | Resize submap (arrows resize, Esc exits) |
| `Super+Print`      | Screenshot whole screen → clipboard      |
| `Print`            | Region screenshot → clipboard            |
| `Super+F1`         | **Keybind helper** (rofi, lists all binds) |
| `Super+Shift+r`    | Reload Hyprland                          |
| `Super+Shift+x`    | Lock (swaylock)                          |

The full list is generated live from `hyprctl binds` — hit `Super+F1` or
click the **?** pill on the waybar.

## NVIDIA notes

This config targets NVIDIA (tested on a 4080 SUPER with driver 580). The
env-var block in `hypr/hyprland.conf` sets `GBM_BACKEND=nvidia-drm`,
`LIBVA_DRIVER_NAME=nvidia`, `__GL_{G,V}SYNC_ALLOWED=1`,
`WLR_NO_HARDWARE_CURSORS=1`, and `ELECTRON_OZONE_PLATFORM_HINT=wayland`.
If you're on AMD/Intel, those env vars are no-ops or harmless but can be
dropped.

Explicit-sync (`render { explicit_sync = 2 }`) needs Hyprland ≥ 0.42;
check `hyprctl version` and add that block once upgraded.

---

## tmux

### First-time setup

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# inside tmux:  Ctrl+b  then  I  (capital i) to install plugins
```

### Prefix: `Ctrl+b`

| Keys              | What it does                                         |
| ----------------- | ---------------------------------------------------- |
| `Ctrl+b d`        | Detach from session (session stays running)          |
| `Ctrl+b s`        | List and switch sessions                             |
| `Ctrl+b $`        | Rename current session                               |
| `Ctrl+b c`        | New window                                           |
| `Ctrl+b ,`        | Rename window                                        |
| `Ctrl+b n / p`    | Next / previous window                               |
| `Ctrl+b 1..9`     | Jump to window by number                             |
| `Ctrl+b \|`       | Split pane vertically *(custom)*                     |
| `Ctrl+b -`        | Split pane horizontally *(custom)*                   |
| `Ctrl+b h/j/k/l`  | Navigate panes (vim-style) *(custom)*                |
| `Ctrl+b H/J/K/L`  | Resize panes *(custom)*                              |
| `Ctrl+b r`        | Reload config *(custom)*                             |
| `Ctrl+b [`        | Enter scroll/copy mode (vim keys, `q` to exit)       |
| `Ctrl+b z`        | Zoom current pane (toggle fullscreen)                |
| `Ctrl+b x`        | Kill current pane                                    |
| `Ctrl+b &`        | Kill current window                                  |

### Plugins

| Plugin             | What it does                                                    |
| ------------------ | --------------------------------------------------------------- |
| **tpm**            | Plugin manager — installs and updates all other plugins         |
| **tmux-sensible**  | Sane defaults (UTF-8, faster repeat, etc.)                      |
| **tmux-resurrect** | `Ctrl+b Ctrl+s` save / `Ctrl+b Ctrl+r` restore sessions         |
| **tmux-continuum** | Auto-saves every 15 min, auto-restores on `tmux` start          |

Session restore after reboot: just run `tmux` — continuum handles it.
