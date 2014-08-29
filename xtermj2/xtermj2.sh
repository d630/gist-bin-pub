#!/usr/bin/env bash

# Use xterm like kuake and yeahconsole terminal
# Source: https://wiki.archlinux.org/index.php/Urxvt#Improved_Kuake-like_behavior_in_Openbox
# Xterm has no daemon mode.
# But this is a faster replacement.

while read -r _ id
do
    [[ $(xprop -id "${id//:/}" WM_CLASS) =~ xtermj2 ]] && xid=${id//:/} && break
done < <(xlsclients -l | fgrep -x -e '  Command:  xterm -b 4 -name xtermj2' -B 4 | grep -e '^Window')

if [[ ! $xid ]]
then
    xterm -b 4 -name xtermj2
else
    if ! xprop -root _NET_CLIENT_LIST | grep -q "$xid"
    then
        xdotool windowmap "$xid"
        wmctrl -i -a "$xid"
    else
        xdotool windowunmap "$xid"
    fi
fi
