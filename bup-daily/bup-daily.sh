#!/usr/bin/env bash

# Daily home backup with bup

# -- DEBUGGING.

#printf "%s (%s)\n" "$BASH_VERSION" "${BASH_VERSINFO[5]}" && exit 0
#set -o xtrace #; exec 2>> "${X_XDG_LOG_HOME}/${1}.log
#set -o verbose
#set -o noexec
#set -o errexit
#set -o nounset
#set -o pipefail
#trap "(read -p "[$BASH_SOURCE:$LINENO] $BASH_COMMAND?")" DEBUG

# -- SETTINGS.

#declare vars_base=$(set -o posix ; set)

# -- FUNCTIONS.

# -- MAIN.

declare -x BUP_DIR=/media/truecrypt1/linux/bup

while IFS= read -r -d ''
do
    BUP_DIR=/media/truecrypt1/linux/bup/${REPLY}
done < <(find "$BUP_DIR" -maxdepth 1 -type d -printf '%f\0' | sort -zn | sed -zn '$p')

bup index -ux /home --exclude=${HOME}/stow/local/cpan/.cpan
bup save -n home /home
