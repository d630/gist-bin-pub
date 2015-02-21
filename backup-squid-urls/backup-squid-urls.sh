#!/usr/bin/env sh

# Backup all uris from squid3 log

log="${X_XDG_LOG_HOME}/urls.log"

grep -o 'GET .* - HIER_DIRECT' "/var/log/squid/access.log" | \
    cut -d ' ' -f 2 | cat "$log" - | \
    sort -u > "${log}.$$" && \
mv "${log}.$$" "$log"
