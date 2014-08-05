#!/usr/bin/env bash

# Run special file in editor (dmenu)

declare file=

read -r file < <(menu.sh "dmenu2" ">" < <(sort -g "${XDG_CONFIG_HOME}/special_files.txt"))

if [[ -f $file ]]
then
    if tty -s
    then
        exec "$tty_EDITOR" "$file"
    else
        (exec "$EDITOR" "$file" &)
    fi
else
    { printf '%s\n' "${0}:Error: '$file' is not a regular file." 1>&2 ; exit 1 ; }
fi

