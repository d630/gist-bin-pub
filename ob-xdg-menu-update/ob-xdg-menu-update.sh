#!/usr/bin/env bash

# Update root menu of openbox3

xdg_menu.pl --format openbox3 --root-menu ${HOME}/var/src/arch-applications.menu > ${XDG_CACHE_HOME}/openbox/arch-menu.xml
cat ${XDG_CACHE_HOME}/openbox/arch-menu.xml
