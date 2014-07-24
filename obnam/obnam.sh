#!/usr/bin/env bash

# Weekly Backup with Obnam

declare \
        obnam_conf=${HOME}/.obnam.conf \
        obnam_log=${X_XDG_LOG_HOME}/obnam.log

sudo obnam backup --config=$obnam_conf /etc/ /opt/ /root/ /srv/ /usr/local/ /var/backups/ /var/local/ /var/log/ /var/mail/ /var/opt/ /var/www/ /var/lib/mysql/ /var/spool/ /home/

sudo obnam force-lock --config=$obnam_conf

sudo obnam forget --config=$obnam_conf --keep=2w
