#!/bin/sh
# Idle daemon for Hyprland: lock at 10 min, monitor off at 15 min, lock on sleep.
exec swayidle -w \
    timeout 600  'swaylock -f' \
    timeout 900  'hyprctl dispatch dpms off' \
    resume       'hyprctl dispatch dpms on' \
    before-sleep 'swaylock -f'
