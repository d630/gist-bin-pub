#!/usr/bin/env bash

# Run passivedns

sudo ${HOME}/code/vcs/passivedns/src/passivedns -i wlan0 -l /var/log/passivedns.log -D
