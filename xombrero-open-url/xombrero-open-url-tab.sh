#!/usr/bin/env bash

count="$(pgrep -c xombrero)"

file_uris="${X_XDG_LOG_HOME}/urls.log" \
uri="$(
    grep -oP -e '((http|https|gopher|ftp|ftps|webdav|webdavs|dav|davs):(//)?[^ <>"\t]*|(www|ftp)[0-9]?\.[-a-z0-9.]+)[^ .,;\t\n\r<">\):]?[^, <>"\t]*[^ .,;\t\n\r<">\):]' "$file_uris" | \
    tac | \
    #fzf -e -i +s
    menu.sh "dmenu2" ">"
    )"

[ -n "$uri" ] || exit 1

if [ "$count" -eq 0 ]
then
    (exec xombrero "$uri" &)
else
    xombrero -n "$uri"
fi
