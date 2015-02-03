#!/usr/bin/env sh

# List all programs

ls $(printf '%s ' ${PATH//:/ }) "/usr/bin/X11" | xargs whatis | sort | uniq > "${X_XDG_BACKUPS_DIR}/Programme.txt"
