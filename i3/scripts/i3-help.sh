#!/bin/sh
set -eu

config="${1:-$HOME/.config/i3/config}"

awk '
  /^[[:space:]]*mode[[:space:]]+"/ { in_mode = 1; next }
  in_mode && /^[[:space:]]*}/      { in_mode = 0; next }
  in_mode { next }
  /^[[:space:]]*bindsym[[:space:]]/ {
    sub(/^[[:space:]]*bindsym[[:space:]]+/, "")
    n = index($0, " ")
    if (n == 0) next
    key  = substr($0, 1, n-1)
    rest = substr($0, n+1)
    gsub(/\$mod\+/, "Super+", key)
    gsub(/^\$mod$/, "Super", key)
    gsub(/\$left/,  "Left",  key); gsub(/\$right/, "Right", key)
    gsub(/\$up/,    "Up",    key); gsub(/\$down/,  "Down",  key)
    gsub(/\$left/,  "Left",  rest); gsub(/\$right/, "Right", rest)
    gsub(/\$up/,    "Up",    rest); gsub(/\$down/,  "Down",  rest)
    # collapse $ws<N> -> N in actions for readability
    gsub(/\$ws10/, "10", rest); gsub(/\$ws1/, "1", rest); gsub(/\$ws2/, "2", rest)
    gsub(/\$ws3/, "3", rest);  gsub(/\$ws4/, "4", rest); gsub(/\$ws5/, "5", rest)
    gsub(/\$ws6/, "6", rest);  gsub(/\$ws7/, "7", rest); gsub(/\$ws8/, "8", rest)
    gsub(/\$ws9/, "9", rest)
    gsub(/--no-startup-id /, "", rest)
    sub(/^exec[[:space:]]+/, "", rest)
    sub(/^"/, "", rest); sub(/"[[:space:]]*$/, "", rest)
    printf "%-32s  %s\n", key, rest
  }
' "$config" \
  | sort -u \
  | rofi -dmenu -i -p "i3 keys:" \
      -mesg "type to filter — Esc to dismiss" \
      -theme-str 'window {width: 70%;} listview {lines: 22;}' \
  >/dev/null 2>&1 || true
