#!/usr/bin/env bash

# Export the dbus session address on startup so it can be used by cron
# Based on: http://dev.gentoo.org/~tomka/mail.html

> "${XDG_DATA_HOME}/xdbus"
chmod 600 "${XDG_DATA_HOME}/xdbus"
env | grep DBUS_SESSION_BUS_ADDRESS >> "${XDG_DATA_HOME}/xdbus"
printf '%s\n' "export DBUS_SESSION_BUS_ADDRESS" >> "${XDG_DATA_HOME}/xdbus"
