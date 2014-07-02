#!/usr/bin/env bash

# List xwindows with dmenu and raise selection

wmctrl -i -a "$(wmctrl -lGpx | menu.sh "dmenu2" ">" | awk '{print $1}')"
