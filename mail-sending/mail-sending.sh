#!/usr/bin/env bash

# Send Mail via msmtp-runqueue.sh and give notification + sound

shopt -s nullglob
shopt -s dotglob

_queue()
{
    declare -a f=(${HOME}/.msmtpqueue/*)
    printf '%s\n' "${#f[@]}"
}

if ! ping -c1 google.com 1>/dev/null 2>&1
then
    if ! wget -O - google.com 1>/dev/null 2>&1
    then
        exit 1
    fi
fi

(($(_queue) != 0)) &&
{
    until (($(_queue) == 0))
    do
        msmtp-runqueue.sh > ${HOME}/.local/log/msmtp-queue.log 2>&1
    done
    notify-send -u low -h int:value:42 "[Uni] All mails have been sent!"
    aplay /usr/local/share/sounds/mac-sound-pack-mail-sent.wav 1>/dev/null 2>&1
}
