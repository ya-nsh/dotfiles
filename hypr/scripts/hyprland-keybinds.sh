#!/usr/bin/env bash
# Show all active Hyprland keybindings in a rofi menu (read-only viewer).
# Pulls from `hyprctl binds -j` so submaps, sourced files, and live reloads all work.
set -euo pipefail

mod_map() {
    # Translate the mod mask bits Hyprland reports into readable names.
    # Bit values from libwlroots: SHIFT=1, CAPS=2, CTRL=4, ALT=8, MOD2=16,
    # MOD3=32, LOGO/SUPER=64, MOD5=128.
    local m="$1" out=""
    (( m & 64  )) && out+="Super+"
    (( m & 4   )) && out+="Ctrl+"
    (( m & 8   )) && out+="Alt+"
    (( m & 1   )) && out+="Shift+"
    printf '%s' "$out"
}

# Stream binds as TSV: <modmask>\t<key>\t<dispatcher>\t<arg>\t<submap>
entries=$(
    hyprctl binds -j \
    | jq -r '.[] | [(.modmask|tostring), .key, .dispatcher, .arg, .submap] | @tsv'
)

formatted=$(
    while IFS=$'\t' read -r modmask key dispatcher arg submap; do
        prefix=$(mod_map "$modmask")
        combo="${prefix}${key}"
        action="$dispatcher"
        [[ -n "$arg" ]] && action="$dispatcher $arg"
        [[ -n "$submap" ]] && combo="[$submap] $combo"
        printf '%-32s  %s\n' "$combo" "$action"
    done <<< "$entries" \
    | sort -u
)

printf '%s\n' "$formatted" \
    | rofi -dmenu -i -p "Hyprland keys:" \
        -mesg "type to filter — Esc to dismiss" \
        -theme-str 'window {width: 70%;} listview {lines: 22;}' \
    >/dev/null 2>&1 || true
