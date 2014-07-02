#!/usr/bin/env bash

# Run or raise for graphical apps (wmctrl and xwinreg)

(($# == 0)) && { printf '%s\n' "USAGE: $(basename "$0") <APP>" >&2 ; exit 1 ; }

declare -a gexec_command=($*) \
           xids=()
declare \
        net_client_list= \
        id=

read -r _ _ _ _ net_client_list < <(xprop -root _NET_CLIENT_LIST)

while read -r
do
    xids+=(${REPLY%% *})
done < <(for id in ${net_client_list//,/} ; do printf '%s\n' "${id} $(xprop -id "$id" WM_CLASS)" ; done | grep -i "${gexec_command[0]}")

case ${#xids[@]} in
    0)
            if command -v "${gexec_command[0]}" 1>/dev/null
            then
                (exec ${gexec_command[*]} 2>/dev/null &)
                sleep 1
                net_client_list=$(xprop -root _NET_CLIENT_LIST)
                wmctrl -i -a "${net_client_list##* }"
            else
                { printf '%s\n' "App is unknown." 1>&2 ; exit 1 ; }
            fi
            ;;
    1)
            wmctrl -i -a "${xids[0]}"
            ;;
    *)
            printf '%s\n' "${xids[@]}" | xwinpp -I - -p | xwinreg -I - -L 1,max,grid-vertical,alias:0,all
            xwinreg focus -r 1
            ;;
esac
