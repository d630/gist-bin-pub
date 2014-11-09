#!/usr/bin/env bash

# Export the dbus session address on startup so it can be used by cron
# Based on: http://dev.gentoo.org/~tomka/mail.html

# other methode : source "${HOME}/.dbus/session-bus/$(dbus-uuidgen --get)"

> "${X_XDG_LIB_DIR}/xdbus"
chmod 600 "${X_XDG_LIB_DIR}/xdbus"
env | grep DBUS_SESSION_BUS_ADDRESS >> "${X_XDG_LIB_DIR}/xdbus"
printf '%s\n' "export DBUS_SESSION_BUS_ADDRESS" >> "${X_XDG_LIB_DIR}/xdbus"
