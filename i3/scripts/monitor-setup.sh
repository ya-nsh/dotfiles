#!/bin/sh

set -eu

primary="DP-4"
secondary="HDMI-2"
solo="DP-0"

command -v xrandr >/dev/null 2>&1 || exit 0

is_connected() {
    xrandr --query | grep -q "^$1 connected"
}

off_outputs="--output HDMI-0 --off --output DP-1 --off --output DP-2 --off --output DP-3 --off --output DP-5 --off --output HDMI-1-1 --off --output DP-1-1 --off --output DP-1-2 --off --output DP-1-3 --off"

if is_connected "$primary" && is_connected "$secondary"; then
    # shellcheck disable=SC2086
    exec xrandr \
        --output "$primary" --auto --primary \
        --output "$secondary" --auto --left-of "$primary" \
        --output "$solo" --off \
        $off_outputs
fi

if is_connected "$primary"; then
    # shellcheck disable=SC2086
    exec xrandr \
        --output "$primary" --auto --primary \
        --output "$secondary" --off \
        --output "$solo" --off \
        $off_outputs
fi

if is_connected "$secondary"; then
    # shellcheck disable=SC2086
    exec xrandr \
        --output "$secondary" --auto --primary \
        --output "$primary" --off \
        --output "$solo" --off \
        $off_outputs
fi

if is_connected "$solo"; then
    # shellcheck disable=SC2086
    exec xrandr \
        --output "$solo" --auto --primary --rate 239.99 \
        --output "$primary" --off \
        --output "$secondary" --off \
        $off_outputs
fi

exit 0
