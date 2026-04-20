#!/usr/bin/env bash
# monitor-off.sh — turn the monitor off for long unattended runs without
# locking, suspending, or letting swayidle interfere. Wakes on any input.
#
# Root bug fix: hyprland.conf has key_press_enables_dpms=true, so the very
# key-release events of the hotkey (Super+Shift+M) wake the monitor one
# frame after it goes off. This script disables both wake-on-input flags,
# kills swayidle, sleeps briefly to absorb the keyups, cuts DPMS, then
# re-enables the flags so intentional input wakes the display. swayidle
# is re-spawned on wake.
set -euo pipefail

LOCK="/tmp/monitor-off.$UID.lock"
# Resolve the sibling idle.sh via this script's own directory so the
# respawn works whether the user runs us from ~/.config/hypr/scripts
# (stow symlink) or ~/dotfiles/hypr/scripts (direct) — Hyprland's
# `exec-once` actually uses the latter path on this machine.
SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
IDLE_SCRIPT="$SCRIPT_DIR/idle.sh"

# Single-instance guard: silent no-op if already running.
exec 9>"$LOCK"
flock -n 9 || exit 0

# Capture original dpms-on-input flags so we restore the user's settings
# exactly, not hardcoded defaults.
orig_key=$(hyprctl getoption misc:key_press_enables_dpms -j   | jq -r '.int // 1')
orig_mov=$(hyprctl getoption misc:mouse_move_enables_dpms -j | jq -r '.int // 1')

restore() {
    hyprctl keyword misc:key_press_enables_dpms   "$orig_key" >/dev/null 2>&1 || true
    hyprctl keyword misc:mouse_move_enables_dpms  "$orig_mov" >/dev/null 2>&1 || true
    if ! pgrep -x swayidle >/dev/null 2>&1 && [[ -x "$IDLE_SCRIPT" ]]; then
        setsid -f "$IDLE_SCRIPT" >/dev/null 2>&1 || true
    fi
}
trap restore EXIT INT TERM

# 1. Disable wake-on-input so keyups of the hotkey can't wake the monitor.
hyprctl keyword misc:key_press_enables_dpms  0 >/dev/null
hyprctl keyword misc:mouse_move_enables_dpms 0 >/dev/null

# 2. Stop swayidle so no lock/dpms-off timer fires while we're off.
pkill -x swayidle 2>/dev/null || true

# 3. Debounce — let every keyup from the hotkey drain.
sleep 0.5

# 4. Cut panel power.
hyprctl dispatch dpms off >/dev/null

# 5. Short-lived toast so the user sees it worked; expires before they're back.
notify-send -t 1200 -a monitor-off \
    "Monitor off" "Any key or mouse wakes it"

# 6. Re-enable wake-on-input so real input wakes the display.
hyprctl keyword misc:key_press_enables_dpms  "$orig_key" >/dev/null
hyprctl keyword misc:mouse_move_enables_dpms "$orig_mov" >/dev/null

# 7. Poll for wake. Break as soon as any monitor reports dpmsStatus=true.
while hyprctl monitors -j | jq -e 'all(.[]; .dpmsStatus == false)' >/dev/null 2>&1; do
    sleep 0.3
done

# trap restore runs on exit — flags already at their originals, swayidle
# respawns if needed. Nothing else to do here.
