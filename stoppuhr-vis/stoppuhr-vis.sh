#!/usr/bin/env bash

# Stoppuhr visible

declare -i i=
while sleep .9
do
    printf '%d\n' "$((++i))"
done
unset -v i
