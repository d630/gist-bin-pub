#!/usr/bin/env bash

# dmenu-wrapper für Radiowecker

declare -A music
music[radio1]='http://www.radioeins.de/live.m3u'
music[open]="-R ${HOME}/Musik/open_your_eyes.mp3"

datum=$(printf '%s\n' "now" "tomorrow" | menu.sh "dmenu2" "Datum" | date -d - +%F)
tempus=$(printf '%s\n' {00..23}:{00..59} | menu.sh "dmenu2" "Zeitpunkt")
zp="${datum} ${tempus}"
stream=$(printf '%s\n' "${!music[@]}" | menu.sh "dmenu2" "Stream")

check=$(printf '%s\n' "no" "wecker.sh ${zp} $stream" | menu.sh "dmenu2" "Go" )

if [[ $check && $check != no ]]
then
    exec wecker.sh "$zp" "$stream"
    exit 0
else
    { echo "Bye-bye!" ; exit 1 ; }
fi
