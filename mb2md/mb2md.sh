#!/usr/bin/env bash

# # Convert mailbox to maildir

# 1. Aus Tunderbird Mails als eml exportieren
# 2. In Thunderbird (Archiv) eml importieren und archivieren
# 3. In Thunderbird (Archiv) Archiv als mbox exportieren

for i in 1970 {2007..2014}
do
    mb2md -s "${X_XDG_TMP_HOME}/Archiv/${i}" -R -d "${X_XDG_TMP_HOME}/md/${i}"
done
