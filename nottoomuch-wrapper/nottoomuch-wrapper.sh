#!/usr/bin/env bash

# dmenu-wrapper for nottoomuch-addresses.sh

declare string=

if tty -s
then
    __search() { string=$(menu.sh "slmenu" ">" <<< "") ; }
else
    __search() { string=$(menu.sh "dmenu2" ">" <<< "") ; }
fi

__search
while [[ $string ]]
do
    clear
    column -t < <(nottoomuch-addresses.sh "$string" | sed -r 's#(.*)()(<.*)#\3\   \1#g' | sed -r 's/\"//g;s/(<)(.*)(>)/\2/g' | sort -k3)
    __search
done
