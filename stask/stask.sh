#!/usr/bin/env bash

# Simple wrapper for using taskwarrior with local "task-repos"

declare -x TASKRC=${TASKRC:-${PWD}/.task/taskrc}

case $1 in
    init)
        if [[ -d ${PWD}/.task ]]
        then
            { printf '%s\n' "${0}:Error:82: Could not create a task repository: '${PWD}/.task/' is existing" 1>&2 ; exit 82 ; }
        else
            mkdir -p -- "${PWD}/.task/data" && \
            task config data.location "${PWD}/.task/data"
        fi
        ;;
    --)
        shift 1
        task "$@"
        ;;
    *)
        { printf '%s\n' "${0}:Error:83: Unknown parameter: '${1}'" 1>&2 ; exit 83 ; }
esac
