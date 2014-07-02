#!/usr/bin/env bash

# Add a url to use it with urlwatch and urldiff

if [[ $1 ]]
then
    printf '%s\n' "URLWATCH"
    echo "$1" >> "${HOME}/.urlwatch/urls.txt" && tail -n2 "${HOME}/.urlwatch/urls.txt"
    printf '\n%s\n' "URLDIFF"
    echo "$1" >> "${HOME}/.urldiff/urls.txt" && tail -n2 "${HOME}/.urldiff/urls.txt"
else
    echo "Es muss eine url angegeben werden..." 1>&2
fi
