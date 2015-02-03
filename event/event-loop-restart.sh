#!/usr/bin/env sh

# Main loop for event.sh

source event-loop-stop.sh

cp -bf -- "${X_XDG_LOG_HOME}/event.log" "${X_XDG_LOG_HOME}/event.log" 2>/dev/null
> "${X_XDG_LOG_HOME}/event.log"
exec >>"${X_XDG_LOG_HOME}/event.log" 2>&1

while sleep 60
do
    event.sh
done
