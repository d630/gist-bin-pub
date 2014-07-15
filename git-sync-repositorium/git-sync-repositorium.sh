#!/usr/bin/env bash

# Autocommitting with inotify (repo: repositorium)

repos=repositorium

for r in $repos
do
    cd -- "${XDG_DOCUMENTS_DIR}/Uni/${r}" &&
    {
        git ls-files --deleted -z | xargs -0 git rm 1>/dev/null 2>&1
        git add -A . 1>/dev/null 2>&1
        git commit -a -m "inotify $(date)"
    }
done
