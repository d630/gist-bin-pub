#!/usr/bin/env bash

# blscd
# Copyright 2014 D630, GNU GPLv3
# https://github.com/D630/blscd

# Fork and rewrite in GNU bash of lscd v0.1 [GNU GPLv3] by hut aka. Roman
# Zimbelmann, https://github.com/hut/lscd

# -- LICENCE.

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

#printf '%s (%s)\n' "$BASH_VERSION" "${BASH_VERSINFO[5]}" && exit 0
#set -o xtrace #; exec 2>> ~/blscd.log
#set -o verbose
#set -o noexec
#set -o errexit
#set -o nounset
#set -o pipefail
#trap '(read -p "[$BASH_SOURCE:$LINENO] $BASH_COMMAND?")' DEBUG

# -- SETTINGS.

#declare vars_base=$(set -o posix ; set)

# -- FUNCTIONS.

__blscd_draw()
{
    declare -i \
        cols= \
        cols_length= \
        i= \
        lines=

    declare \
        footer1= \
        footer2= \
        footer3= \
        footer4= \
        footer5= \
        footer6= \
        footer7= \
        footer_link= \
        header= \
        parent=

    tput civis

    mapfile -t files_col_2 < <(__blscd_listfiles $search_pattern)
    total_files_col_2=${#files_col_2[@]}
    printf -v current_line '%s' "${files_col_2[$index + $cursor - 1]}"
    read -r cols lines <<<$(tput cols ; tput lines)
    cols_length=$(((cols - 6 - col_0_line_longest) / 3))
    col_2_line_longest=$(printf '%s\n' "${files_col_2[@]:$((index - 1)):$((lines - 2))}" | cut -c 1-"$cols_length" | wc -L)

    if ((total_files_col_2 > (lines - offset + 1)))
    then
        total_visible_files_col_2=$((lines - offset + 1))
    else
        total_visible_files_col_2=$total_files_col_2
    fi

    if [[ $reprint == reprint ]]
    then
        for ((i=$lines ; i > 0 ; --i))
        do
            tput cup "$((i - 1))" 0
            tput el
        done
        if [[ $PWD != / ]]
        then
            parent=${PWD%/*}
            mapfile -t files_col_1 < <(find -L "${parent:-/}" -mindepth 1 -maxdepth 1 -printf '%f\n' | cut -c 1-"$cols_length" | sort -bg)
            total_files_col_1=${#files_col_1[@]}
        else
            files_col_1=(\~)
            total_files_col_1=0
        fi
        col_1_line_longest=$(printf '%s\n' "${files_col_1[@]:$((index - 1)):$((lines - 2))}" | wc -L)
        mapfile -t files_col_0 < <(eval "printf '%0${col_0_line_longest}d\n' {1..${max_number}}")
    else
        if ((total_files_col_3 < lines))
        then
            i=$total_files_col_3
        else
            i=$((lines - 1))
        fi
        for ((i=$i ; i > 0 ; --i))
        do
            tput cup "$i" "$((col_0_line_longest + col_1_line_longest + col_2_line_longest +6))"
            tput el
        done
    fi

    mapfile -t files_col_3 < <(find -L "$current_line" -mindepth 1 -maxdepth 1 -printf '%f\n' | cut -c 1-"$((cols - col_0_line_longest - col_1_line_longest - col_2_line_longest - 6))" | sort -bg)
    total_files_col_3=${#files_col_3[@]}
    ((total_files_col_3 == 0)) && \
        files_col_3=("$(file --mime-type -bL "$current_line")") && \
        files_col_3=("${files_col_3[@]//\//-}") && \
        total_files_col_3=1

    tput -S < <(printf '%s\n' home el bold)
    printf -v header "%d %0${col_0_line_longest}d %0${col_0_line_longest}d %0${col_0_line_longest}d %s" "$max_number" "$total_files_col_1" "$total_files_col_2" "$total_files_col_3" "$(tput setaf 2)${USER}@${HOSTNAME}:$(tput setaf 4)${PWD}/$(tput setaf 7)${current_line}"
    printf '%s\n' "${header//\/\//\/}" | cut -c 1-"$cols"
    tput sgr0

    paste -d '/' \
        <(printf '%s\n' "${files_col_0[@]:$((index - 1)):$((lines - 3))}") \
        <(printf '%s\n' "${files_col_1[@]:$((index - 1)):$((lines - 3))}") \
        <(printf '%s\n' "${files_col_2[@]:$((index - 1)):$((lines - 3))}" | cut -c 1-"$cols_length") \
        <(printf '%s\n' "${files_col_3[@]:0:$((lines - 3))}") | \
        column -tn -s '/'

    tput -S < <(printf '%s\n' "setaf 2" bold)
    read -r footer1 footer2 footer3 footer4 footer5 footer6 footer7 _ _ footer_link \
        <<<$(ls -abdlQ --time-style=long-iso --si --block-size=k "${PWD}/${current_line}")
    [[ $footer_link ]] &&
    {
        if [[ ${footer_link:0:2} != \"/ ]]
        then
            footer_link=" -> $(readlink -s -m "${PWD}/${current_line}")"
        else
            footer_link=" -> ${footer_link}"
        fi
    }
    tput setaf 4
    tput el
    printf '%s%s\n' "${footer1} $(tput sgr0)${footer2} ${footer3} ${footer4} ${footer5} ${footer6} ${footer7}" "$footer_link" | cut -c 1-"$cols"
    tput sgr0

    tput cup "$((cursor + 1))" "$((col_0_line_longest + col_1_line_longest + 4))"

    tput cvvis
}

__blscd_move()
{
    local arg="$1"
    local new_cursor

    redraw=redraw
    max_index="$((total_files_col_2 - total_visible_files_col_2 + 1))"
    max_cursor="$((total_visible_files_col_2 - 1))"

    # Save the previous index value to determine if ui should be redrawn
    old_index="$index"

    # Add the argument to the current cursor
    cursor="$((cursor + arg))"

    if [ "$cursor" -ge "$total_visible_files_col_2" ]; then
        # Cursor moved past the bottom of the list

        if [ "$total_visible_files_col_2" -ge "$total_files_col_2" ]; then
            # The list fits entirely on the screen.
            index=1
        else
            # The list doesn't fit on the screen.
            if [ "$((index + cursor))" -gt "$total_files_col_2" ]; then
                # Cursor out of bounds. Put it at the very bottom.
                index="$max_index"
            else
                # Move the index down so the visible part of the list
                # also shows the cursor
                difference="$((total_visible_files_col_2 - 1 - cursor))"
                index="$((index - difference))"
            fi
        fi

        # In any case, place the cursor on the last file.
        cursor="$max_cursor"
    fi

    if [ "$cursor" -lt 0 ]; then
        # Cursor is above the list, so scroll up.
        index="$((index + cursor))"
        cursor=0
    fi

    # The index should always be >0 and <$max_index
    [ "$index" -gt "$max_index" ] && index="$max_index"
    [ "$index" -lt 1 ] && index=1

    if [ "$index" != "$old_index" ]; then
        # Redraw if the index (and thus the visible files) has changed
        reprint=reprint

        # Jump a step when scrolling
        if [ "$index" -gt "$old_index" ]; then
            # Jump a step down
            step="$((max_index - index))"
            [ "$step" -gt "$INT_step" ] && step="$INT_step"
            index="$((index + step))"
            cursor="$((cursor - step))"
        else
            # Jump a step up
            step="$((index - 1))"
            [ "$step" -gt "$INT_step" ] && step="$INT_step"
            index="$((index - step))"
            cursor="$((cursor + step))"
        fi
    fi

    # The index should always be >0 and <$max_index
    [ "$index" -gt "$max_index" ] && index="$max_index"
    [ "$index" -lt 1 ] && index=1
}

__blscd_listfiles()
{
    __blscd_find()
    {
       find -L "$PWD" -mindepth 1 -maxdepth 1 -printf '%f\n' | sort -bg
    }

    if [[ $1 ]]
    then
        __blscd_find | egrep -e "$1"
    else
        __blscd_find
    fi
}

__blscd_movedir()
{
    __blscd_resize
    index=1
    cursor=0
    search_pattern=
    cd -- "$1"
}

__blscd_openfile()
{
    case $(file --mime-type -bL "$1") in
        inode/directory)
                __blscd_movedir "$1"
                ;;
        *)
                eval "$file_opener" 2>/dev/null
                ;;
    esac
}

__blscd_resize()
{
    redraw=redraw
    reprint=reprint
}

__blscd_on_exit()
{
    stty $stty_orig
    eval "$save_traps"
    tput clear
    tput rmcup
}

# -- MAIN.

declare -i \
    cursor=0 \
    index=1 \
    offset=4 \
    total_files_col_1=0 \
    total_files_col_2=0 \
    total_files_col_3=0 \
    total_visible_files_col_2=0

# Variables related to the TUI.
declare \
    current_line= \
    input= \
    redraw=redraw \
    reprint=reprint

declare -i \
    col_0_line_longest=4 \
    col_1_line_longest= \
    col_2_line_longest=

declare -a \
    files_col_0=() \
    files_col_1=() \
    files_col_2=() \
    files_col_3=()

# Initialize settings.
declare \
    file_opener='xterm -e "less -nR "$1";exit;bash"' \
    INT_step=6 \
    max_number=9999 \
    search_pattern=

# Save the terminal environment of the normal screen.
declare \
    save_traps=$(trap) \
    stty_orig=$(stty -g)

# Go to the alternate screen and change the terminal enviroment.
tput smcup
stty -echo

#trap 'tput rmcup' EXIT
trap '__blscd_resize' SIGWINCH
trap 'tput clear' SIGINT

export LC_ALL=C.UTF-8

while :
do
    [[ $redraw == redraw ]] &&
    {
        __blscd_draw
        redraw=
        reprint=
    }
    read -s -n 1 input
    case $input in
        j)
                __blscd_move 1
                ;;
        k)
                __blscd_move -1
                ;;
        h)
                __blscd_movedir ..
                ;;
        l)
                __blscd_openfile "$current_line"
                __blscd_resize
                ;;
        d)
                __blscd_move 10
                ;;
        u)
                __blscd_move -10
                ;;
        g)
                __blscd_move -9999999999
                ;;
        G)
                __blscd_move 9999999999
                ;;
        o)
                fsfzf.sh "$parent"
                __blscd_resize
                ;;
        f)
                # Open a prompt for entering the filter.
                tput cup "99998" 0
                stty $stty_orig
                read -re -p / search_pattern
                stty -echo
                __blscd_resize
                __blscd_move -9999999999
                ;;
        q)
                __blscd_on_exit
                break
                ;;
    esac
done
