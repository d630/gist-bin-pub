#!/usr/bin/env bash

# Simpler Radiowecker

# wecker.sh "2014-01-01 10:00" radio1

zp=$1
stream=$2

declare -A music
music[radio1]=http://www.radioeins.de/live.m3u
music[open]="-R ${XDG_MUSIC_DIR}/open_your_eyes.mp3"
music[ndr2]='http://ndrstream.ic.llnwd.net/stream/ndrstream_ndr2_hi_mp3'

if (($# == 2)) && [[ $zp =~ [[:digit:]]{4}-[[:digit:]]{2}-[[:digit:]]{2}[[:space:]][[:digit:]]{2}:[[:digit:]]{2} ]]
then
    if [[ ${music[$stream]} ]]
    then
        sudo rtcwake -m mem -t $(date -d "$zp" +%s) && sleep 10 && (exec cvlc.sh "${music[$stream]}" &)
        exit 0
    else
        { echo "Unknown stream."  1>&2 ; exit 1 ; }
    fi
else
    { echo "nochmal angeben!" 1>&2 ; exit 1 ; }
fi
