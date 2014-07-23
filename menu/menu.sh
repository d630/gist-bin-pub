#!/usr/bin/env bash

# wrapper script to select menu driven programms

menu=$1
menu_prompt=$2

case $menu in
    dmenu)
            __menu_cmd()
            {
                dmenu -b -f -i \
                      -l "10" \
                      -p "${menu_prompt:->}" \
                      -nb "#2C2C2C" \
                      -nf "#DCDCCC" \
                      -sb "#DCDCCC" \
                      -sf "#2C2C2C" \
                      -uc "#2C2C2C" \
                      -fn "-xos4-terminus-medium-r-normal-*-16-*-*-*-*-*-iso10646-*" \
                     -name "dmenu" \
                     -class "dmenu"
            }
            ;;
    dmenu2)
            __menu_cmd()
            {
                dmenu2 -b -f -i \
                       -l "10" \
                       -p "${menu_prompt:->}" \
                       -nb "#2C2C2C" \
                       -nf "#DCDCCC" \
                       -sb "#DCDCCC" \
                       -sf "#2C2C2C" \
                       -uc "#2C2C2C" \
                       -fn "-xos4-terminus-medium-r-normal-*-16-*-*-*-*-*-iso10646-*" \
                       -name "dmenu2" \
                       -class "dmenu2"
            }
            ;;
    slmenu)
            __menu_cmd()
            {
                slmenu -b -f -i \
                       -p "${menu_prompt:->}" \
                       -nb "#2C2C2C" \
                       -nf "#DCDCCC" \
                       -sb "#DCDCCC" \
                       -sf "#2C2C2C" \
                       -uc "#2C2C2C" \
                       -fn "-xos4-terminus-medium-r-normal-*-16-*-*-*-*-*-iso10646-*" \
                       -name "slmenu" \
                       -class "slmenu"
            }
            ;;
    selecta)
            __menu_cmd() { selecta ; }
            ;;
    tmenu)
            __menu_cmd() { tmenu -l 10 -p "${menu_prompt:->>}" ; }
            ;;
    fzf)
            __menu_cmd() { fzf -x -i +s --prompt="${menu_prompt:->} " ; }
            ;;
    fzf-print-query)
            __menu_cmd() { fzf -x -i +s --prompt="${menu_prompt:->} " --print-query ; }
            ;;
esac

__menu_cmd
