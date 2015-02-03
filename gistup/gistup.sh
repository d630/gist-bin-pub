#!/usr/bin/env bash

# My gistup wrapper

declare \
    basename=${PWD##*/} \
    desc=$1 \
    dirname=${PWD%/*} \
    gpp=${HOME}/stow/bin/gist-pub \
    pwd=$PWD \
    url=

github-add-rsa.sh

[[ $dirname == $gpp ]] || { printf '%s\n' "${0}:Error:83: '${basename}' is not a subdir of '${gpp}'" 1>&2 ; exit 83 ; }
[[ -x $(type -p gistup) ]] || { printf '%s\n' "${0}:Error:84: command not found: 'gistup'" 1>&2 ; exit 84 ; }

if [[ -d ./.git ]]
then
    desc="${basename}: ${desc:-update}"
    git add -A . && \
    git commit -m "$desc" && \
    git push -u origin master
    if (($? == 0)) && cd -- "$gpp"
    then
        git add "./${basename}" && \
        git commit -m "$desc" && \
        git push -u origin master
    else
        { printf '%s\n' "${0}:Error:80: Could not cd into '${gpp}'" 1>&2 ; exit 80 ; }
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
            (find "$pwd" ! -path '*.git*' -name '*.*' -exec ln -vf -s {} -t "${HOME}/bin" \;)
            git add "./${url%*.git}" && \
            git commit -m "${basename}: add info file" && \
            git push -u origin master
            if (($? == 0)) && cd -- "$gpp"
            then
                git add "./${basename}" && \
                git commit -m "${basename}: init" && \
                git push -u origin master
            else
                { printf '%s\n' "${0}:Error:80: Could not cd into '${gpp}'" 1>&2 ; exit 80 ; }
            fi
        else
            { printf '%s\n' "${0}:Error:81: Could not parse a conf file" 1>&2 ; exit 81 ; }
        fi
    else
        { printf '%s\n' "${0}:Error:82: Could not create a git repository: a description is missing" 1>&2 ; exit 82 ; }
    fi
fi
