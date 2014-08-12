#!/usr/bin/env bash

# Use choose to simulate urlview

# https://github.com/vain/bin-pub/blob/master/choose
# http://www.uninformativ.de/?section=news&ndo=single&newsid=194
# https://github.com/vain/bin-pub/blob/master/urlview2

while read -r
do
    if [[ ! $DISPLAY ]]
    then
        elinks "$REPLY"
    else
        (exec qupzilla "$REPLY" &)
    fi
done < <(grep -oP '(((http|https|ftp|gopher)|mailto|file):(//)?[^ <>"\t]*|'\
'(www|ftp)[0-9]?\.[-a-z0-9.]+)[^ .,;\t\n\r<">\):]?[^, <>"\t]*'\
'[^ .,;\t\n\r<">\):]' "$@" | choose -)
