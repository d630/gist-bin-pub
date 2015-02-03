#!/usr/bin/env sh

# Paketlisten

sudo rm -r -- "${X_XDG_BACKUPS_DIR}/paketlisten"
mkdir -p -- "${X_XDG_BACKUPS_DIR}/paketlisten"
cd -- "${X_XDG_BACKUPS_DIR}/paketlisten" && {
    COLUMNS=200 dpkg-query -l > "packages_list.list"
    dpkg --get-selections | awk '!/deinstall|purge|hold/ {print $1}' > "packages.list"
    apt-mark showauto > "package-states-auto"
    apt-mark showmanual > "package-states-manual"
    find /etc/apt/sources.list* -type f -name '*.list' -exec bash -c 'echo -e "\n## $1 " ; grep "^[[:space:]]*[^#[:space:]]" ${1}' _ {} \; > "sources.list.save"
    sudo cp -- "/etc/apt/trusted.gpg" "trusted-keys.gpg"
}

apt-cache policy > "${X_XDG_BACKUPS_DIR}/apt-quellen.txt"
