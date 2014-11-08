#!/usr/bin/env bash

# Simple ad- and malware-blocking-list builder for dnsmasq
# inspired by hostblock (http://gaenserich.github.com/hostsblock)

set -e

declare -x \
    _hblock_cachedir=${X_XDG_LIB_DIR:-${HOME}/var/lib}/hblock \
    _hblock_tmpdir=${TMPDIR:-/tmp}/hblock

declare \
    hostfile=/etc/hosts.block \
    hostfile_head=/etc/hosts.regular

declare -a lists=(
    'http://winhelp2002.mvps.org/hosts.txt'
    'http://pgl.yoyo.org/as/serverlist.php?hostformat=hosts&mimetype=plaintext'
    'http://hosts-file.net/download/hosts.txt'
    'http://www.malwaredomainlist.com/hostslist/hosts.txt'
    #'http://hosts-file.net/.\ad_servers.txt'
    'http://hosts-file.net/hphosts-partial.txt'
    'http://hostsfile.org/Downloads/hosts.txt'
    'http://hostsfile.mine.nu/Hosts'
    'http://someonewhocares.org/hosts/hosts'
    'http://sysctl.org/cameleon/hosts'
)

__hblock_remove() { declare -g -a remove=("0.0.0.0 localhost") ; }

__hblock_do()
{
    declare outfile=${1//http:\/\//}
    outfile=${outfile//[\/\%\&\+\?\=\\]/\.}

    wget -nv -t 1 \
            --no-http-keep-alive \
            --no-cache \
            --no-cookies \
            --ignore-length \
            --content-on-error \
            -L -E \
            -O - "$1" | \
        tee "${_hblock_cachedir}/${outfile}.data" | \
        egrep -e '^(0.0.0.0|127.0.0.1)' | \
        sed \
            -e 's/^127.0.0.1/0.0.0.0/' \
            -e 's/\#.*//' \
            -e 's/[[:space:]][[:space:]]*/ /g' \
            -e 's/[[:space:]]$//' | \
        sort -n | \
        uniq | \
        fgrep -vx -f <(printf '%s\n' "${remove[@]}") \
        > "${_hblock_tmpdir}/${outfile}.clean"
}

export -f __hblock_do __hblock_remove
trap "{ rm -fr -- "$_hblock_tmpdir" ; exit 0 ; }" EXIT
mkdir -p -- "$_hblock_cachedir" "$_hblock_tmpdir"

## Do the thing
xargs \
    -a <(printf '%s\n' "${lists[@]}") \
    -n 1 \
    -P 16 \
    -i bash -c '__hblock_remove ; __hblock_do "$@"' _ {}

#cat "${_hblock_tmpdir}"/*.clean | sort -u | cat "$hostfile_head" - > "$hostfile"
cat "${_hblock_tmpdir}"/*.clean | sort -u > "$hostfile"

systemctl restart dnsmasq.service
