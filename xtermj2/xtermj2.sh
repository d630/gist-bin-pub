#!/usr/bin/env bash

# Use xterm like kuake and yeahconsole terminal
# Source: https://wiki.archlinux.org/index.php/Urxvt#Improved_Kuake-like_behavior_in_Openbox
# Xterm has no daemon mode.
# But this is a faster replacement.

while read -r
do
    [[ $(xprop -id "$REPLY" WM_CLASS) =~ xtermj2 ]] && xid=$REPLY && break
done < <(while read -r _ id ; do printf '%s\n' "${id//:/}" ; done < <(xlsclients -l | grep ^Window))

if [[ ! $xid ]]
then
    xterm -name xtermj2
else
    if ! xprop -root _NET_CLIENT_LIST | grep -q "$xid"
    then
        xdotool windowmap "$xid"
        wmctrl -i -a "$xid"
    else
        xdotool windowunmap "$xid"
    fi
fi
