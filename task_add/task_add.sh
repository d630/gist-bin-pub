#!/usr/bin/env bash

# Add interactively a task to Taskwarrior via read in a terminal + dmenu

echo "Choose a project, insert a new one or escape..."
project=$(task rc.list.all.projects=yes _projects | tee >(cut -d '.' -f1) | sort -u | dmenu -i -b -p "Project" -l 15 -nf "#DCDCCC" -nb "#2C2C2C" -sf "#2C2C2C" -sb "#DCDCCC" -fn "'Droid Sans Mono-12'")
[[ ! $project ]] && { echo "No project has been chosen. Bye-bye!" >&2 ; exit 1 ; }
printf '%s\t%s\n' "Project:" "${project//./ > }"

read -re -p "Is recur/wait/until/scheduled/depends needed? (y/n)" answer
case $answer in
    n)
        read -re -p "description:    " description
        read -re -p "priority:       " priority
        read -re -p "due:            " due
        IFS=';' read -re -p "tags:           " -a tags
        ;;
    y)
        read -re -p "description:    " description
        read -re -p "priority:       " priority
        read -re -p "due:            " due
        IFS=';' read -re -p "tags:           " -a tags

        read -re -p "recur:          " recur
        read -re -p "wait:           " wait
        read -re -p "until:          " until
        read -re -p "scheduled:      " scheduled
        read -re -p "depends:        " depends
        ;;
esac

printf '\n%s       %s\n' "Command:" "task add $description project:${project} due:${due} priority:${priority} recur:${recur} wait:${wait} until:${until} scheduled:${scheduled} depends:${depends} ${tags[*]/#/+}"

task add "$description" project:"${project}" due:"${due}" priority:"${priority}" recur:"${recur}" wait:"${wait}" until:"${until}" scheduled:"${scheduled}" depends:"${depends}" ${tags[*]/#/+}
