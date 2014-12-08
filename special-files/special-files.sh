#!/usr/bin/env bash

# Run special file in editor (dmenu)

declare file=

if tty -s
then
    read -r file < <(menu.sh "fzf" ">" < <(sort -g "${XDG_CONFIG_HOME}/special_files.txt"))
    exec "$X_TTY_EDITOR" "$file"
else
    read -r file < <(menu.sh "dmenu2" ">" < <(sort -g "${XDG_CONFIG_HOME}/special_files.txt"))
    (exec geany "$file" &)
fi
