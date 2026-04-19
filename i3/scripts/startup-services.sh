#!/bin/sh

set -eu

user_id="$(id -u)"

run_once() {
    process_name="$1"
    shift

    if pgrep -u "$user_id" -x "$process_name" >/dev/null 2>&1; then
        return 0
    fi

    "$@" >/dev/null 2>&1 &
}

if command -v dunst >/dev/null 2>&1; then
    run_once dunst dunst
fi

if command -v nm-applet >/dev/null 2>&1; then
    run_once nm-applet nm-applet
fi

if command -v blueman-applet >/dev/null 2>&1; then
    run_once blueman-applet blueman-applet
fi

for agent in \
    /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 \
    /usr/libexec/polkit-gnome-authentication-agent-1
do
    if [ -x "$agent" ] && ! pgrep -u "$user_id" -f "$agent" >/dev/null 2>&1; then
        "$agent" >/dev/null 2>&1 &
        break
    fi
done
