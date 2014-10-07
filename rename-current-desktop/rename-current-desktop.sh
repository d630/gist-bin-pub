#!/usr/bin/env bash

# rename current desktop; manipulate _NET_DESKTOP_NAMES

declare desk_current=

read -r _ _ desk_current < <(xprop -root _NET_CURRENT_DESKTOP)
x-set-desktop-name.py "$desk_current" "$(menu.sh "dmenu2" ">" 0<&-)"
