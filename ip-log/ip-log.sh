#!/usr/bin/env bash

# Daily ip logging

ausgabe=${X_XDG_LOG_HOME}/ip-log.log
empfaenger=ip-log@ip-log
betreff=ip-log

printf '%s\n' "$(date +%Y-%m-%d_%R) $(curl ifconfig.me)" >> "$ausgabe"
tail -n1 "$ausgabe" | mail -s "$betreff" "$empfaenger"
