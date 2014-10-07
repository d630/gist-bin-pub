#!/usr/bin/env bash

# rename current desktop; manipulate spaceless _NET_DESKTOP_NAMES

declare \
    desk_current= \
    desk_name_new
declare -a desk_names=()

read -r _ _ desk_current < <(xprop -root _NET_CURRENT_DESKTOP)

read -r -a desk_names < <(xprop -root -notype _NET_DESKTOP_NAMES)
desk_names=(${desk_names[@]:2})
desk_names=(${desk_names[@]//\",/\"})

desk_name_new=$(printf '%s\n' "${desk_names[@]}" | menu.sh "dmenu2" ">")

x-set-desktop-name.py "$desk_current" "$desk_name_new"
