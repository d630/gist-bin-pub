#!/usr/bin/env bash

# Feed url to newsbeuter via dmenu

declare cache=${HOME}/dotfiles/feedcatcher/.feedcatcher/cache/ \
        tagfile=${HOME}/.newsbeuter/tags \
        feedfile=${HOME}/.newsbeuter/urls \
        feed= \
        tags=

feed=$(find "$cache" -type f | menu.sh "dmenu2" "FEED")
tags=$(menu.sh "dmenu2" "TAGS" < "$tagfile")

if [[ $tags ]]
then
    printf '%s\n' "file://${feed} ${tags}" | cat "$feedfile" - | sort -g > "$feedfile.$$"
    mv -- "$feedfile.$$" "$feedfile"
else
     { echo "No tag has been chosen." 1>&2 ; exit 1 ; }
fi
