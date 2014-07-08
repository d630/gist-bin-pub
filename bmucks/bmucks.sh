#!/usr/bin/env bash

# bmucks
# Copyright 2014 D630
# https://gist.github.com/D630/737d38d895121bdfe197

# Forked from https://bitbucket.org/zserge/mucks

# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation, either version 3 of the License, or (at your
# option) any later version.

# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
# for more details.

# You should have received a copy of the GNU General
# Public License along with this program. If not, see
# <http://www.gnu.org/licenses/gpl-3.0.html>.

# -- DEBUGGING.

#printf "%s (%s)\n" "$BASH_VERSION" "${BASH_VERSINFO[5]}" && exit 0
#set -o xtrace #; exec 2>> "${X_XDG_LOG_HOME}/bmux.log
#set -o verbose
#set -o noexec
#set -o errexit
#set -o nounset
#set -o pipefail
#trap "(read -p "[$BASH_SOURCE:$LINENO] $BASH_COMMAND?")" DEBUG

# -- SETTINGS.

#declare vars_base=$(set -o posix ; set)

# -- FUNCTIONS.

__bmucks_parse_config()
{
    declare -a windows=()
    declare -A panes
    declare \
            bmucks= \
            dir= \
            i= \
            j= \
            name= \
            panes_nr=0

    source "$1" &&
    {
        CONFIG_bmucks=$bmucks
        CONFIG_name=$name

        __bmucks_choose_bmucks

        for ((i=0 ; i < ${#windows[@]} ; ++i))
        do
            if ((i == 0))
            then
                __bmucks_new_session "${TMP}/${CONFIG_id}" "$CONFIG_id" "${windows[$i]}"
            else
                __bmucks_new_window "${TMP}/${CONFIG_id}" "${windows[$i]}"
            fi
            while [[ ${panes[${windows[$i]} ${panes_nr}]} ]]
            do
                [[ ${panes[${windows[$i]} ${panes_nr}]} ]] && ((panes_nr++))
            done
            for ((j=0 ; j <= ${panes_nr} ; ++j))
            do
                case ${panes[${windows[$i]} ${j}]%% *} in
                    split|hsplit) __bmucks_hsplit "${TMP}/${CONFIG_id}" "${windows[$i]}"                   ;;
                    vsplit)       __bmucks_vsplit "${TMP}/${CONFIG_id}" "${windows[$i]}"                   ;;
                    layout)       __bmucks_layout "${TMP}/${CONFIG_id}" "${panes[${windows[$i]} ${j}]#* }" ;;
                    sleep)        sleep ${panes[${windows[$i]} ${j}]#* }                                   ;;
                    *)            __bmucks_send "${TMP}/${CONFIG_id}" "${panes[${windows[$i]} ${j}]}" "$j" ;;
                esac
            done
        done
        __bmucks_finalize "${TMP}/${CONFIG_id}" "${CONFIG_id}"
    }
}

__bmucks_choose_bmucks()
{
    case $bmucks in
        tmux)
                __bmucks_new_session() { tmux -S "$1" new-session -d -s "$2" -n "$3" ; }
                __bmucks_new_window() { tmux -S "$1" new-window -n "$2" ; }
                __bmucks_hsplit() { tmux -S "$1" split-window -v ; }
                __bmucks_vsplit() { tmux -S "$1" split-window -h ; }
                __bmucks_layout() { tmux -S "$1" select-layout $2 ; }
                __bmucks_send() { tmux -S "$1" send-keys "$2" "C-m" ;}
                __bmucks_finalize() { tmux -S "$1" attach-session -t "$2" ; }
                ;;
        screen)
                __bmucks_new_session() { screen -d -m -S "${1##*/}" -t "$3" ${SHELL:-bash} ; }
                __bmucks_new_window() { screen -S "${1##*/}" -X screen -t "$3" ${SHELL:-bash} ; }
                __bmucks_hsplit() { screen -S "${1##*/}" -X screen -t "$2" ${SHELL:-bash} ; }
                __bmucks_vsplit() { screen -S "${1##*/}" -X screen -t "$2" ${SHELL:-bash} ; }
                __bmucks_send() { screen -S "${1##*/}" -p "$3" -X stuff "$2" ;}
                __bmucks_finalize() { screen -r "$2" ; }
                ;;
        dvtm)
                :
                ;;
    esac
}

# -- MAIN.

declare \
        CONFIG_bmucks=tmux \
        CONFIG_file=${XDG_CONFIG_HOME}/bmucksrc \
        CONFIG_id=bmucks$$ \
        CONFIG_name=bmucks \
        TMP=${TMPDIR:-/${TMP}}

trap "{ rm -f ${TMP}/${CONFIG_id} ; exit 255 ; }" EXIT

__bmucks_parse_config "${1:-${CONFIG_file}}" 2>/dev/null || { printf '%s\n' "${0}:Error:79: No conf file has been sourced." 1>&2 ; exit 79 ; }
