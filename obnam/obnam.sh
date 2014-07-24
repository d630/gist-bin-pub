#!/usr/bin/env bash

# Weekly Backup with Obnam

declare \
        obnam_conf=${HOME}/.obnam.conf \
        obnam_log=${X_XDG_LOG_HOME}/obnam.log

sudo obnam backup --config=$obnam_conf \
/etc/ \
/home/ \
/opt/ \
/root/ \
/srv/ \
/usr/lib/ \
/usr/local/ \
/usr/share/applications/ \
/usr/share/desktop-directories/ \
/usr/share/fonts/ \
/usr/share/images/ \
/usr/share/keyrings/ \
/usr/share/menu/ \
/usr/share/mime/ \
/usr/share/mime-info/ \
/usr/share/mimelnk/ \
/usr/share/plymouth/ \
/usr/share/sounds/ \
/usr/share/themes/ \
/usr/share/wallpapers/ \
/usr/share/xsessions/ \
/usr/src/ \
/var/backups/ \
/var/lib/ \
/var/local/ \
/var/log/ \
/var/mail/ \
/var/opt/ \
/var/www/ \

sudo obnam force-lock --config=$obnam_conf

sudo obnam forget --config=$obnam_conf --keep=2w
