#!/usr/bin/env bash

# Clean up some dirs and files

rm -rf -- \
    "${HOME}/.adobe" \
    "${HOME}/.gconf" \
    "${HOME}/.gnome2" \
    "${HOME}/.gnome2_private" \
    "${HOME}/.icedteaplugin" \
    "${HOME}/.macromedia" \
    "${HOME}/.thumbnails" \
    "${XDG_CACHE_HOME}"/*
rm -f -- \
    "${HOME}/.gksu.lock" \
    "${HOME}/.recentf" \
    "${HOME}/.recently-used" \
    "${XDG_DATA_HOME}/recently-used.xbel"
