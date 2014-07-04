#!/usr/bin/env bash

# Bleachbit

tmp_bleach=${X_XDG_LOG_HOME}/tmp_bleach.txt
logfile=${X_XDG_LOG_HOME}/bleachbit_log.txt
empfaenger=bleachbit@bleachbit
betreff=bleachbit-log

sudo bleachbit -c -o --preset > >(tail -n4 | sed -e "1 i\
    $(date +%Y-%m-%d_%R)" | tee >(mail -s "$betreff" "$empfaenger") | cat "$logfile" - > "$tmp_bleach")

mv "$tmp_bleach" "$logfile"
