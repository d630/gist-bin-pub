#!/usr/bin/env bash

# Clean up some dirs and files

rm -rf -- "${HOME}/.adobe" \
          "${HOME}/.macromedia" \
          "${HOME}/.icedteaplugin" \
          "${XDG_CACHE_HOME}"/*
rm -f -- "${XDG_DATA_HOME}/recently-used.xbel" \
         "${HOME}/.recently-used" \
         "${HOME}/.recentf"
