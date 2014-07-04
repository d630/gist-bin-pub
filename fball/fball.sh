#!/usr/bin/env bash

# Show some soccer results on http://www.sportschau.de

[[ ! ${1#-} =~ [0-3] ]] &&  { echo "Richtigen Wettbewerb angeben." 1>&2 ; exit 1 ; }

declare -a links=()

links[0]='http://www.sportschau.de/fussball/bundesliga/spieltag/ergebnisse104_eam-5e9605716e513bbe6d967420512536eb.jsp?_liga=uebers&eap=8oI34N4hym4RDV6dhKK0OnLYM%252FNzIoiKmKv2HkJYKgPxCIifwJGZmigVNLw42zmko7u1BzkuenhNJvz6q13uZJB0jQoWe3oApsDRmgjnJGT1mkOeLckwLl9MDcdloJv%252B'
links[1]='http://www.sportschau.de/fussball/bundesliga/spieltag/ergebnisse104_eam-5e9605716e513bbe6d967420512536eb.jsp?_liga=BL1&eap=8oI34N4hym4RDV6dhKK0OnLYM%252FNzIoiKmKv2HkJYKgPxCIifwJGZmigVNLw42zmko7u1BzkuenhNJvz6q13uZJB0jQoWe3oApsDRmgjnJGT1mkOeLckwLl9MDcdloJv%252B'
links[2]='http://www.sportschau.de/fussball/bundesliga/spieltag/ergebnisse104_eam-5e9605716e513bbe6d967420512536eb.jsp?_liga=BL2&eap=8oI34N4hym4RDV6dhKK0OnLYM%252FNzIoiKmKv2HkJYKgPxCIifwJGZmigVNLw42zmko7u1BzkuenhNJvz6q13uZJB0jQoWe3oApsDRmgjnJGT1mkOeLckwLl9MDcdloJv%252B'
links[3]='http://www.sportschau.de/fussball/bundesliga/spieltag/ergebnisse104_eam-5e9605716e513bbe6d967420512536eb.jsp?_liga=BL3&eap=8oI34N4hym4RDV6dhKK0OnLYM%252FNzIoiKmKv2HkJYKgPxCIifwJGZmigVNLw42zmko7u1BzkuenhNJvz6q13uZJB0jQoWe3oApsDRmgjnJGT1mkOeLckwLl9MDcdloJv%252B'

__get()
{
    curl -s "${links[${1#-}]}" |
    scrape -be 'div.table' |
    grep -v "<img.*/>" |
    w3m -dump -no-graph -cols 142 -T text/html |
    head -n36 |
    sed -r 's/Historie//g
        s/Statistik//g
        s/\|//g
        s/ zu //g
        s/gegen :/vs./g
        s/Endstand: //g
        s/Halbzeitstand: //g
        1d
        1,20{/^Stand:.*/,/^R.*V.*Verein/ d}'
}

case ${2#-} in
    tabelle|t)
            __get "$1" | sed -n '/^[0-9]/ p'
            ;;
    spieltag|sp)
            __get "$1" | grep -v -e "^[0-9]" -e "^Stand" -e "(P)" | grep -v '^$'
            ;;
    stand|st)
            __get "$1" | sed -n '/^Stand/ p'
            ;;
    legende|l)
            __get "$1" | tail -n1
            ;;
    *)
            __get "$1"
            ;;
esac
