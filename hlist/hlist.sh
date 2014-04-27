#!/usr/bin/env bash
# Select bash history in a dmenu

cut -f1 -d" " ~/.bash_history | sort | uniq -c | sort -nr | head -n 100 | dmenu -i -b -p "run" -l 10 -nf "#DCDCCC" -nb "#2C2C2C" -sf "#2C2C2C" -sb "#DCDCCC" -fn "'Droid Sans Mono-12'" | awk '{print $2}'