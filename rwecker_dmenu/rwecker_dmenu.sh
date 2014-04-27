#!/usr/bin/env bash

# dmenu-wrapper für Radiowecker

_dmenu() { dmenu -i -b -p "$1" -l 10 -nf "#DCDCCC" -nb "#2C2C2C" -sf "#2C2C2C" -sb "#DCDCCC" -fn "'Droid Sans Mono-12'" ; }

declare -A music
music[radio1]='http://www.radioeins.de/live.m3u'
music[open]='-R /home/user1/Musik/open_your_eyes.mp3'

datum=$(printf '%s\n' "now" "tomorrow" | _dmenu "Datum" | date -d - +%F)
tempus=$(eval echo "{00..23}:{00..59}" | tr ' ' '\n' | _dmenu "Zeitpunkt")
zp="${datum} ${tempus}"
stream=$(printf '%s\n' "${!music[@]}" | _dmenu "Stream")

check=$(printf '%s\n' "no" "wecker.sh ${zp} $stream" | _dmenu "Go" )

if [[ $check && $check != no ]]
then
    exec rwecker.sh "$zp" "$stream"
else
    { echo "Bye-bye!" ; exit 1 ; }
fi
