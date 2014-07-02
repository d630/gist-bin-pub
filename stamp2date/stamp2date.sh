#!/usr/bin/env bash

# stamp2date converter

if [[ $1 =~ [[:digit:]]{10} ]]
then
    date --utc --date "1970-01-01 "$1" sec" "+%Y-%m-%d %T"
else
    date --utc --date "1970-01-01 "$(date --utc --date "$(date "+%Y-%m-%d %T")" +%s)" sec" "+%Y-%m-%d %T"
fi
