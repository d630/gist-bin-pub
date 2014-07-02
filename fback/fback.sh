#!/usr/bin/env bash

# backup file fast

for file
do
    if [[ -e $1 ]]
    then
        cp -- "$1" "${1}_$(date +%Y-%m-%d_%H-%M-%S)"
    else
        printf '%s\n' ""$1" not found." 1>&2
    fi
done
