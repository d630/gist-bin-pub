#!/usr/bin/env bash

# Interactively add a note via Terminal to use it later in org-mode and ask for taskwarrior.

declare \
        file= \
        kuno= \
        selection= \
        tags= \
        time= \
        title=

file=${XDG_DOCUMENTS_DIR}/Notizen/outline/quicknotes.org

read -re -p "Title: " title
read -re -p "Kurznotiz: " kuno
read -re -p "Tags: " tags

time=$(date +"%Y-%m-%d_%a_%H:%M")

cat >> "$file" << TEMPLATE
* Kurznotiz: ${title}                                            ${tags}
:LOGBOOK:
CLOCK: [${time}]--[${time}] =>  0:00
:END:
<${time}>
:PROPERTIES:
:TODO:
:PRIORITY:
:DEADLINE:
:SCHEDULED:
:CLOSED:
:CLOCKSUM:
:CLOCKSUM_T:
:BLOCKED:
:ITEM:
:FILE:
:COLUMNS:
:CATEGORY:
:ARCHIVE:
:LOGGING:
:END:
${kuno}
TEMPLATE

emacsclient -t "$file"

read -re -p "Add a task to taskwarrior? (y/n)" selection
case $selection in
    n)
            exit 1
            ;;
    y)
            taskwarrior-add.sh
            ;;
esac
