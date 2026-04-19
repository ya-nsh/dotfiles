#!/bin/sh

# Turn off display without locking — suspend xss-lock for the duration

pkill xss-lock || true

xset dpms force off

# Wait until the monitor wakes back up
while xset q | grep -q "Monitor is Off"; do
    sleep 1
done

xss-lock --transfer-sleep-lock -- ~/.config/i3/scripts/lock.sh --nofork &
