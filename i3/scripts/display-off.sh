#!/bin/sh

sleep 0.5
pkill -f "xss-lock.*DISPLAY=$DISPLAY" 2>/dev/null || pkill xss-lock 2>/dev/null || true
xset dpms force off
xss-lock --transfer-sleep-lock -- ~/.config/i3/scripts/lock.sh --nofork &
sleep 0.3
if ! pgrep -x xss-lock > /dev/null; then
    notify-send -u critical "display-off" "xss-lock failed to restart — session locking is disabled"
fi
