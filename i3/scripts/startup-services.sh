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

if command -v picom >/dev/null 2>&1; then
    run_once picom picom --config ~/.config/picom/picom.conf
fi

if command -v dunst >/dev/null 2>&1; then
    run_once dunst dunst
fi

if command -v nm-applet >/dev/null 2>&1; then
    run_once nm-applet nm-applet
fi

if command -v blueman-applet >/dev/null 2>&1; then
    run_once blueman-applet blueman-applet
fi

if command -v copyq >/dev/null 2>&1; then
    run_once copyq copyq
fi

if command -v gammastep >/dev/null 2>&1; then
    run_once gammastep gammastep -O 4500
fi

if [ -x "$HOME/.local/bin/greenclip" ]; then
    run_once greenclip "$HOME/.local/bin/greenclip" daemon
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

if command -v xsettingsd >/dev/null 2>&1; then
    if ! pgrep -u "$user_id" -x gnome-settings-daemon >/dev/null 2>&1; then
        run_once xsettingsd xsettingsd
    fi
fi
