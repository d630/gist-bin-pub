#!/usr/bin/env bash

# Prepare full backup for Meinecke

printf -v horiz '%*s' "80" ''

# Ini
printf '%s\n' "${horiz// /-}" "Ini" 1>&2
event-loop-stop.sh

# mlr
printf '%s\n' "${horiz// /-}" "mlr" 1>&2
mlr.sh

# Mr
printf '%s\n' "${horiz// /-}" "mr" 1>&2
mr-update.sh

# Apt && Packages
printf '%s\n' "${horiz// /-}" "Apt && Packages" 1>&2
(
    sudo dpkg --clear-avail
    sudo apt-get autoclean
    sudo apt-get autoremove --purge
    sudo dpkg --configure -a
    sudo apt-get install -f
    source backup-apt.sh
)

# Programs
printf '%s\n' "${horiz// /-}" "Programs" 1>&2
backup-programs.sh

# Inits
printf '%s\n' "${horiz// /-}" "Inits" 1>&2
backup-init.sh

# etckeeper
printf '%s\n' "${horiz// /-}" "etckeeper" 1>&2
(sudo etckeeper commit "$(date): backup preparing")

# Taskwarrior
printf '%s\n' "${horiz// /-}" "Taskwarrior" 1>&2
task-makedirs.sh

# passivedns
#printf '%s\n' "${horiz// /-}" "passivedns" 1>&2
#passivedns-archiv.sh
#(sudo cp -- /var/log/passivedns-archive/*.gz "${X_XDG_LOG_HOME}/passivedns")

# firefox-urls
printf '%s\n' "${horiz// /-}" "firefox-urls" 1>&2
backup-firefox-urls.sh

# Refresh Firefox Profiles
printf '%s\n' "${horiz// /-}" "Refresh Firefox Profiles" 1>&2
firefox-profiles-refresh.sh

# Delete pm-powersave.log
printf '%s\n' "${horiz// /-}" "Delete pm-powersave.log" 1>&2
(sudo rm -r -- "/var/log/pm-powersave.log" 2>/dev/null)

# ccleaner
printf '%s\n' "${horiz// /-}" "ccleaner" 1>&2
cclean.sh

# Mail-Report
printf '%s\n' "${horiz// /-}" "Mail-Report" 1>&2
echo "$(date +"%Y"-"%m"-"%d"_"%R")" | tee >(mail -s BackupPreparing-log backup-preparing@backup-preparing) >> "${X_XDG_LOG_HOME}/backup-preparing.log"
