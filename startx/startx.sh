#!/usr/bin/env sh

# My mini wrapper for startx
# $ . startx.sh

cp -bf -- "$XERRFILE" "$XERRFILE" 2>/dev/null
if umask 077 && > "$XERRFILE" && chmod 600 "$XERRFILE"
then
    exec 6>&1
    exec 7>&2
    exec >>"$XERRFILE" 2>&1
    printf '%s\n' "${0}: X session started for ${LOGNAME} at $(date)"
    startx "$@"
    printf '%s\n' "${0}: X session terminated for ${LOGNAME} at $(date)"
    exec 1>&6 6>&-
    exec 2>&7 7>&-
else
    { printf '%s\n' "${0}: Unable to create X session log/error file; aborting." 1>&2 ; return 1 ; }
fi

if [ "$SHELL" = "`type -p bash`" -a -x "$SHELL" ]
then
    . "${HOME}"/.bash_logout
    . "${HOME}"/.bash_profile
else
    . "${HOME}"/.profile
fi

