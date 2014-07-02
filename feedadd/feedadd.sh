#!/usr/bin/env bash

# Add feed url to feedcatcher

if [[ $1 ]]
then
    printf '%s\n' "FEEDCATCHER"
    printf '%s\n' "$1" >> "${HOME}/.feedcatcher/urls.txt" && tail -n2 "${HOME}/.feedcatcher/urls.txt"
else
    { echo "No arguments." 1>&2 ; exit 1 ; }
fi
