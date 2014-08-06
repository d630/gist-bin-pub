#!/usr/bin/env bash

# Use fzf (>= v0.8.6) to interactively browse parts of your file system
# Mentioned here: https://github.com/junegunn/fzf/issues/70

__fzf_hier()
{
    declare \
            child= \
            parent=$1 \
            home_root=/home

    __menu_cmd() { sort -r | fzf -x -i +s --prompt="${1:->} " ; }

    child=$(find -H "$parent" -mindepth 1 -maxdepth 1 \
                 -printf '%f\n' |
                 __menu_cmd "[${parent}]")
    parent=${parent}/${child}

    while [[ $child ]]
    do
        child=$({ printf '%s\n%s\n' "[.]" '[..]' ; find -H "${parent}" \
                -mindepth 1 -maxdepth 1 -printf '%f\n' ; } | \
                __menu_cmd "[${parent}]")
        case $child in
            \[..\])
                        [[ ${parent%/*} != $home_root ]] &&
                        parent=${parent%/*}
                        ;;
            \[.\])
                        parent=$parent
                        ;;
            *)          if [[ -f ${parent}/${child} ]]
                        then
                            : # xdg-open "$child"
                        else
                            parent=${parent}/${child}
                        fi
        esac
    done
}

__fzf_hier "$(pwd)"
