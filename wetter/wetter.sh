#!/usr/bin/env bash

# Get infos from http://wetter.tagesschau.de

declare -A wetter
wetter[dt]=http://wetter.tagesschau.de/deutschland/wetterstationen/
wetter[w]=http://wetter.tagesschau.de/europawelt/

if [[ ${1#-} == dt ]]
then
    curl -s "${wetter[dt]}" | scrape -be 'table' | w3m -dump -T text/html | grep "${2:-Berlin}"
elif [[ ${1#-} == w ]]
then
    curl -s "${wetter[w]}" | scrape -be 'table' | w3m -dump -T text/html
else
    { echo "Argument?" >&2 ; exit 1 ; }
fi
