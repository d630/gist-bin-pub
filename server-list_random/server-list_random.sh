#!/usr/bin/env bash

# Get a server ip (random) for proxychains

_get()
{
    line_number=$(wc -l < /home/user/.proxychains/server-list)
    line_random=$(expr "$RANDOM" % "$line_number")
}

_select() { printf '%s\n' "$(sort -Rr /home/user/.proxychains/server-list | head -n"$line_random" | sort -Rr | sed -n -e'#^$#d' -e'$p')" ; }

_main()
{
    if (( line_random > 0 ))
    then
        _select
    else
        _get
        _main
    fi
}

_get
_main
