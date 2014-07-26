#!/usr/bin/env bash

# frequency of your bash history (dmenu)

freq.sh | menu.sh "dmenu2" "RUN" | awk '{print $2}'
