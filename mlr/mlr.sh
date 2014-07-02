#!/usr/bin/env bash

# Update personal non-public repos

while read -r repo
do
    cd -- "$repo" &&
    {
        if [[ -e ./.git ]]
        then
            git ls-files --deleted -z | xargs --null git rm >/dev/null 2>&1
            git add . >/dev/null 2>&1
            git commit -m "mlr $(date)"
        elif [[ -e ./.hg ]]
        then
            hg add >/dev/null 2>&1
            hg commit -m "mlr $(date)"
        fi
    }
done < "${HOME}/.mlr/repos.txt"
