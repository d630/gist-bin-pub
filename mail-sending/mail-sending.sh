#!/usr/bin/env bash

# Send Mail via msmtp-runqueue.sh and give notification + sound

shopt -s nullglob
shopt -s dotglob

__queue()
{
    declare -a f=(${X_XDG_MAIL_DIR}/msmtpqueue/*)
    printf '%s\n' "${#f[@]}"
}

if ! ping -c1 google.com 1>/dev/null 2>&1
then
    if ! wget -O - google.com 1>/dev/null 2>&1
    then
        { echo "We are offline" >&2 ; exit 1 ; }
    fi
fi

(($(__queue) != 0)) &&
{
    until (($(__queue) == 0))
    do
        msmtp-runqueue.sh > "${X_XDG_LOG_HOME}/msmtp-queue.log" 2>&1
    done
    notify-send -u low -h int:value:42 "[Uni] All mails have been sent!"
    aplay ${XDG_DATA_HOME}/sounds/mac-sound-pack-mail-sent.wav 1>/dev/null 2>&1
}
