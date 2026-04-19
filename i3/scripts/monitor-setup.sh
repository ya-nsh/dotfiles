#!/bin/sh

set -eu

primary="DP-4"
secondary="HDMI-2"
solo="DP-0"

command -v xrandr >/dev/null 2>&1 || exit 0

is_connected() {
    xrandr --query | grep -q "^$1 connected"
}

if is_connected "$primary" && is_connected "$secondary"; then
    exec xrandr \
        --output "$primary" --auto --primary \
        --output "$secondary" --auto --left-of "$primary"
fi

if is_connected "$primary"; then
    exec xrandr \
        --output "$primary" --auto --primary \
        --output "$secondary" --off
fi

if is_connected "$secondary"; then
    exec xrandr \
        --output "$secondary" --auto --primary \
        --output "$primary" --off
fi

if is_connected "$solo"; then
    exec xrandr \
        --output "$solo" --auto --primary --rate 239.99
fi

exit 0
