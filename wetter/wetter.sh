#!/usr/bin/env bash

# Get infos from http://wetter.tagesschau.de

declare -A wetter
wetter[d]=http://wetter.tagesschau.de/deutschland/wetterstationen/
wetter[w]=http://wetter.tagesschau.de/europawelt/

declare arg1=${1:-d}

if [[ ${arg1#-} == d ]]
then
    curl -s "${wetter[d]}" | scrape -be 'table' | w3m -dump -T text/html | grep "${2:-$X_MY_LOCATION2}"
elif [[ ${arg1#-} == w ]]
then
    curl -s "${wetter[w]}" | scrape -be 'table' | w3m -dump -T text/html
else
    { echo "Argument?" 1>&2 ; exit 1 ; }
fi
