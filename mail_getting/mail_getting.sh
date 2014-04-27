#!/usr/bin/env bash
#set -x

# Getting Mail via offlineimap and give notification + sound
# See line Mutt specific line 43
# Based on http://dev.gentoo.org/~tomka/mail.html

# -- Config.

# Time in seconds between long syncs
longsyncdiff=900 # 15 Minutes

_getmail_long() { offlineimap -c "${HOME}/.offlineimaprc" -l "${HOME}/logs/offlineimap_log" -u quiet ; }

_getmail_short() { offlineimap -o -c "${HOME}/.offlineimaprc" -l "${HOME}/logs/offlineimap_log" -f INBOX -u quiet ; }

# -- Start.

# Check connection status
if ! ping -c1 startpage.com > /dev/null 2>&1
then
    if ! wget -O - startpage.com > /dev/null 2>&1
    then
        exit 1
    fi
fi

# Check if offlineimap is running
(( $(pgrep -cf "/usr/bin/offlineimap") != 0 )) && { printf '%s\n' "Offlineimap is running with pid ${pid}" >&2 ; exit 1 ; }

# Now we determine what to do based on the last time we did things
curtime=$(date +%s)
if [[ -e ${HOME}/logs/offlineimap_lastlongsynctime ]]
then
    lastlongsync=$(< "${HOME}/logs/offlineimap_lastlongsynctime") >/dev/null # The unix time of the last long sync
    timediff=$(( curtime - lastlongsync ))
    if (( timediff > longsyncdiff ))
    then
        printf '%s\n' "$curtime" > "${HOME}/logs/offlineimap_lastlongsynctime"
        _getmail_long
    else
        #_getmail_short
        _getmail_short && rm -- "${HOME}/.mutt/mailboxes.local.uni" && cp -- "${HOME}/.mutt/_mailboxes.local.uni" "${HOME}/.mutt/mailboxes.local.uni"
    fi
else
    printf '%s\n' "$curtime" > "${HOME}/logs/offlineimap_lastlongsynctime"
    _getmail_long
fi

# Notify new mails.
newmails=( $(find "${HOME}/Maildir/uni/" ! -empty -type d -name new -exec ls {} \;) )
(( ${#newmails[@]} != 0 )) &&
{
    notify-send -u low -h int:value:42 "[Uni] new Mails: ${#newmails[@]}"
    aplay /usr/local/share/sounds/mac-sound-pack-new-mail.wav > /dev/null 2>&1
}