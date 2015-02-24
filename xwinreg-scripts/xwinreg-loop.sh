#!/usr/bin/env bash

# Do layouting automatically (dynamically)

while xev -root -event property | grep -q "(_NET_CLIENT_LIST).*state PropertyNewValue"
do
    if source "${XWINREG_TMP_FILE:-${TMPDIR:-/tmp}/xwinreg_default.tmp}"
    then
        {
            get-xids.sh | \
            xwinpp print -I - --visible -P 0 | \
            xwinreg ${_xwinreg_options[command]}
        } || {
            source <(get-xids.sh | xwinpp print -I - --visible -P 0)
            wmctrl -i -r "$_xwinpp_win_xid" -b "add,maximized_vert,maximized_horz"
        }
    else
        xwinreg-master-west.sh
    fi
done 2>/dev/null
