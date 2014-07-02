#!/usr/bin/env bash

# date2stamp converter

if [[ $1 =~ [[:digit:]]{4}[[:punct:]]{1}[[:digit:]]{2}[[:punct:]]{1}[[:digit:]]{2}[[:blank:]]{1}[[:digit:]]{2}[[:punct:]]{1}[[:digit:]]{2}[[:punct:]]{1}[[:digit:]]{2} ]]
then
    date --utc --date "$1" +%s
else
    echo "Falsche Angabe, daher wurde das aktuelle Datum benutzt." 1>&2
    date --utc --date "$(date "+%Y-%m-%d %T")" +%s
fi
