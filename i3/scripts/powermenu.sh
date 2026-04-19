#!/bin/sh
set -eu

choice=$(printf "lock\nsuspend\nlogout\nreboot\nshutdown\ncancel" \
    | dmenu -i -p "Power:" \
        -fn "JetBrains Mono-11" \
        -nb "#171717" -nf "#d1d5db" \
        -sb "#2563eb" -sf "#ffffff")

case "$choice" in
    lock)     exec ~/.config/i3/scripts/lock.sh ;;
    suspend)  exec systemctl suspend ;;
    logout)   exec i3-msg exit ;;
    reboot)   exec systemctl reboot ;;
    shutdown) exec systemctl poweroff ;;
    *)        exit 0 ;;
esac
