#!/usr/bin/env bash

# Weekly Backup with Obnam

sudo obnam backup /etc/ /opt/ /root/ /srv/ /usr/local/ /usr/share/doc/ /usr/share/xfce4/ /var/backups/ /var/local/ /var/log/ /var/mail/ /var/opt/ /var/www/ /var/lib/mysql/ /var/spool/ /home/user/

sudo obnam force-lock

sudo obnam forget --keep=2w
