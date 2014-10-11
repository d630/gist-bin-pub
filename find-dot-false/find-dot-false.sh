#!/usr/bin/env bash

# find files which are currently not used with stow

find "$HOME" "${HOME}/etc" "${HOME}/share" \
        -mindepth 1 \
        -maxdepth 1  \
        ! -type l  \
        ! -name share \
        ! -name etc \
        ! -name bin \
        ! -name src \
        ! -name stow \
        ! -name var \
        ! -name .git \
        -print
