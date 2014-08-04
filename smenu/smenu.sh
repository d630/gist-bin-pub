#!/usr/bin/env bash

# Wrapper for dmenu2-save

[[ $DISPLAY ]] && menu.sh dmenu2-save "$1" 0<&-
