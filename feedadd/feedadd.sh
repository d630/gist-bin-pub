#!/usr/bin/env bash

# Add feed url to feedcacher

if [[ $1 ]]
then
    printf '%s\n' "FEEDCACHER"
    printf '%s\n' "$1" >> "${X_XDG_LIB_DIR}/feedcacher/urls.txt" && tail -n2 "${X_XDG_LIB_DIR}/feedcacher/urls.txt"
else
    { echo "No arguments." 1>&2 ; exit 1 ; }
fi
