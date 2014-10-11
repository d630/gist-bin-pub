#!/usr/bin/env bash

# Grun file bookmarks with dmenu (http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html)

declare mark=$(menu.sh "dmenu2" ">" < <(find "$MARKPATH/" -type l -printf '%f\n' | sort))

if [[ -d ${MARKPATH}/${mark} ]]
then
    if [[ $DISPLAY ]]
    then
        (exec spacefm -t "${MARKPATH}/${mark}" &)
    else
        { echo "No <DISPLAY>." 1>&2 ; exit 1 ; }
    fi
else
    { printf '%s\n' "${0}:Error: '${MARKPATH}/${mark}' is not a directory." 1>&2 ; exit 1 ; }
fi
