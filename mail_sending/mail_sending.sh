#!/usr/bin/env bash
#set -x
# Send Mail via msmtp-runqueue.sh and give notification + sound

shopt -s nullglob
shopt -s dotglob

_queue()
{
    declare -a f
    f=( /home/user/.msmtpqueue/* )
    printf '%s\n' "${#f[@]}"
}

if ! ping -c1 startpage.com > /dev/null 2>&1
then
    if ! wget -O - startpage.com > /dev/null 2>&1
    then
        exit 1
    fi
fi

(( $(_queue) != 0 )) &&
{
    until (( $(_queue) == 0 ))
    do
        /home/user/.local/bin/msmtp-runqueue.sh &> /home/user/logs/msmtp-queue.log
    done
    notify-send -u low -h int:value:42 "[Mailbox1] All mails have been sent!"
    aplay /usr/local/share/sounds/mac-sound-pack-mail-sent.wav > /dev/null 2>&1
}