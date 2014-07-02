#!/usr/bin/env bash

# Browse and query interactively a CSV with choose and less (example)

_tbl_1()
{
    printf '#"Buch-ID";"Autor";"Verlag";"Verlagsjahr";"Titel";"Datum"
"1";"Hans Vielschreiber";"Verlag";"2007";"Wir lernen SQL";"13.01.2007"
"2";"J. Gutenberg";"Gutenberg und Co.";"1452";"Drucken leicht gemacht";"01.01.1452"
"3";"G. I. Caesar";"Handschriftverlag";"-44";"Mein Leben mit Asterix";"16.03.-44"
"4";"Galileo Galilei";"Inquisition International";"1640";"Eppur si muove";"1641"
"5";"Charles Darwin";"Vatikan-Verlag";"1860";"Adam und Eva";"1862"
'
}

_form_1()
{
    declare -A fields

    fields[Buch-ID]='read -re -p "Buch-ID: " b'
    fields[Autor]='read -re -p "Autor: " a'
    fields[Verlag]='read -re -p "Verlag: " v'
    fields[Verlagsjahr]='read -re -p "Verlagsjahr: " vj'
    fields[Titel]='read -re -p "Titel: " t'
    fields[Datum]='read -re -p "Datum: " d'

    while :
    do
        declare sel=
        declare b= a= v= vj= t= d=
        for sel in $( { printf '%s\n' 'quit' ' ' ; printf '%s\n' "${!fields[@]}" | sort ; } | choose - )
        do
            if [[ $sel == quit ]]
            then
                return 0
            else
                eval "${fields[$sel]}"
            fi
        done
        if [[ $sel ]]
        then
            clear
        else
            return 0
        fi
        while IFS=';' read -r i a v vj t d
        do
            printf '%s\n' "Buch-ID: ${b//\"/}" "Autor: ${a//\"/}" "Verlag: ${v//\"/}" "Verlagsjahr: ${vj//\"/}" "Titel: ${t//\"/}" "Datum: ${d//\"/}" " "
            #printf '%s\n' "${b//\"/};${a//\"/};${v//\"/};${vj//\"/};${t//\"/};${d//\"/}" | column -t -s ';'
        done < <(egrep -e "^\"${b:-.*}\";\"${a:-.*}\";\"${v:-.*}\";\"${vj:-.*}\";\"${t:-.*}\";\"${d:-.*}\"$" <(_tbl_1)) | less
    done
}

while :
do
    PS3='Select a number or type a letter to quit: '
    select form in $(typeset -F | sed -e 's/.* //')
    do
        if [[ $form ]]
        then
            clear
            "$form" && break
        else
            exit 1
        fi
    done
done
