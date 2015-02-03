#!/usr/bin/env sh

# List all programs

ls $(printf '%s ' ${PATH//:/ }) "/usr/bin/X11" | xargs whatis | sort | uniq > "${X_XDG_BACKUPS_DIR}/Programme.txt"
find "/var/lib/dpkg/info/" -daystart \( -name \*.list -a -mtime -7 \) | sed 's/.list$//;s/.*\///' | sort > "${X_XDG_BACKUPS_DIR}/software_7_days.txt"
