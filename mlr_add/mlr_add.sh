#!/usr/bin/env bash

# Record repo as personal non-public repo

if [[ -e ./.git ]] || [[ -e ./.hg ]]
then
    printf '%s\n' "$(pwd)" >> ~/.mlr/repos && tail -n2 ~/.mlr/repos
else
    echo "There is no repo in this dir." >&2
fi
