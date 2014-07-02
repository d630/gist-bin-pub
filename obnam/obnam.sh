#!/usr/bin/env bash

# Weekly Backup with Obnam

obnam=${HOME}/logs/obnam.txt
empfaenger=obnam@obnam
betreff=Obnam

echo ""S:" $(date +%Y-%m-%d_%R)" >> "$obnam"

sudo obnam backup /etc/ /opt/ /root/ /srv/ /usr/local/ /var/backups/ /var/local/ /var/log/ /var/mail/ /var/opt/ /var/www/ /var/lib/mysql/ /var/spool/ ${HOME}/.cpan/

sudo obnam force-lock

#keep=$(datediff -d "$(date "+%Y-%m-%d %T")" "$(sudo obnam generations | tail -n2 | head -n1 | cut -d" " -f1-2 | cut -f2)")
#sudo obnam forget --keep="$keep"d
sudo obnam forget --keep=2w

echo ""E:" $(date +%Y-%m-%d_%R)" >> "$obnam"

tail -n2 "$obnam" | mail -s "$betreff" "$empfaenger"
