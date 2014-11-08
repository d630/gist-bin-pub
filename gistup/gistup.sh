#!/usr/bin/env bash

# My gistup wrapper

declare \
    desc=$1 \
    url=

if [[ ! -d ./.git ]]
then
    if [[ $desc ]]
    then
        gistup --no-open --public --remote origin -m "$desc"
        if [[ -f ./.git/config ]]
        then
            read -r _ _ url < <(grep -m 1 -e '^[[:space:]]url = git@gist.github.com:.*.git$' "./.git/config")
            url=${url#git@gist.github.com:*}
            printf '%s\n' "https://gist.github.com/D630/${url%*.git}" "$desc" > "./${url%*.git}"
            find "$PWD" ! -path '*.git*' -name '*.*' -exec ln -f -s {} -t "${HOME}/bin" \;
            git add -A .
            git commit -m "add info file"
            git push -u origin master
            gistup-post.sh "create: https://gist.github.com/D630/${url%*.git}"
        else
            { printf '%s\n' "${0}:Error:79: Could not parse a conf file." 1>&2 ; exit 79 ; }
        fi
    else
        { printf '%s\n' "${0}:Error:80: Not a git repository (or any of the parent directories): .git" 1>&2 ; exit 80 ; }
    fi
else
    git add -A .
    git commit -m "${desc:-auto-update}"
    git push -u origin master
    gistup-post.sh "${desc:-auto-update}"
fi
