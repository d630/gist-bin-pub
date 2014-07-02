#!/usr/bin/env bash

# Quote arguments (source: http://forum.ubuntuusers.de/forum/shell-und-programmieren/)

printf '%s\n' "$# args"

for arg
do
  printf '%s\n' "arg[$((++i))] <${arg}>"
done
