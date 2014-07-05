#!/usr/bin/env bash

# Wrapper for getting my news

feedcacher.sh
newsbeuter -r -l 3 -d "${X_XDG_LOG_HOME}/newsbeuter.log"
printf '%*s\n' "$(tput cols)" '' | tr ' ' -
urldiff -nv
