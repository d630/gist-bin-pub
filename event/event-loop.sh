#!/usr/bin/env sh

# Main loop for event.sh

for i in $(pgrep -f event-loop.sh)
do
    pkill -P $i
done 1>/dev/null 2>&1

cp -bf -- "${X_XDG_LOG_HOME}/event.log" "${X_XDG_LOG_HOME}/event.log" 2>/dev/null
> "${X_XDG_LOG_HOME}/event.log"
exec >>"${X_XDG_LOG_HOME}/event.log" 2>&1

while sleep 60
do
    event.sh
done
