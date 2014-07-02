#!/usr/bin/env bash

# Clean up some dirs and files

rm -rf -- ${HOME}/.adobe/* \
          ${HOME}/.macromedia/* \
          ${HOME}/.icedteaplugin/* \
          ${HOME}/.cache/*
rm -f -- ${HOME}/.local/share/recently-used.xbel \
         ${HOME}/.recently-used
