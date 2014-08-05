#! /usr/bin/env bash

# Run Z output with your file manager (dmenu2 & spacefm ; fzf & ranger)

declare path=

if tty -s
then
    read -r _ path < <(sort -g "${X_XDG_LOG_HOME}/z.log" | menu.sh "fzf" "OPEN")
    [[ $path ]] && exec ranger "$path"
elif [[ $DISPLAY ]]
then
    read -r _ path < <(sort -rg "${X_XDG_LOG_HOME}/z.log" | menu.sh "dmenu2" "OPEN")
    [[ $path ]] && (exec spacefm -t "$path" &)
else
    exit 1
fi
