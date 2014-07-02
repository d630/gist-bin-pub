#!/usr/bin/env bash

# Backup all uris in firefox sqlite (sqlite3 & taskum)

db_path=${HOME}/.mozilla/firefox/*.default/places.sqlite
log=${HOME}/.local/log/urls.log
uris=${HOME}/.local/log/uris_new.log

sqlite3 "$db_path" 'SELECT DISTINCT moz_places.url FROM moz_places WHERE (url LIKE "http%" OR url LIKE "ftp%" OR url LIKE "file%" OR url LIKE "mailto%" OR url LIKE "gopher%") UNION ALL SELECT DISTINCT moz_favicons.url FROM moz_favicons WHERE (url LIKE "http%" OR url LIKE "ftp%" OR url LIKE "file%" OR url LIKE "mailto%" OR url LIKE "gopher%") ORDER BY url' \
| sed 's/"//g' \
| tee >(cat "$log" - | sort | uniq > "${log}.$$" && mv "${log}.$$" "$log") > "$uris"

[[ -e $uris ]] &&
{
    while read -r line
    do
        taskum add uri:${line}
    done < "$uris"
    rm -- "$uris"
}
