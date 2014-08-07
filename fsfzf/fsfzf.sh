#!/usr/bin/env bash

# Use fzf (>= v0.8.6) to interactively browse parts of your file system
# Mentioned here: https://github.com/junegunn/fzf/issues/70

# -- DEBUGGING.

#printf '%s (%s)\n' "$BASH_VERSION" "${BASH_VERSINFO[5]}" && exit 0
#set -o xtrace #; exec 2>> ~/fsfzf.log
#set -o verbose
#set -o noexec
#set -o errexit
#set -o nounset
#set -o pipefail
#trap '(read -p "[$BASH_SOURCE:$LINENO] $BASH_COMMAND?")' DEBUG

# -- SETTINGS.

#declare vars_base=$(set -o posix ; set)

# -- FUNCTIONS.

__fsfzf_menu_cmd() { sort -r | fzf -x -i +s --prompt="${1:->} " ; }

__fsfzf_find_inum()
{
    find -H "$1" -mindepth 1 -maxdepth 1 -inum "$2" \
        -printf '%f\n' 2>/dev/null
}

__fsfzf_find_child_ls()
{
    printf '%s\n%s\n' "[.]" '[..]'
    # -printf '%M %n %u %g %s %t %f %l\n'
    find -H "$1" -mindepth 1 -maxdepth 1 -ls
}

__fsfzf_browse()
{
    declare \
            child_ls= \
            child_name \
            parent_name=$1 \
            root=/

    [[ $parent_name == . ]] && parent_name=$PWD
    [[ ${parent_name:0:1} != / ]] && parent_name=${HOME}/${parent_name}
    [[ ${parent_name:${#parent_name}-1} == / ]] &&
        parent_name=${parent_name%/*}
    read -r child_ls < <(__fsfzf_find_child_ls "$parent_name" | \
        __fsfzf_menu_cmd "[${parent_name}]")
    child_name=$parent_name

    case $child_ls
    in
        \[.\])
                : ;;
        \[..\])
                parent_name=${parent_name%/*}
                [[ ! $parent_name ]] && parent_name=$root
                ;;
        *)
                child_name=$(__fsfzf_find_inum "$parent_name" \
                    "${child_ls%% *}")
                parent_name=${parent_name}/${child_name}
                parent_name=${parent_name//\/\//\/}
    esac

    builtin cd -- "$parent_name"

    while [[ $child_name ]]
    do
        read -r child_ls < <(__fsfzf_find_child_ls "$parent_name" | \
            __fsfzf_menu_cmd "[${parent_name}]")
        case $child_ls
        in
            \[.\])
                    : ;;
            \[..\])
                    parent_name=${parent_name%/*}
                    [[ ! $parent_name ]] && parent_name=$root
                    ;;
            *)
                    child_name=$(__fsfzf_find_inum "$parent_name" \
                        "${child_ls%% *}")
                    if [[ ! -d ${parent_name}/${child_name} ]]
                    then
                        case $(file --mime-type -bL \
                            "${parent_name}/${child_name}")
                        in
                            image*)
                                    w3m -o 'ext_image_viewer=off' \
                                        -o 'imgdisplay=w3mimgdisplay' \
                                        "${parent_name}/${child_name}"
                                    ;;
                            *)
                                    elinks "${parent_name}/${child_name}"
                                    ;;
                        esac
                    else
                        parent_name=${parent_name}/${child_name}
                        parent_name=${parent_name//\/\//\/}
                    fi
        esac
        builtin cd -- "$parent_name"
    done
}

# -- MAIN.

__fsfzf_browse "${1:-${PWD}}"
