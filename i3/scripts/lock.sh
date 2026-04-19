#!/bin/sh
set -eu

# Prefer i3lock-color (clock + colors) > i3lock-fancy (blurred screenshot wrapper) > plain i3lock.
if command -v i3lock-color >/dev/null 2>&1; then
    TMP="$(mktemp --suffix=.png)"
    trap 'rm -f "$TMP"' EXIT
    if command -v scrot >/dev/null 2>&1 && command -v convert >/dev/null 2>&1; then
        scrot -o "$TMP" 2>/dev/null && convert "$TMP" -scale 10% -scale 1000% "$TMP"
    else
        convert -size 3840x2160 xc:"#111827" "$TMP" 2>/dev/null || TMP=""
    fi
    exec i3lock-color \
        ${TMP:+--image="$TMP"} \
        --clock --indicator \
        --time-str="%H:%M" --date-str="%a, %Y-%m-%d" \
        --time-size=48 --date-size=18 \
        --time-color=ffffffff --date-color=d1d5dbff \
        --inside-color=171717cc --ring-color=2563ebff \
        --keyhl-color=22c55eff  --bshl-color=b91c1cff \
        --ringver-color=2563ebff --insidever-color=171717cc \
        --ringwrong-color=b91c1cff --insidewrong-color=171717cc \
        --radius=100 --ring-width=6 \
        --verif-text="checking..." --wrong-text="nope" \
        --noinput-text="" --greeter-text="$USER" \
        --pointer=default \
        "$@"
elif command -v i3lock-fancy >/dev/null 2>&1; then
    exec i3lock-fancy -p -- i3lock "$@"
else
    exec i3lock -c 111827 "$@"
fi
