#!/usr/bin/env bash

# My gistup wrapper

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
        desc=$1 \
        url=

if [[ ! -d ./.git && $desc ]]
then
    gistup --no-open --public --remote origin -m "$desc"
    [[ -f ./.git/config ]] &&
    {
        read -r _ _ url 0< <(grep -m 1 -e '^[[:space:]]url = git@gist.github.com:.*.git$' "./.git/config")
        url=${url#git@gist.github.com:*}
        printf '%s\n' "https://gist.github.com/D630/${url%*.git}" 1> "./${url%*.git}"
        find "$(pwd)" ! -path '*.git*' -name '*.*' -exec ln -f -s {} -t "${HOME}/bin" \;
    }
elif [[ -d ./.git ]]
then
    git add -A .
    git commit -m 'update'
    git push -u origin master
fi

gistup-post.sh
