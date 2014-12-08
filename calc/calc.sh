#!/usr/bin/env bash

# Simple calculator with bc and dmenu

__result()
{
    if tty -s
    then
        result=$(xsel -o | menu.sh "slmenu" "RESULT" | xargs echo | bc 2>&1)
    else
        result=$(xsel -o | menu.sh "dmenu2" "RESULT" | xargs echo | bc 2>&1)
    fi
    printf '%s\n' "$result" | tee >(xsel -i)
}

__result
while [[ $result ]]
do
    __result
done
