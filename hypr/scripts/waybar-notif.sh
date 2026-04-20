#!/usr/bin/env bash
# waybar-notif.sh — notification pill for waybar, backed by mako.
# Usage (default): emits {text, tooltip, class} JSON every `interval` seconds.
# With --toggle-dnd: flips mako's do-not-disturb mode.
set -euo pipefail

BELL=$'\uF0A2'      # fa-bell
BELL_OFF=$'\uF1F6'  # fa-bell-slash

if [[ "${1:-}" == "--toggle-dnd" ]]; then
    if [[ "$(makoctl mode 2>/dev/null)" == *"do-not-disturb"* ]]; then
        makoctl mode -r do-not-disturb
        notify-send "Notifications" "Resumed"
    else
        makoctl mode -a do-not-disturb
    fi
    exit 0
fi

mode=$(makoctl mode 2>/dev/null | tr '\n' ',' | sed 's/,$//')
history=$(makoctl history 2>/dev/null | jq '.data[0] | length' 2>/dev/null || echo 0)

if [[ "$mode" == *"do-not-disturb"* ]]; then
    icon="$BELL_OFF"
    cls="silenced"
    tip="Do-not-disturb on — right-click to resume"
else
    icon="$BELL"
    cls="active"
    tip="$history queued notification(s) — left-click to dismiss, right-click for DND"
fi

text="$icon"
[[ "$history" -gt 0 && "$cls" == "active" ]] && text="$icon $history"

jq -cn --arg text "$text" --arg tip "$tip" --arg cls "$cls" \
    '{text:$text, tooltip:$tip, class:$cls}'
