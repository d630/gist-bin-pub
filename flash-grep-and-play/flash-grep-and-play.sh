#!/usr/bin/env bash

# Grep and copy flash from inside your browser

declare \
        browser=${1:-$BROWSER} \
        random= \
        REPLY=

declare -a files=()

while IFS= read -r -d ''
do
    random=$(od -vAn -N 1 -tu < /dev/urandom)
    rsync -a -v --progress --no-l -L "$REPLY" "/tmp/${random// /}.flash"
done < <(find "/proc/$(pgrep ${browser})/fd" -type l -lname "/tmp/Flash*" -print0)

mapfile -t files < <(find "/tmp/" -maxdepth 1 -type f -name "*.flash")

if ((${#files[@]} == 0))
then
    { echo "There is no flash file." 1>&2 ; exit 1 ; }
elif ((${#files[@]} == 1))
then
    (exec "${2:-vlc}" "/tmp/${random// /}.flash" 2>/dev/null &)
else
    ls -l "/tmp" | grep -e ".*flash"
    read -re -p "File: " file
    (exec "${2:-vlc}" "/tmp/${file}.flash" 2>/dev/null &)
fi
