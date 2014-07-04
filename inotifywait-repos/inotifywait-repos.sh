#!/usr/bin/env bash

# Inotify dirs (outline & repositorium)

declare -a watchnames=()

watchnames[0]=${XDG_DOCUMENTS_DIR}/Notizen/outline/
watchnames[1]=${XDG_DOCUMENTS_DIR}/Uni/repositorium/

inotifywait -mrq --timefmt '%y-%m-%d %H:%M' --format '%e, %T, %w, %f' -e modify -e move -e create -e delete ${watchnames[*]} --excludei .git |
while read -r date time dir file
do
    git-sync-outline.sh
    git-sync-repositorium.sh
done
