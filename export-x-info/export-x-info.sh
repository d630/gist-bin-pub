#!/usr/bin/env bash

# Export the dbus session address on startup so it can be used by cron

> "${HOME}/.Xdbus"
chmod 600 "${HOME}/.Xdbus"
env | grep DBUS_SESSION_BUS_ADDRESS > "${HOME}/.Xdbus"
printf '%s\n' "export $DBUS_SESSION_BUS_ADDRESS" >> "${HOME}/.Xdbus"
