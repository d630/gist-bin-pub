#!/usr/bin/env bash

# Run passivedns

sudo ${X_XDG_CODE_DIR}/vcs/passivedns/src/passivedns -i wlan0 -l /var/log/passivedns.log -D
