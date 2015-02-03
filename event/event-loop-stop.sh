#!/usr/bin/env sh

# Stop event-loop.sh

for i in $(pgrep -f event-loop.sh)
do
    pkill -P $i
done 1>/dev/null 2>&1
