#!/usr/bin/env bash
# Add interactively a note via Terminal to use it later in org-mode and ask for taskwarrior.

file=~/outline/quicknotes.org

read -re -p "Title: " name
read -re -p "Kurznotiz: " kuno
read -re -p "Tags: " tags

time=$(date +"%Y-%m-%d_%a_%H:%M")

cat >> "$file" << TEMPLATE
* Kurznotiz: ${titel}                                        ${tags}
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
            taskwarrior_add.sh
            ;;
esac