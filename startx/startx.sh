#!/bin/sh

# My mini wrapper for startx
# $ . startx.sh

cp -bf -- "$ERRFILE" "$ERRFILE" 2>/dev/null
if umask 077 && > "$ERRFILE" && chmod 600 "$ERRFILE"
then
    exec 6>&1
    exec 7>&2
    exec >>"$ERRFILE" 2>&1
    printf '%s\n' "${0}: X session started for ${LOGNAME} at $(date)" 1>&2
    startx "$@"
    exec 1>&6 6>&-
    exec 2>&7 7>&-
else
    { printf '%s\n' "${0}: Unable to create X session log/error file; aborting." 1>&2 ; return 1 ; }
fi
