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

__blscd_draw_screen()
{
    declare -i \
        i= \
        j= \
        screen_cols_length= \
        screen_dimension_cols= \
        screen_dimension_lines= \
        screen_lines_body= \
        highlight_line_col_3_index=

    declare \
        dir_col_0_string= \
        dir_col_1_string= \
        footer10_string= \
        footer11_string= \
        footer1_string= \
        footer2_string= \
        footer3_string= \
        footer4_string= \
        footer5_string= \
        footer6_string= \
        footer7_string= \
        footer8_string= \
        footer9_string= \
        screen_lines_body_col_1_color_1= \
        screen_lines_body_col_1_color_reset= \
        screen_lines_body_col_2_color_1= \
        screen_lines_body_col_2_color_reset= \
        screen_lines_body_col_3_color_1= \
        screen_lines_body_col_3_color_reset= \
        screen_lines_footer_string=

    # Get dimension.
    read -r screen_dimension_cols screen_dimension_lines <<<$(tput cols ; tput lines)
    screen_cols_length=$(((screen_dimension_cols - 2) / 3))
    screen_lines_body=$((screen_dimension_lines - screen_lines_offset + 1))

    # Save directories.
    dir_col_0_string=${PWD%/*}
    dir_col_0_string=${dir_col_0_string:-/}
    dir_col_1_string=$PWD

    if [[ ($reprint == reprint && $action_last != __blscd_move_col_2_line) || $search_pattern ]]
    then
        tput clear
        # Build column 1 and 2.
        __blscd_build_array 1 2
        __blscd_build_col 1a 2a
    else
        # Delete obsolete lines in column 3.
        if ((files_col_3_array_total <= 15))
        then
            if ((files_col_3_array_total < screen_lines_body))
            then
                i=$files_col_3_array_total
            else
                i=$screen_lines_body
            fi
            for ((i=$i ; i > 1 ; --i))
            do
                tput cup "$i" "$(((screen_cols_length * 2) + 2))"
                tput el
            done
        else
            ((files_col_3_array_total < screen_lines_body && files_col_1_a_array_total > 5)) &&
            {
                tput cup 2 0
                for ((i=${files_col_3_array_total} ; i < screen_lines_body ; ++i))
                do
                    printf "%-${screen_cols_length}.${screen_cols_length}s\n" ""
                done
            }
        fi
        __blscd_build_col 2a
    fi

    # Save current line.
    printf -v screen_lines_current_string '%s' "${files_col_2_a_array[$cursor]}"

    # Build column 3.
    __blscd_build_array 3
    __blscd_build_col 3a

    # Save current cursor postion, and index.
    arrays[cursor $PWD]=$cursor
    arrays[index $PWD]=$index

    # Preparing for __blscd_move_col_2_line(): Determine the number of visible files.
    if ((files_col_2_array_total > screen_lines_body))
    then
        screen_lines_body_col_2_visible=$screen_lines_body
    else
        screen_lines_body_col_2_visible=$files_col_2_array_total
    fi

    # Print the header.
    if [[ ($reprint == reprint && $action_last != __blscd_move_col_2_line) || $search_pattern ]]
    then
        tput cup 0 0
        tput -S < <(printf '%s\n' bold "setaf 4")
        printf -v screen_lines_header_string "%s@%s:$(tput setaf 2)%s/$(tput setaf 7)%s" "$USER" "$HOSTNAME" "$PWD" "$screen_lines_current_string"
    else
        if [[ $PWD == / ]]
        then
            tput cup 0 "$((${#USER} + ${#HOSTNAME} + ${#PWD} + 2))"
        else
            tput cup 0 "$((${#USER} + ${#HOSTNAME} + ${#PWD} + 3))"
        fi
        tput -S < <(printf '%s\n' el bold "setaf 4")
        printf -v screen_lines_header_string "$(tput setaf 7)%s" "$screen_lines_current_string"
    fi
    printf "%s\n" "${screen_lines_header_string//\/\//\/}"
    tput sgr0

    # Print columns with file listing and highlight lines.
    tput cup 1 0
    for ((i=0 ; i <= screen_lines_body ; ++i))
    do
        screen_lines_body_col_1_color_1=
        screen_lines_body_col_2_color_1=
        screen_lines_body_col_3_color_1=
        screen_lines_body_col_1_color_reset=
        screen_lines_body_col_2_color_reset=
        screen_lines_body_col_3_color_reset=
        ((i == highlight_line_col_1_index)) &&
        {
            screen_lines_body_col_1_color_1=$(tput -S < <(printf '%s\n' bold "setaf 0" "setab 2"))
            screen_lines_body_col_1_color_reset=$(tput sgr0)
        }
        ((i == cursor)) &&
        {
            if [[ -d $screen_lines_current_string ]]
            then
                screen_lines_body_col_2_color_1=$(tput -S < <(printf '%s\n' bold "setaf 0" "setab 2"))
            elif [[ -f $screen_lines_current_string ]]
            then
                screen_lines_body_col_2_color_1=$(tput -S < <(printf '%s\n' bold "setaf 0" "setab 7"))
            else
                screen_lines_body_col_2_color_1=$(tput -S < <(printf '%s\n' bold "setaf 7" "setab 1"))
            fi
            screen_lines_body_col_2_color_reset=$(tput sgr0)
        }
        ((i == highlight_line_col_3_index)) &&
        {
            if [[ -d ${screen_lines_current_string}/${files_col_3_array[$i]} ]]
            then
                screen_lines_body_col_3_color_1=$(tput -S < <(printf '%s\n' bold "setaf 0" "setab 2"))
            elif [[ -f ${screen_lines_current_string}/${files_col_3_array[$i]} ]]
            then
                screen_lines_body_col_3_color_1=$(tput -S < <(printf '%s\n' bold "setaf 0" "setab 7"))
            else
                screen_lines_body_col_3_color_1=$(tput -S < <(printf '%s\n' bold "setaf 7" "setab 1"))
            fi
            screen_lines_body_col_3_color_reset=$(tput sgr0)
        }
        printf "${screen_lines_body_col_1_color_1}%-${screen_cols_length}.${screen_cols_length}s${screen_lines_body_col_1_color_reset} ${screen_lines_body_col_2_color_1}%-${screen_cols_length}.${screen_cols_length}s${screen_lines_body_col_2_color_reset} ${screen_lines_body_col_3_color_1}%-${screen_cols_length}.${screen_cols_length}s${screen_lines_body_col_3_color_reset}\n" " ${files_col_1_a_array[$i]} " " ${files_col_2_a_array[$i]} " " ${files_col_3_a_array[$i]} "
    done

    # Print the footer.
    tput -S < <(printf '%s\n' bold "setaf 4")
    read -r footer1_string footer2_string footer3_string footer4_string footer5_string footer6_string footer7_string _ _ footer8_string \
        <<<$(ls -abdlQh --time-style=long-iso "${PWD}/${screen_lines_current_string}")
    read -r footer9_string footer10_string footer11_string <<<"$((index + cursor)) ${files_col_2_array_total} $(((100 * (index + cursor)) / files_col_2_array_total))"
    tput cup "$((screen_lines_body + 1))" 0
    tput el
    printf -v screen_lines_footer_string "%s %s %s %s %s %s %s${footer8_string:+ -> %s}  %s/%s  %d%%" "$footer1_string" "$footer2_string" "$footer3_string" "$footer4_string" "$footer5_string" "$footer6_string" "$footer7_string" ${footer8_string:+"${footer8_string}"} "$footer9_string" "$footer10_string" "$footer11_string"
    printf "%s$(tput sgr0) %s %s %s %s %s${footer8_string:+ %s ->} %-$((screen_dimension_cols - ${#screen_lines_footer_string} + ${#footer7_string} ${footer8_string:++ $((${#footer8_string} - ${#footer7_string}))}))s  %s/%s  %d%%" "$footer1_string" "$footer2_string" "$footer3_string" "$footer4_string" "$footer5_string" "$footer6_string" "$footer7_string" ${footer8_string:+"${footer8_string}"} "$footer9_string" "$footer10_string" "$footer11_string"
    tput sgr0

    # Set new position of the cursor.
    tput cup "$((cursor + 1))" "$((screen_cols_length + 2))"
}

__blscd_build_array()
{
    declare i=

    for i
    do
        case $i in
            1)
                if [[ $dir_col_1_string == / ]]
                then
                    files_col_1_array=(\~)
                    files_col_1_array_cursor_index=0
                else
                    mapfile -t files_col_1_array < <(printf '%s\n' "${arrays[path $dir_col_0_string]//|/}")
                fi
                files_col_1_array_total=${#files_col_1_array[@]}
                ;;
            2)
                [[ ! ${arrays[path $dir_col_1_string]} ]] && __blscd_build_array_update
                mapfile -t files_col_2_array < <(printf '%s\n' "${arrays[path $dir_col_1_string]//|/}")
                files_col_2_array_total=${#files_col_2_array[@]}
                ((files_col_2_array_total == 0)) && files_col_2_array_total=1
                ;;
            3)
                if [[ ${arrays[path ${dir_col_1_string}/${screen_lines_current_string}]} ]]
                then
                    mapfile -t files_col_3_array < <(printf '%s\n' "${arrays[path ${dir_col_1_string}/${screen_lines_current_string}]//|/}")
                else
                    mapfile -t files_col_3_array < <(find -L "$screen_lines_current_string" -mindepth 1 -maxdepth 1 -printf '%f\n' | sort -bg)
                fi
                files_col_3_array_total=${#files_col_3_array[@]}
                ((files_col_3_array_total == 0)) &&
                {
                    files_col_3_array=("$(file --mime-type -bL "$screen_lines_current_string")")
                    files_col_3_array=("${files_col_3_array[@]//\//-}")
                    files_col_3_array_total=1
                }
                ;;
        esac
    done
}

__blscd_build_col()
{
    declare i=

    for i
    do
        case $i in
            1a)
                if [[ $PWD == / ]]
                then
                    files_col_1_a_array=(\~)
                    highlight_line_col_1_index=0
                elif [[ ${arrays[cursor $dir_col_0_string]} ]]
                then
                    mapfile -t files_col_1_a_array < <(printf '%s\n' "${files_col_1_array[@]:$((${arrays[index $dir_col_0_string]} - 1)):${screen_lines_body}}")
                    highlight_line_col_1_index=${arrays[cursor $dir_col_0_string]}
                else
                    IFS=: read -r files_col_1_array_cursor_index _ < <(printf '%s\n' "${files_col_1_array[@]}" | grep -n "${dir_col_1_string##*/}")
                    ((--files_col_1_array_cursor_index))
                    if ((files_col_1_array_cursor_index >= screen_lines_body))
                    then
                        files_col_1_a_array=("${files_col_1_array[@]:$((files_col_1_array_cursor_index - screen_lines_body + 1)):${files_col_1_array_cursor_index}}")
                        highlight_line_col_1_index=$((screen_lines_body - 1))
                    else
                        files_col_1_a_array=("${files_col_1_array[@]:0:${screen_lines_body}}")
                        highlight_line_col_1_index=$files_col_1_array_cursor_index
                    fi
                fi
                files_col_1_a_array_total=${#files_col_1_a_array[@]}
                ;;
            2a)
                if [[ ${arrays[cursor $dir_col_1_string]} && $action_last != __blscd_move_col_2_line ]]
                then
                     mapfile -t files_col_2_a_array < <(printf '%s\n' "${files_col_2_array[@]:$((${arrays[index $dir_col_1_string]} - 1)):${screen_lines_body}}")
                     cursor=${arrays[cursor $dir_col_1_string]}
                     index=${arrays[index $dir_col_1_string]}
                elif [[ $dir_col_1_string == / && $dir_last ]]
                then
                     IFS=: read -r cursor _ < <(printf '%s\n' "${files_col_2_array[@]}" | grep -n "${dir_last##*/}")
                     files_col_2_a_array=("${files_col_2_array[@]}")
                     ((--cursor))
                else
                    files_col_2_a_array=("${files_col_2_array[@]:$((index - 1)):${screen_lines_body}}")
                fi
                ;;
            3a)
                if [[ ${arrays[cursor ${dir_col_1_string}/${screen_lines_current_string}]} ]]
                then
                    mapfile -t files_col_3_a_array < <(printf '%s\n' "${files_col_3_array[@]:$((${arrays[index ${dir_col_1_string}/${screen_lines_current_string}]} - 1)):${screen_lines_body}}")
                    highlight_line_col_3_index=${arrays[cursor ${dir_col_1_string}/${screen_lines_current_string}]}
                else
                    files_col_3_a_array=("${files_col_3_array[@]}")
                    highlight_line_col_3_index=0
                fi
                ;;
        esac
    done
}

__blscd_move_col_2_line()
{
    __blscd_set_action_last

    declare -i \
        arg=$1 \
        difference= \
        max_cursor=$((screen_lines_body_col_2_visible - 1))
        max_index=$((files_col_2_array_total - screen_lines_body_col_2_visible + 1))
        old_index=$index \
        step=

    redraw=redraw

    # Add the argument to the current cursor
    cursor=$((cursor + arg))

    if ((cursor >= screen_lines_body_col_2_visible))
    then
        # Cursor moved past the bottom of the list.
        if ((screen_lines_body_col_2_visible >= files_col_2_array_total))
        then
            # The list fits entirely on the screen.
            index=1
        else
            # The list doesn't fit on the screen.
            if ((index + cursor > files_col_2_array_total))
            then
                # Cursor out of bounds. Put it at the very bottom.
                index=$max_index
            else
                # Move the index down so the visible part of the list,
                # also shows the cursor.
                difference=$((screen_lines_body_col_2_visible - 1 - cursor))
                index=$((index - difference))
            fi
        fi
        # In any case, place the cursor on the last file.
        cursor=$max_cursor
    elif ((cursor <= 0))
    then
        # Cursor is above the list, so scroll up.
        index=$((index + cursor))
        cursor=0
    fi

    # The index should always be >0 and <$max_index.
    ((index > max_index)) && index=$max_index
    ((index < 1)) && index=1

    ((index != old_index)) &&
    {
        # Redraw if the index (and thus the visible files) has changed.
        reprint=reprint

        # Jump a step when scrolling.
        if ((index > old_index))
        then
            # Jump a step down.
            step=$((max_index - index))
            ((step > INT_step)) && step=$INT_step
            index=$((index + step))
            cursor=$((cursor - step))
        else
            # Jump a step up.
            step=$((index - 1))
            ((step > INT_step)) && step=$INT_step
            index=$((index - step))
            cursor=$((cursor + step))
        fi
    }

    # The index should always be >0 and <$max_index.
    ((index > max_index)) && index=$max_index
    ((index < 1)) && index=1
}

__blscd_move_dir()
{
    __blscd_set_resize

    __blscd_move_dir_up()
    {
        __blscd_set_action_last
        index=1
        cursor=0
    }

    __blscd_move_dir_down()
    {
        __blscd_set_action_last
        index=1
        cursor=0
    }

    if [[ $1 == .. ]]
    then
         __blscd_move_dir_up
    else
         __blscd_move_dir_down
    fi

    dir_last=$PWD
    builtin cd -- "$1"
    search_pattern=
}

__blscd_list_file()
{
    __blscd_find()
    {
        find -L "$PWD" -mindepth 1 -maxdepth 1 \
                \( -xtype l -type d -printf "%f\n" \) \
                -o \( -xtype l -type f -printf "%f\n" \) \
                -o \( -xtype d -type d -printf "%f\n" \) \
                -o \( -xtype f -type f -printf "%f\n" \) | \
            sort -bg
    }

    if [[ $1 ]]
    then
        __blscd_find | egrep -e "$1"
    else
        __blscd_find
    fi
}

__blscd_open_file()
{
    case $(file --mime-type -bL "$1") in
        inode/directory)
                 __blscd_move_dir "$1"
            ;;
        *)
            eval "$opener" 2>/dev/null
            ;;
    esac
}

__blscd_set_action_last() { action_last=${FUNCNAME[1]} ; }

__blscd_set_resize()
{
    redraw=redraw
    reprint=reprint
}

__blscd_on_exit()
{
    stty $saved_stty
    eval "$saved_traps"
    tput -S < <(printf '%s\n' clear rmcup cnorm am)
}

__blscd_build_array_initial()
{
    arrays[path /]=$(find -L "/" -mindepth 1 -maxdepth 1 -printf '|%f|\n' | sort -t '|' -k 2bg)

    __blscd_build_array_initial_do()
    {
        declare dir=$1
        arrays[path $dir]=$(find -L "$dir" -mindepth 1 -maxdepth 1 -printf '|%f|\n' | sort -t '|' -k 2bg)
        if [[ ${dir%/*} ]]
        then
            __blscd_build_array_initial_do "${dir%/*}"
        else
            return 0
        fi
    }
    __blscd_build_array_initial_do "$PWD"
}

__blscd_build_array_update()
{
    arrays[path $dir_col_1_string]=$(find -L "$dir_col_1_string" -mindepth 1 -maxdepth 1 -printf '|%f|\n' | sort -t '|' -k 2bg)
}

# -- MAIN.

declare -A arrays

declare -i \
    cursor=0 \
    files_col_1_a_array_total= \
    files_col_1_array_total= \
    files_col_2_array_total= \
    files_col_3_array_total= \
    index=1 \
    redraw_number= \
    screen_lines_body_col_2_visible= \
    screen_lines_offset=4

declare \
    action_last= \
    cursor_old= \
    dir_last=

# Variables related to the TUI.
declare \
    input= \
    k1= \
    k2= \
    k3= \
    redraw=redraw \
    reprint=reprint \
    screen_lines_current_string= \
    screen_lines_header_string=

declare -i \
      files_col_1_a_array_current_index= \
  files_col_1_array_cursor_index= \
    highlight_line_col_1_index= \
    highlight_line_col_3_index= \
    query_chars=

declare -a \
    files_col_1_a_array=() \
    files_col_1_array=() \
    files_col_2_a_array=() \
    files_col_2_array=() \
    files_col_3_a_array=() \
    files_col_3_array=()

# Initialize settings.
declare \
    INT_step=6 \
    opener='export LESSOPEN='"| /usr/bin/lesspipe %s"';less -R "$1"' \
    search_pattern=

# Save the terminal environment of the normal screen.
declare \
    saved_stty=$(stty -g) \
    saved_traps=$(trap)

# Go to the alternate screen and change the terminal enviroment.
tput smcup
stty -echo

#trap 'tput rmcup' EXIT
trap '__blscd_set_resize' SIGWINCH
trap 'tput clear' SIGINT

export LC_ALL=C.UTF-8

__blscd_build_array_initial

while :
do
    tput civis
    tput rmam
    [[ $redraw == redraw ]] &&
    {
        __blscd_draw_screen
        redraw=
        reprint=
        ((++redraw_number))
    }
    read -s -n 1 input
    read -s -N1 -t 0.0001 k1
    read -s -N1 -t 0.0001 k2
    read -s -N1 -t 0.0001 k3
    input=${input}${k1}${k2}${k3}
    case $input in
        j|$'\e[B')
            __blscd_move_col_2_line 1
            ;;
        k|$'\e[A')
            __blscd_move_col_2_line -1
            ;;
        h|$'\e[D')
            __blscd_move_dir ..
            ;;
        l|$'\e[C'|"")
            __blscd_open_file "$screen_lines_current_string"
            tput smcup
            __blscd_set_resize
            ;;
        d)
            __blscd_move_col_2_line 10
            ;;
        u)
            __blscd_move_col_2_line -10
            ;;
        g)
            __blscd_move_col_2_line -9999999999
            ;;
        G)
            __blscd_move_col_2_line 9999999999
            ;;
        $'\eh')
            builtin cd -- ..
            __blscd_set_resize
            ;;
        $'\el')
            tput cvvis
            tput am
            __blscd_open_file "$footer_link" #!
            __blscd_set_resize
            ;;
        o)
            tput cvvis
            tput am
            fsfzf.sh
            tput smcup
            __blscd_set_resize
            ;;
        f)
            tput cvvis
            tput am
            read -n 1 input
            case $input in
                q)
                    while :
                    do
                        tput cup "99998" 0
                        stty $saved_stty
                        query_chars=$((${#search_pattern} + 1))
                        read -e -N "$query_chars" -p "/" -i "$search_pattern" search_pattern
                        stty -echo
                        if [[ $search_pattern =~ $'\r' ]]
                        then
                            break
                        else
                            __blscd_set_resize
                            __blscd_draw_screen
                        fi
                    done
                    __blscd_set_resize
                    search_pattern=${search_pattern//$'\r'/}
                    __blscd_move_col_2_line -9999999999
                    ;;
                g)
                    tput cup "99998" 0
                    stty $saved_stty
                    read -e -p "/" -i "$search_pattern" search_pattern
                    stty -echo
                    __blscd_set_resize
                    __blscd_move_col_2_line -9999999999
                    ;;
            esac
            ;;
        r)
            search_pattern=
            ;&
        $'\x0c') # CTRL+L
            __blscd_set_resize
            ;;
        q)
            __blscd_on_exit
            break
            ;;
    esac
done
