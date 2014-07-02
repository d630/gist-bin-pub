#!/usr/bin/env bash

# Update root menu of openbox3

xdg_menu.pl --format openbox3 --root-menu ${HOME}/code/source/arch-applications.menu > ${HOME}/.cache/openbox/arch-menu.xml
cat ${HOME}/.cache/openbox/arch-menu.xml
