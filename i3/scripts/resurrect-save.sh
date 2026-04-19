#!/bin/sh
set -eu

dir="$HOME/.i3/layouts"
mkdir -p "$dir"

ws=$(i3-msg -t get_workspaces | python3 -c 'import sys,json; print([w["num"] for w in json.load(sys.stdin) if w["focused"]][0])')

log=$(mktemp)
trap 'rm -f "$log"' EXIT

if i3-resurrect save -w "$ws" --directory "$dir" >"$log" 2>&1; then
    notify-send -u low -i document-save "i3-resurrect" "saved workspace $ws"
else
    notify-send -u critical -i dialog-error "i3-resurrect" "save failed: $(tail -1 "$log")"
fi
