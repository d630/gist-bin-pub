#!/usr/bin/env bash

# Simple notetaker using ledit

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

declare \
        store=${XDG_DATA_HOME:-${HOME/.local/share}}/kuno2 \
        date=$(date --utc --date now +%s)

mkdir -p -- "$store"
ledit -x -h "${store}/${date}"
