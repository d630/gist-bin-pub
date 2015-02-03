#!/usr/bin/env bash

# List inits

{
    find "/etc/init.d/" -perm /111 -type f -printf '%f\n'
    while IFS= read -r -d ''
    do
        printf '%s\n' "${REPLY%*.*}"
    done < <(find "/etc/init" -type f -printf '%f\0')
} | sort -u > "${X_XDG_BACKUPS_DIR}/init.txt"
