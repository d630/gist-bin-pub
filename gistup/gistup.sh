#!/usr/bin/env bash

# My gistup wrapper

declare \
    desc=$1 \
    url=

github-add-rsa.sh

if [[ -d ./.git ]]
then
    desc="$(basename "$PWD"): ${desc:-auto-update}"
    git add -A .
    git commit -m "$desc"
    git push -u origin master
    (($? == 0)) || exit $?
    if cd -- "${HOME}/stow/bin/gist-pub"
    then
        git add -f "$OLDPWD"
        git commit -m "$desc"
        git push -u origin master
    else
        { printf '%s\n' "${0}:Error:80: Could not cd into gist-pub." 1>&2 ; exit 80 ; }
    fi
else
    printf '%s\n' "${0}:Error:79: Not a git repository (or any of the parent directories): .git" 1>&2
    if [[ $desc ]]
    then
        gistup --no-open --public --remote origin -m "$desc"
        if [[ -f ./.git/config ]]
        then
            read -r _ _ url < <(grep -m 1 -e '^[[:space:]]url = git@gist.github.com:.*.git$' "./.git/config")
            url=${url#git@gist.github.com:*}
            printf '%s\n' "https://gist.github.com/D630/${url%*.git}" "$desc" > "./${url%*.git}"
            find "$PWD" ! -path '*.git*' -name '*.*' -exec ln -f -s {} -t "${HOME}/bin" \;
            git add -f "./${url%*.git}"
            git commit -m "add info file"
            git push -u origin master
            if cd -- "${HOME}/stow/bin/gist-pub"
            then
                git add -f "$OLDPWD"
                git commit -m "create: https://gist.github.com/D630/${url%*.git}"
                git push -u origin master
            else
                { printf '%s\n' "${0}:Error:80: Could not cd into gist-pub." 1>&2 ; exit 80 ; }
            fi
        else
            { printf '%s\n' "${0}:Error:81: Could not parse a conf file." 1>&2 ; exit 81 ; }
        fi
    else
        { printf '%s\n' "${0}:Error:82: Could not create a git repository: a description is missing" 1>&2 ; exit 82 ; }
    fi
fi
