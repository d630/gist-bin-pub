#!/usr/bin/env bash

# Simpler Radiowecker

# rwecker.sh "2014-01-01 10:00" radio1

zp=$1
stream=$2

declare -A music
music[radio1]='http://www.radioeins.de/live.m3u'
music[open]='-R /home/user/music/open_your_eyes.mp3'

if (( $# == 2 )) && [[ $zp =~ [[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}[[:space:]][[:digit:]]{2}:[[:digit:]]{2} ]]
then
    if [[ ${music[$stream]} ]]
    then
        sudo rtcwake -m mem -t $(date -d "$zp" +%s) && sleep 10 && cvlc "${music[$stream]}" && { echo "Bye-bye!"  >&2 ; exit 0 ; }
    else
        { echo "Unknown stream." >&2 ; exit 1 ; }
    fi
else
    { echo "Neu Angabe!" >&2 ; exit 1 ; }
fi
