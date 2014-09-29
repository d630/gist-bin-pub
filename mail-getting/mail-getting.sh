#!/usr/bin/env bash

# Getting Mail via offlineimap and give notification + sound
# See line Mutt specific line 43
# Based on http://dev.gentoo.org/~tomka/mail.html

# -- Config.

# Time in seconds between long syncs
longsyncdiff=900 # 15 Minutes

__getmail_long() { offlineimap -c "${HOME}/.offlineimaprc" -l "${X_XDG_LOG_HOME}/offlineimap.log" -u quiet ; }

__getmail_short() { offlineimap -o -c "${HOME}/.offlineimaprc" -l "${X_XDG_LOG_HOME}/offlineimap.log" -f INBOX -u quiet ; }

# -- Start.

# Check connection status
if ! ping -c1 google.com 1>/dev/null 2>&1
then
    if ! wget -O - google.com 1>/dev/null 2>&1
    then
        { echo "We are offline" 1>&2 ; exit 1 ; }
    fi
fi

# Check if offlineimap is running
(($(pgrep -cf "/usr/bin/offlineimap") != 0)) && { printf '%s\n' "Offlineimap is running with pid ${pid}" 1>&2 ; exit 1 ; }

# Now we determine what to do based on the last time we did things
curtime=$(date +%s)
if [[ -e ${X_XDG_LOG_HOME}/offlineimap_lastlongsynctime ]]
then
    lastlongsync=$(< "${X_XDG_LOG_HOME}/offlineimap_lastlongsynctime") >/dev/null # The unix time of the last long sync
    timediff=$((curtime - lastlongsync))
    if ((timediff > longsyncdiff))
    then
        printf '%s\n' "$curtime" > "${X_XDG_LOG_HOME}/offlineimap_lastlongsynctime"
        __getmail_long
    else
        #_getmail_short
        __getmail_short && rm -- "${HOME}/.mutt/mailboxes.local.uni" && cp -- "${HOME}/.mutt/_mailboxes.local.uni" "${HOME}/.mutt/mailboxes.local.uni"
    fi
else
    printf '%s\n' "$curtime" > "${X_XDG_LOG_HOME}/offlineimap_lastlongsynctime"
    __getmail_long
fi

# Notify new mails.
newmails=($(find "${X_MAILDIR}/uni/" ! -empty -type d -name new))
((${#newmails[@]} != 0)) &&
{
    notify-send -u low -h int:value:42 "[Uni] new Mails: ${#newmails[@]}"
    aplay ${XDG_DATA_HOME}/sounds/mac-sound-pack-new-mail.wav 1>/dev/null 2>&1
}
