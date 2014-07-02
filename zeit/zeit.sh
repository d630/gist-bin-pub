#!/usr/bin/env bash

# display times

echo
tput bold setaf 7
date +"%V %a %Y-%m-%d %H:%M:%S"
echo
lifeday.pl
tput sgr0
echo
ncal -w -M -3
echo
tzwatch
echo
