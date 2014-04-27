#!/usr/bin/env bash

# Back up latest firefox history with sqlite3 (logfile & taskwarrior-um)

db_path=$HOME/.mozilla/firefox/xxxxxx.default/places.sqlite
log=$HOME/logs/urls
uris=$HOME/logs/uris_new

sqlite3 "$db_path" 'SELECT DISTINCT moz_places.url FROM moz_places, moz_historyvisits WHERE ((url LIKE "http%" OR url LIKE "ftp%" OR url LIKE "file%" OR url LIKE "mailto%" OR url LIKE "gopher%") AND moz_historyvisits.place_id = moz_places.id) ORDER BY url' | sed 's/"//g' | tee >(cat "$log" - | sort | uniq > "${log}.$$" && mv "${log}.$$" "$log") > "$uris"

[[ -e $uris ]] &&
{
    while read -r line
    do
        taskum add uri:${line}
    done < "$uris"
    rm -- "$uris"
}
