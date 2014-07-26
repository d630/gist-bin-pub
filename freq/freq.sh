#!/usr/bin/env bash

# frequency of your bash history

cut -d " " -f1 "${HOME}/.bash_history" | sort | uniq -c | sort -nr
