#!/usr/bin/env bash

# create Template: bash

declare dir=${HOME}/stow/bin/bin

if tty -s
then
    declare editor=$X_TTY_EDITOR
elif [[ $DISPLAY ]]
then
    declare editor=$EDITOR
fi

[[ ! $1 ]] && exit 1

printf '%s\n' '#!/usr/bin/env bash

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
' >> ${dir}/${1}.sh && chmod u+x ${dir}/${1}.sh

exec ${editor} ${dir}/${1}.sh
