#!/usr/bin/env bash

# Simple Anacron like sheduler
# Inspired by https://github.com/vain/bin-pub/blob/master/regularly

declare -x LC_COLLATE=C
declare -i \
    "$(date +time_curr=%s)" \
    event_number= \
    period= \
    time_diff= \
    time_last=

declare -A events
declare -a \
    commands=() \
    spool=()

shopt -s extglob

source "${XDG_CONFIG_HOME}/eventrc" || exit $?
source "${X_XDG_LIB_DIR}/event.spool"
printf -v commands '%s\n' "${!events[@]}"
printf -v commands '%s\n' "${commands//+([0-9])_@(name|period|time_last)/}"
commands=($commands)

shopt -u extglob

while IFS='_' read -r event_number _
do
    time_last=${events[${event_number}_time_last]}
    time_diff=$((time_curr - time_last))
    period=${events[${event_number}_period]:-${time_diff}}
    if ((time_diff >= period))
    then
        (eval "${events[${event_number}_command]}") &
        spool+=("events[${event_number}_time_last]=$time_curr")
    else
        spool+=("events[${event_number}_time_last]=$time_last")
    fi
done < <(printf '%s\n' "${commands[@]}" | sort -n)

wait
printf '%s\n' "${spool[@]}" > "${X_XDG_LIB_DIR}/event.spool"
