#!/bin/sh
# Idle daemon for Hyprland: lock at 10 min, monitor off at 15 min, lock on sleep.
LOCK="swaylock -f -C $HOME/.config/swaylock/config"
exec swayidle -w \
    timeout 600  "$LOCK" \
    timeout 900  'hyprctl dispatch dpms off' \
    resume       'hyprctl dispatch dpms on' \
    before-sleep "$LOCK"
