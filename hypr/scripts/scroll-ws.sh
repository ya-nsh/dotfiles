#!/bin/sh
# Debounced workspace scroll for waybar. Ignores events within 180 ms of
# the previous one, so a single mouse-wheel notch (which fires several
# GDK scroll events) only advances one workspace.
dir="${1:?missing direction e+1 or e-1}"
STAMP=/tmp/wb-scroll.stamp
now=$(date +%s%N)
last=$(cat "$STAMP" 2>/dev/null || echo 0)
elapsed=$(( (now - last) / 1000000 ))  # ms since last fire
if [ "$elapsed" -gt 180 ]; then
    printf '%s' "$now" > "$STAMP"
    hyprctl dispatch workspace "$dir" >/dev/null
fi
