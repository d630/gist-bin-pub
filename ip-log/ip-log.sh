#!/usr/bin/env bash

# Daily ip logging

ausgabe=${HOME}/logs/ip_log.txt
empfaenger=ip-log@ip-log
betreff=ip-log

printf '%s\n' "$(date +%Y-%m-%d_%R) $(curl ifconfig.me)" >> "$ausgabe"
tail -n1 "$ausgabe" | mail -s "$betreff" "$empfaenger"
