#!/usr/bin/env bash

# furlview.sh

# Use fzf (>= v0.8.6) to browse lists with urls and then to browse your choice(s) with qupzilla or elinks
# Simple replacement for urlview
# Mentioned here: https://github.com/junegunn/fzf/issues/70

# See furlview_elinks.sh

# Usage:
# from a tty:
#             $ printf '%s\n' LIST | furlview.sh -
#             $ furlview.sh - < <(printf '%s\n' LIST) ...
#             $ furlview.sh <(printf '%s\n' LIST) ...
#             $ furlview.sh FILE ...
# from a gui (LIST should expanded like ${ARRAY[*]}):
#             $ xterm -name "furlview-xterm" -e "printf '%s\n' LIST | furlview.sh -;exit;bash"
#             $ xterm -name "furlview-xterm" -e "furlview.sh - < <(printf '%s\n' LIST);exit;bash"
#             $ xterm -name "furlview-xterm" -e "furlview.sh "<(printf '%s\n' LIST)" ... ;exit;bash"
#             $ xterm -name "furlview-xterm" -e "furlview.sh "FILE" ... ;exit;bash"

declare \
        time=0 \
        url=
declare -a furls=()

if (($# == 0))
then
    { echo "No args." 1>&2 ; exit 1 ; }
elif [[ $1 == - ]]
then
    if [[ -p /dev/stdin ]]
    then
        shift 1
        mapfile -t furls < <(while read -r ; do printf '%s\n' "$REPLY" ; done | fzf -e -i -m --print-query |
        grep -oP -e '((http|https|gopher|ftp|ftps|webdav|webdavs|dav|davs):(//)?[^ <>"\t]*|(www|ftp)[0-9]?\.[-a-z0-9.]+)[^ .,;\t\n\r<">\):]?[^, <>"\t]*[^ .,;\t\n\r<">\):]')
    else
        { echo "Stdin is not coming from a pipe." 1>&2 ; exit 1 ; }
    fi
else
    mapfile -t furls < <(
    for arg
    do
        if [[ -p $1 || -f $1 ]]
        then
            while read -r
            do
                printf '%s\n' "$REPLY"
            done < "$1"
        else
            { echo "File ""$1"" does not exist or is neather a regular file nor a named pipe." 1>&2 ; exit 1 ; }
        fi
        shift 1
    done | fzf -e -i -m --print-query |
        grep -oP -e '((http|https|gopher|ftp|ftps|webdav|webdavs|dav|davs):(//)?[^ <>"\t]*|(www|ftp)[0-9]?\.[-a-z0-9.]+)[^ .,;\t\n\r<">\):]?[^, <>"\t]*[^ .,;\t\n\r<">\):]')
fi

[[ ! ${furls[@]} ]] && { echo "No url has been chosen." 1>&2 ; exit 1 ; }

if [[ $(xprop -id "$WINDOWID" WM_CLASS 2>/dev/null) =~ furlview-xterm ]]
then
    for url in "${furls[@]}"
    do
        (exec qupzilla "$url" &)
        ((time++))
    done
else
    (($(pgrep -cf furlview_elinks.sh) == 0)) &&
    (exec xterm -name "furlview-elinks" -e "furlview_elinks.sh ${furls[0]};exit;bash" 2>/dev/null &)
    for url in "${furls[@]}"
    do
        (exec elinks -session-ring 1 -remote "openURL("$url", new-tab)" 2>/dev/null &)
        ((time++))
        sleep 1
    done
fi

sleep "${time:-1}" && exit 0
