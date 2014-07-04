#!/usr/bin/env bash

# Inotify dirs (taskwarrior)

declare -a watchnames=()

watchnames[0]=${XDG_DOCUMENTS_DIR}/Notizen/taskwarrior/.task/pending.data

inotifywait -mrq --timefmt '%y-%m-%d %H:%M' --format '%e, %T, %w, %f' -e modify -e move -e create -e delete ${watchnames[*]} --excludei .git |
while read -r date time dir file
do
    task2remind.sh
done
