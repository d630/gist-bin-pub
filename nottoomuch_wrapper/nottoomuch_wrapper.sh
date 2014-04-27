#!/usr/bin/env bash
# dmenu-wrapper for nottoomuch-addresses.sh

_search() { string=$(dmenu -noinput -i -b -p "SEARCH" -l 5 -nf "#DCDCCC" -nb "#2C2C2C" -sf "#2C2C2C" -sb "#DCDCCC" -fn "'Droid Sans Mono-12'") ; }

_search

while [[ $string ]]
do
    clear
    column -t < <(nottoomuch-addresses.sh "$string" | sed -r 's#(.*)()(<.*)#\3\   \1#g' | sed -r 's/\"//g;s/(<)(.*)(>)/\2/g' | sort -k3)
    _search
done