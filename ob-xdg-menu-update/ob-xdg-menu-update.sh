#!/usr/bin/env bash

# Update root menu of openbox3

mkdir -p "${XDG_CACHE_HOME}/openbox"

echo "<?xml version='1.0' encoding='UTF-8'?>
<openbox_menu xmlns='http://openbox.org/'
        xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
        xsi:schemaLocation='http://openbox.org/
                file:///usr/share/openbox/menu.xsd'>

<menu id='/xdg' label='xdg'>" \
    > "${XDG_CACHE_HOME}/openbox/xdg-menu.xml"

xdg_menu.pl --format openbox3 --root-menu "${HOME}/var/src/arch-applications.menu" \
    >> "${XDG_CACHE_HOME}/openbox/xdg-menu.xml"

echo "</menu>

</openbox_menu>" >> "${XDG_CACHE_HOME}/openbox/xdg-menu.xml"

sed -i 's/id=\"/&\/xdg\//g' "${XDG_CACHE_HOME}/openbox/xdg-menu.xml"
