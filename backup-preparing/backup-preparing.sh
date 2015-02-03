#!/usr/bin/env bash

# Prepare full backup for Meinecke

# Ini
{ printf -v horiz '%*s\n%s' "80" '' "Ini" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
clipbored -k
pkill clipbored
while read -r
do
    pkill -P $REPLY 1>/dev/null 2>&1
done < <(pgrep -f event-loop.sh)

# Connection
#{ printf -v horiz '%*s\n%s' "80" '' "Connection" ; printf '%s\n' "${horiz// /-}" ; } 1>&2

# MySql
#{ printf -v horiz '%*s\n%s' "80" '' "MySql" ; printf '%s\n' "${horiz// /-}" ; } 1>&2

# mlr
{ printf -v horiz '%*s\n%s' "80" '' "mlr" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
mlr.sh

# Packages & Repos
{ printf -v horiz '%*s\n%s' "80" '' "Packages & Repos" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
sudo dpkg --clear-avail
sudo apt-get autoclean
sudo apt-get autoremove
sudo dpkg --configure -a
sudo apt-get install -f
#mr -j5 update
sudo rm -r -- "${X_XDG_BACKUPS_DIR}/paketlisten" &&
mkdir -- "${X_XDG_BACKUPS_DIR}/paketlisten" &&
cd -- "${X_XDG_BACKUPS_DIR}/paketlisten" && {
    COLUMNS=200 dpkg-query -l > "packages_list.list"
    dpkg --get-selections | awk '!/deinstall|purge|hold/ {print $1}' > "packages.list"
    apt-mark showauto > "package-states-auto"
    apt-mark showmanual > "package-states-manual"
    find /etc/apt/sources.list* -type f -name '*.list' -exec bash -c 'echo -e "\n## $1 " ; grep "^[[:space:]]*[^#[:space:]]" ${1}' _ {} \; > "sources.list.save"
    sudo cp -- "/etc/apt/trusted.gpg" "trusted-keys.gpg"
}

# Programs
{ printf -v horiz '%*s\n%s' "80" '' "Programs" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
ls $(printf '%s ' ${PATH//:/ }) "/usr/bin/X11" | xargs whatis | sort | uniq > "${X_XDG_BACKUPS_DIR}/Programme.txt"

# Apt
{ printf -v horiz '%*s\n%s' "80" '' "Apt" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
apt-cache policy > "${X_XDG_BACKUPS_DIR}/apt-quellen.txt"

# Last 7 Days
{ printf -v horiz '%*s\n%s' "80" '' "Last 7 Days" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
find "/var/lib/dpkg/info/" -daystart \( -name \*.list -a -mtime -7 \) | sed 's/.list$//;s/.*\///' | sort > "${X_XDG_BACKUPS_DIR}/software_7_days.txt"

# Init
{ printf -v horiz '%*s\n%s' "80" '' "Init" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
{ find "/etc/init.d/" -perm /111 -type f -printf '%f\n'; while IFS= read -r -d '' ; do printf '%s\n' "${REPLY%*.*}" ; done < <(find "/etc/init" -type f -printf '%f\0') ; } | sort -u > "${X_XDG_BACKUPS_DIR}/dienste.txt"

# etckeeper
{ printf -v horiz '%*s\n%s' "80" '' "etckeeper" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
cd -- "/etc" && {
    sudo git add -A . 1>/dev/null 2>&1
    sudo git commit -a -m "$(date): backup preparing"
}

# Publikationen-Metadaten
#{ printf -v horiz '%*s\n%s' "80" '' "Publikationen-Metadaten" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
#exiftool-publikationen-metadaten-erstellen.sh

# Taskwarrior
{ printf -v horiz '%*s\n%s' "80" '' "Taskwarrior" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
task-makedirs.sh

# rsync
#{ printf -v horiz '%*s\n%s' "80" '' "rsync" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
#rsync-repositorium-backup-alt.sh
#rsync-repositorium-backup.sh

# pdnsd
#{ printf -v horiz '%*s\n%s' "80" '' "pdnsd" ; printf '%s\n' "${horiz// /-}" ; } 1>&2

# passivedns
#{ printf -v horiz '%*s\n%s' "80" '' "passivedns" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
#passivedns-archiv.sh
#sudo cp -- /var/log/passivedns-archive/*.gz "${X_XDG_LOG_HOME}/passivedns"

# firefox-urls
{ printf -v horiz '%*s\n%s' "80" '' "firefox-urls" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
backup-firefox-urls.sh

# Delete Firefox Profiles
{ printf -v horiz '%*s\n%s' "80" '' "Delete Firefox Profiles" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
shopt -s extglob
declare tmp_dir=$(mktemp -d --tmpdir)
for i in ${HOME}/.mozilla/firefox/*.!(clean-template|ini)
do
    rsync -var --delete "${tmp_dir}/" "${i}/"
    rsync -var ${HOME}/.mozilla/firefox/*.clean-template/ "${i}/"
done
shopt -u extglob

# ProfileCleaner
#{ printf -v horiz '%*s\n%s' "80" '' "ProfileCleaner" ; printf '%s\n' "${horiz// /-}" ; } 1>&2

# Delete pm-powersave.log
{ printf -v horiz '%*s\n%s' "80" '' "Delete powersave.log'" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
sudo rm -r -- "/var/log/pm-powersave.log" 2>/dev/null

# ccleaner
{ printf -v horiz '%*s\n%s' "80" '' "ccleaner" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
cclean.sh

# Mail-Report
{ printf -v horiz '%*s\n%s' "80" '' "Mail-Report" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
logfile=${X_XDG_LOG_HOME}/backup-preparing.log
to=backup-preparing@backup-preparing
subj="BackupPreparing-log"
echo "$(date +"%Y"-"%m"-"%d"_"%R")" | tee >(mail -s "$subj" "$to") >> "$logfile"
