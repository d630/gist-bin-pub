#!/usr/bin/env bash

# Simple calculator with bc and dmenu

__result()
{
    result=$(xsel -o | menu.sh "dmenu2" "RESULT" | xargs echo | bc 2>&1)
    printf '%s\n' "$result" | tee >(xsel -i)
}

__result
while [[ $result ]]
do
    __result
done
