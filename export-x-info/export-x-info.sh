#!/usr/bin/env bash

# Export the dbus session address on startup so it can be used by cron

> "${XDG_DATA_HOME}/Xdbus"
chmod 600 ""${XDG_DATA_HOME}/Xdbus"
env | grep DBUS_SESSION_BUS_ADDRESS > ""${XDG_DATA_HOME}/Xdbus""
printf '%s\n' "export $DBUS_SESSION_BUS_ADDRESS" >> "${XDG_DATA_HOME}/Xdbus"
