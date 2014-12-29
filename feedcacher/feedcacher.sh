#!/usr/bin/env bash

# Simple feed downloader based on urldiff (https://github.com/D630/urldiff)

declare -r feedcacherdir=${X_XDG_LIB_DIR}/feedcacher
declare -xr cachedir=${feedcacherdir}/cache
declare -r urllist=${feedcacherdir}/urls.txt
declare -xr reportnew=${feedcacherdir}/report.txt
declare -xr table=${feedcacherdir}/table.txt

__feedcacher_do()
{
    declare \
        filename= \
        onlinexml= \
        url=${1,,}

    [[ $url == \#* ]] && return 1

    if [[ $url =~ ^https?://.*\.[a-z]*/.*$ ]]
    then
        filename=${url:0:121}
        filename=${filename//_/-}
        filename=${filename// /_}
        filename=${filename//\//_}
        onlinexml=${cachedir}/${filename}.xml
        wget -nv -t 1 --no-http-keep-alive --no-cache --no-cookies --ignore-length --content-on-error -L -E -O - "$1" > "$onlinexml"
        if [[ $(stat -c %s "$onlinexml" 2>/dev/null) -ge 2 ]]
        then
            printf '%s\n' "${1} ${onlinexml##*/}" >> "$table"
            printf '%s\n' "SUCCESS $(date +%Y-%m-%d_%H:%M) URL:${1} synchronized." 1>&3
        else
            rm -- "$onlinexml"
            printf '%s\n' "FAIL $(date +%Y-%m-%d_%H:%M) URL:${1} unattainable." 1>&3
            return 1
        fi
    else
        printf '%s\n' "FAIL $(date +%Y-%m-%d_%H:%M) URL:${1} does not match." 1>&3
        return 1
    fi
}

# --- Main

export -f __feedcacher_do

# Check connection status.
ping -c1 google.com 1>/dev/null 2>&1 ||
wget -O - google.com 1>/dev/null 2>&1 ||
{ echo "ERROR We are probably offline." 1>&2 ; exit 1 ; }

[[ -d $cachedir ]] || mkdir -p -- "$cachedir"
[[ -f $reportnew ]] && rm -- "$reportnew"
[[ -f $table ]] && rm -- "$table"
[[ -d $cachedir ]] && { rm -r -- "$cachedir" ; mkdir -p -- "$cachedir" ; }

tput bold setaf 7 ; printf '\n%s\n' "CHECK" ; tput sgr0
exec 3>>"$reportnew"
xargs -a "$urllist" -n 1 -P 8 -i bash -c '__feedcacher_do $@' _ {} +
exec 3<&-

if [[ $(stat -c %s "$reportnew" 2>/dev/null) -ge 2 ]]
then
    tput bold setaf 7 ; printf '\n%s\n' "REPORT" ; tput sgr0
    cat "$reportnew"
else
    printf '%s\n' "ERROR $(date +%Y-%m-%d_%H:%M) Report has not been created." 1>&2
fi
