#!/usr/bin/env bash
# Add a bookmark to taskwarrior-um in Mutt
# See man urlview

while read -r line
do
    taskum add uri:"${line}"
done < <(grep -oP -e '((http|https|gopher|ftp|ftps|webdav|webdavs|dav|davs):(//)?[^ <>"\t]*|(www|ftp)[0-9]?\.[-a-z0-9.]+)[^ .,;\t\n\r<">\):]?[^, <>"\t]*[^ .,;\t\n\r<">\):]')

