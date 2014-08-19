#!/usr/bin/env bash

# Mutt uri filter (taskum)
# Add a bookmark to taskwarrior-um in Mutt
# See man urlview

while read -r
do
    um add uri="$REPLY"
done < <(grep -oP -e '((http|https|gopher|ftp|ftps|webdav|webdavs|dav|davs):(//)?[^ <>"\t]*|(www|ftp)[0-9]?\.[-a-z0-9.]+)[^ .,;\t\n\r<">\):]?[^, <>"\t]*[^ .,;\t\n\r<">\):]')
