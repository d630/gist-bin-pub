#!/usr/bin/env sh

# Backup all uris from squid3 log

log="${X_XDG_LOG_HOME}/urls.log"

cat "/var/log/squid/access.log" | \
    grep -o 'GET .* - HIER_DIRECT' | \
    cut -d ' ' -f 2 | cat "$log" - | \
    sort -u > "${log}.$$" && \
mv "${log}.$$" "$log"
