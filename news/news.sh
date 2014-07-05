#!/usr/bin/env bash

# Wrapper for getting my news

feedcatcher.sh
newsbeuter -r -l 1 -d ${X_XDG_LOG_HOME}/newsbeuter.log
printf '%*s\n' "$(tput cols)" '' | tr ' ' -
urldiff -nv
