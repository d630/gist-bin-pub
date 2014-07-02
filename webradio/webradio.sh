#!/usr/bin/env bash

# Simple wradio with cvlc and dmenu/slmenu
# Forked from webradio.sh (GNU GPLv3) by Markus Lux, 2013
# https://github.com/mlux/webradio.sh/blob/master/webradio.sh

# --- Config.

declare -rg cmd_player=cvlc \
            file_webradio_streams=${HOME}/.webradio/streams \
            file_webradio_pid=${HOME}/.webradio/instance.pid

# --- Functions.

__build_streams()
{
    declare -gA streams
    declare name= uri=

    while IFS=';' read -r name uri
    do
        streams[$name]=$uri
    done < "$file_webradio_streams"
}

__selectstream() { declare -g selection=$( { echo "STOPSTREAM" ; printf '%s\n' "${!streams[@]}" | sort -g ; } | __menu ) ; }

__menu()
{
    if [[ $modus == cli ]]
    then
        menu.sh "fzf" "PLAY"
    else
        menu.sh "dmenu2" "PLAY"
    fi
}

__stopstream()
{
    if [[ $(stat -c %s "$file_webradio_pid" 2>/dev/null) -lt 2 ]]
    then
        echo "Not running." | tee >(xmessage -title "xmessage:webradio" -name "acti" -file -) >&2
    else
        #pkill -F "$file_webradio_pid" &> /dev/null && rm -- "$file_webradio_pid"
        echo "" >> "$file_webradio_pid"
        pkill -F "$file_webradio_pid" &> /dev/null
    fi
}

__playstream() { cvlc --daemon --pidfile "$file_webradio_pid" "${streams[$selection]}" ; }
#~ (
    #~ </dev/null nohup "$cmd_player" "${streams[$selection]}" &> /dev/null &
    #~ echo $! > "$file_webradio_pid"
#~ )

# --- Main.

declare modus=

if tty -s
then
    modus=cli
elif [[ $DISPLAY ]]
then
    modus=gui
else
    exit 1
fi

__build_streams
__selectstream
while [[ $selection ]]
do
    __stopstream
    [[ $selection != STOPSTREAM ]] && __playstream
    __selectstream
done

unset -v streams selection
