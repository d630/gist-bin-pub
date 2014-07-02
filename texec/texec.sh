#!/usr/bin/env bash

# Run or raise for cli and tui apps (wmctrl and xwinreg)

(($# == 0)) && { printf '%s\n' "USAGE: $(basename "$0") <APP>" >&2 ; exit 1 ; }

declare -a \
           pid_list=() \
           texec_command=($*) \
           xids=()

declare \
        id= \
        net_client_list= \
        net_wm_pid= \
        pid=

read -r _ _ _ _ net_client_list < <(xprop -root _NET_CLIENT_LIST)

for pid in $(pgrep -d ' ' "${texec_command[0]}")
do
    until [[ ${pid// /} == 0 ]]
    do
        pid=$(ps -p "${pid// /}" -o ppid= 2>/dev/null)
        pid_list+=(${pid// /})
    done
done

for id in ${net_client_list//,/}
do
    read -r _ _ net_wm_pid < <(xprop -id "$id" _NET_WM_PID)
    for pid in "${pid_list[@]}"
    do
        [[ $net_wm_pid == $pid ]] && xids+=($id)
    done
done

case ${#xids[@]} in
    0)
            if command -v "${texec_command[0]}" 1>/dev/null
            then
                (exec ${cexec_command[*]} 2>/dev/null &)
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
