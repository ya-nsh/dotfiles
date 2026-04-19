#!/bin/sh
set -eu

state_file="/tmp/.i3-gaps-state"
default_inner=8
default_outer=2

if [ -f "$state_file" ] && [ "$(cat "$state_file")" = "off" ]; then
    i3-msg "gaps inner all set $default_inner; gaps outer all set $default_outer" >/dev/null
    echo "on" > "$state_file"
    notify-send -u low -i view-grid "i3 gaps" "restored ($default_inner / $default_outer)"
else
    i3-msg "gaps inner all set 0; gaps outer all set 0" >/dev/null
    echo "off" > "$state_file"
    notify-send -u low -i view-grid "i3 gaps" "flattened (0 / 0)"
fi
