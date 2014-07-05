#!/usr/bin/env bash

# Add feed url to feedcacher

if [[ $1 ]]
then
    printf '%s\n' "FEEDCACHER"
    printf '%s\n' "$1" >> "${XDG_DATA_HOME}/feedcacher/urls.txt" && tail -n2 "${XDG_DATA_HOME}/feedcacher/urls.txt"
else
    { echo "No arguments." 1>&2 ; exit 1 ; }
fi
