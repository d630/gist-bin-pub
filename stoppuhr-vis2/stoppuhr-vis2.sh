#!/usr/bin/env bash

# Stoppuhr visible #2
# Source: http://askubuntu.com/questions/16149/overwrite-previous-output-in-bash-instead-of-appending-it

declare \
    sec=$1 \
    SECONDS=0

while sleep .5 && ((SECONDS <= sec))
do
    printf '\r%2d' "$((sec-SECONDS))"
done
printf '\n'

unset -v sec
