#!/usr/bin/env bash

# Record repo as personal non-public repo

if [[ -e ./.git ]] || [[ -e ./.hg ]]
then
    printf '%s\n' "$(pwd)" >> "${HOME}/.mlr/repos.txt" && tail -n2 "${HOME}/.mlr/repos.txt"
else
    echo "There is no repo in this dir." 1>&2
fi
