#!/usr/bin/env bash

# Autocommitting with inotify (repo: outline)

repos=outline

for r in $repos
do
    cd -- "${XDG_DOCUMENTS_DIR}/Notizen/${r}" &&
    {
        git ls-files --deleted -z | xargs -0 git rm 1>/dev/null 2>&1
        git add -A . 1>/dev/null 2>&1
        git commit -m "inotify $(date)"
    }
done
