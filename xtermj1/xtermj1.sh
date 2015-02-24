#!/usr/bin/env bash

# Use xterm like kuake and yeahconsole terminal
# Source: https://wiki.archlinux.org/index.php/Urxvt#Improved_Kuake-like_behavior_in_Openbox
# Xterm has no daemon mode.
# But this is a faster replacement.

while read -r _ id
do
    [[ $(xprop -id "${id//:/}" WM_CLASS) =~ xtermj1 ]] && xid=${id//:/} && break
done < <(xlsclients -l | fgrep -x -e '  Command:  xterm -b 4 -name xtermj1' -B 4 | grep -e '^Window')

if [[ $xid ]]
then
    if xprop -root _NET_CLIENT_LIST | grep -q "$xid"
    then
        xdotool windowunmap "$xid"
    else
        xdotool windowmap "$xid"
        wmctrl -i -a "$xid"
    fi
else
    exec xterm -b 4 -name xtermj1
fi
