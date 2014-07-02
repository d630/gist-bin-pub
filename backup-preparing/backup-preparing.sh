#!/usr/bin/env bash

# Prepare full backup for Meinecke

# Closing
{ printf '%*s\n%s\n' "80" '' "Closing" | tr ' ' - ; } 1>&2
clipbored -k
pkill clipbored
pkill -f clipbored-schleife.sh
pkill -f mail-schleife.sh
pkill -f backup-firefox-history-schleife.sh

# Connection
{ printf '%*s\n%s\n' "80" '' "CONNECTION" | tr ' ' - ; } 1>&2
ssh-add ${HOME}/.ssh/id_rsa_backup

# MySql
{ printf '%*s\n%s\n' "80" '' "MySql" | tr ' ' - ; } 1>&2
#mysql-start.sh
#sudo mysql-backup-local.sh
#mysql-stop.sh

# mlr
{ printf '%*s\n%s\n' "80" '' "mlr" | tr ' ' - ; } 1>&2
mlr.sh

# Paketlisten && Repos
{ printf '%*s\n%s\n' "80" '' "Packages&Repos" | tr ' ' - ; } 1>&2
sudo dpkg --clear-avail
sudo apt-get autoclean
sudo apt-get autoremove
sudo dpkg --configure -a
sudo apt-get install -f
mr -j5 update
cd -- "${HOME}/code/source/org-mode" && make uncompiled
sudo rm -r -- "${HOME}/Dokumente/Backups/paketlisten" &&
{
    mkdir "${HOME}/Dokumente/Backups/paketlisten"
    cd "${HOME}/Dokumente/Backups/paketlisten"
    COLUMNS=200 dpkg-query -l > packages_list.list
    dpkg --get-selections | awk '!/deinstall|purge|hold/ {print $1}' > packages.list
    apt-mark showauto > package-states-auto
    apt-mark showmanual > package-states-manual
    find /etc/apt/sources.list* -type f -name '*.list' -exec bash -c 'echo -e "\n## $1 " ; grep "^[[:space:]]*[^#[:space:]]" ${1}' _ {} \; > sources.list.save
    sudo cp -- /etc/apt/trusted.gpg trusted-keys.gpg
}

# Programme
{ printf '%*s\n%s\n' "80" '' "Programme" | tr ' ' - ; } 1>&2
ls  $(printf '%s ' ${PATH//:/ }) /usr/bin/X11 | xargs whatis | sort | uniq > "${HOME}/Dokumente/Backups/Programme.txt"

# Anzeige einer ausführlichen Übersicht der aktivierten Quellen mit den Apt-Pinning-Informationen
{ printf '%*s\n%s\n' "80" '' "Apt" | tr ' ' - ; } 1>&2
apt-cache policy > "${HOME}/Dokumente/Backups/apt-quellen.txt"

# Liste der in den letzten 7 Tagen installierten Pakete
{ printf '%*s\n%s\n' "80" '' "Last 7 Days" | tr ' ' - ; } 1>&2
find /var/lib/dpkg/info/ -daystart \( -name \*.list -a -mtime -7 \) | sed 's#.list$##;s#.*/##' | sort > "${HOME}/Dokumente/Backups/software_7_days.txt"

# init-Liste
{ printf '%*s\n%s\n' "80" '' "Inits" | tr ' ' - ; } 1>&2
{ find /etc/init.d/ -perm /111 -type f -printf '%f\n'; for f in $(ls /etc/init/); do echo "${f%.conf}"; done } | sort -u > "${HOME}/Dokumente/Backups/dienste.txt"

# etckeeper
{ printf '%*s\n%s\n' "80" '' "etckeeper" | tr ' ' - ; } 1>&2
cd /etc &&
{
    sudo git ls-files --deleted -z | xargs -0 git rm 1>/dev/null 2>&1
    sudo git add -A . 1>/dev/null 2>&1
    sudo git commit -m "$(date): backup preparing"
}

# exif
{ printf '%*s\n%s\n' "80" '' "Publikationen_Metadaten" | tr ' ' - ; } 1>&2
exiftool_publikationen_metadaten_erstellen.sh

# taskwarrior
{ printf '%*s\n%s\n' "80" '' "Taskwarrior" | tr ' ' - ; } 1>&2
task-makedirs.sh

# rsync
{ printf '%*s\n%s\n' "80" '' "Rsync" | tr ' ' - ; } 1>&2
rsync-repositorium-backup-alt.sh
rsync-repositorium-backup.sh

# pdnsd abfragen
{ printf '%*s\n%s\n' "80" '' "pdnsd" | tr ' ' - ; } 1>&2
#pdnsd_start.sh
#sudo pdnsd-ctl status > "${HOME}/Dokumente/Backups/pdnsd/pdnsd-status_$(date +"%Y"-"%m"-"%d"-"%R").txt"
#sudo pdnsd-ctl dump > "${HOME}/Dokumente/Backups/pdnsd/pdnsd-dump_$(date +"%Y"-"%m"-"%d"-"%R").txt"

# passivedns.log sichern
{ printf '%*s\n%s\n' "80" '' "passivedns" | tr ' ' - ; } 1>&2
passivedns-archiv.sh
sudo cp -- /var/log/passivedns-archive/*.gz "${HOME}/logs/passivedns"

# backup firefox urls
{ printf '%*s\n%s\n' "80" '' "FirefoxUrls" | tr ' ' - ; } 1>&2
backup-firefox-urls.sh

# Delete Firexox places.sqlite
{ printf '%*s\n%s\n' "80" '' "Delete Firefox places.sqlite" | tr ' ' - ; } 1>&2
find "${HOME}/.mozilla/firefox" -type f -name "places.sqlite" -delete

# profile cleaner
{ printf '%*s\n%s\n' "80" '' "Profile Cleaner" | tr ' ' - ; } 1>&2
profile-cleaner f
profile-cleaner p "${HOME}/.newsbeuter"
profile-cleaner t
profile-cleaner p "${HOME}/.config/qupzilla/profiles"

# Delete /var/log/pm-powersave.log
{ printf '%*s\n%s\n' "80" '' "DELETE:'/var/log/pm-powersave.log'" | tr ' ' '-' ; } 1>&2
sudo rm -r -- /var/log/pm-powersave.log

# ccleaner
{ printf '%*s\n%s\n' "80" '' "ccleaner" | tr ' ' '-' ; } 1>&2
cclean.sh

# Mail-Report
{ printf '%*s\n%s\n' "80" '' "Mail Report" | tr ' ' - ; } 1>&2
logfile=${HOME}/logs/backup-vorbereitung_log.txt
empfaenger=backup-preparing@backup-preparing
betreff="BackupPreparing-log"
echo "$(date +"%Y"-"%m"-"%d"_"%R")" >> "$logfile"
tail -n1 "$logfile" | mail -s "$betreff" "$empfaenger"
