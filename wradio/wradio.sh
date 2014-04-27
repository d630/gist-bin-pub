#!/usr/bin/env bash
#set -x

# Simple webradio with cvlc and dmenu/slmenu
# Forked from webradio.sh (GNU GPLv3) by Markus Lux, 2013
# https://github.com/mlux/webradio.sh

# --- Config.

declare -rg cmd_player=cvlc \
            file_webradio_streams=${HOME}/.webradio/streams \
            file_webradio_pid=${HOME}/.webradio/instance.pid

# --- Functions.

_build_streams()
{
    declare -gA streams
    declare name uri

    while IFS=';' read -r name uri
    do
        streams[$name]=$uri
    done < "$file_webradio_streams"
}

_selectstream() { declare -g selection=$( { echo "STOPSTREAM" ; printf '%s\n' "${!streams[@]}" | sort -g ; } | _menu ) ; }

_menu()
{
    if [[ $DISPLAY ]]
    then
        dmenu -i -b -p "SELECT" -l 10 -nf "#DCDCCC" -nb "#2C2C2C" -sf "#2C2C2C" -sb "#DCDCCC" -fn "'Droid Sans Mono-12'"
    else
        slmenu -i -b -p "SELECT" -l 10 -nf "#DCDCCC" -nb "#2C2C2C" -sf "#2C2C2C" -sb "#DCDCCC" -fn "'Droid Sans Mono-12'"
    fi
}

_stopstream()
{
    if [[ $(stat -c %s "$file_webradio_pid" 2>/dev/null) -lt 2 ]]
    then
        echo "Not running." | tee >(xmessage -title "xmessage:webradio" -name "webradio" -file -) >&2
    else
        #pkill -F "$file_webradio_pid" &> /dev/null && rm -- "$file_webradio_pid"
        echo "" >> "$file_webradio_pid"
        pkill -F "$file_webradio_pid" &> /dev/null
    fi
}

_playstream() { cvlc --daemon --pidfile "$file_webradio_pid" "${streams[$selection]}" ; }
#~ (
    #~ </dev/null nohup "$cmd_player" "${streams[$selection]}" &> /dev/null &
    #~ echo $! > "$file_webradio_pid"
#~ )

# --- Main.

_build_streams
_selectstream
while [[ $selection ]]
do
    _stopstream
    [[ $selection != STOPSTREAM ]] && _playstream
    _selectstream
done

unset -v streams selection