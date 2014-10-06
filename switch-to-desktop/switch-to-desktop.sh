#!/usr/bin/env bash

# select desktop with a menu and then switch with wmctrl to it

declare desk_number=$(wmctrl -d | menu.sh "dmenu2" ">")
wmctrl -s "${desk_number%% *}"
