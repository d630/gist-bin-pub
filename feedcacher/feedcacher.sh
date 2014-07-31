#!/usr/bin/env bash

# Simple feed downloader based on urldiff (https://github.com/D630/urldiff)

declare -r feedcacherdir=${XDG_DATA_HOME}/feedcacher
declare -r cachedir=${feedcacherdir}/cache
declare -r urllist=${feedcacherdir}/urls.txt
declare -r reportnew=${feedcacherdir}/report.txt
declare -r table=${feedcacherdir}/table.txt

export cachedir \
        reportnew \
        table

__feedcacher_do()
{
    url=$1
    if [[ $url == http*://*.* ]]
    then
        filename=$(sed 's#_#-#g;s# #_#g;s#\/#_#g' <<< "$url" | colrm 121)
        onlinexml=${cachedir}/${filename}.xml
        wget -t 1 --no-http-keep-alive --no-cache --no-cookies --ignore-length --content-on-error -L -E -O - "$url" > "$onlinexml"
        if [[ $(stat -c %s "$onlinexml" 2>/dev/null) -ge 2 ]]
        then
            printf '%s\n' "${url} ${onlinexml##*/}" >> "$table"
            printf '%s\n' "SUCCESS $(date +%Y-%m-%d_%H:%M) URL:${url} synchronized." 1>&3
        else
            rm -- "$onlinexml"
            printf '%s\n' "FAIL $(date +%Y-%m-%d_%H:%M) URL:${url} unattainable." 1>&3
            return 1
        fi
    else
        printf '%s\n' "FAIL $(date +%Y-%m-%d_%H:%M) URL:${url} does not match." 1>&3
        return 1
    fi
}

# --- Main

export -f __feedcacher_do

# Check connection status.
if ! ping -c1 google.com 1>/dev/null 2>&1
then
    if ! wget -O - google.com 1>/dev/null 2>&1
    then
        # We are probably offline.
        { echo "ERROR We are probably offline." 1>&2 ; exit 1 ; }
    fi
fi

[[ ! -d $cachedir ]] && mkdir -p "$cachedir"
[[ -f $reportnew ]] && rm -- "$reportnew"
[[ -f $table ]] && rm -- "$table"
[[ -d $cachedir ]] && { rm -r -- "$cachedir" ; mkdir -p "$cachedir" ; }

tput bold setaf 7 ; printf '\n%s\n' "CHECK" ; tput sgr0
exec 3>>"$reportnew"
grep -v -e '^#http' "$urllist" | xargs -n 1 -P 8 -i bash -c '__feedcacher_do "$@"' _ {} +
exec 3<&-

if [[ $(stat -c %s "$reportnew" 2>/dev/null) -ge 2 ]]
then
    tput bold setaf 7 ; printf '\n%s\n' "REPORT" ; tput sgr0
    sed -n p "$reportnew"
else
    printf '%s\n' "ERROR $(date +%Y-%m-%d_%H:%M) Report has not been created." 1>&2
fi
