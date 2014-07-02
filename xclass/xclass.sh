#!/usr/bin/env bash

# Interactively get xclass info about a xwindow

xprop | awk '
   /^WM_CLASS/{sub(/.* =/, "instance:"); sub(/,/, "\nclass:"); print}
   /^WM_NAME/{sub(/.* =/, "title:"); print}'
