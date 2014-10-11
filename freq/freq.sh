#!/usr/bin/env bash

# frequency of your bash history

cut -d " " -f1 "$HISTFILE" | sort | uniq -c | sort -nr
