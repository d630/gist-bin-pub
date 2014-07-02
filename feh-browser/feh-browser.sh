#!/usr/bin/env bash

# feh browser (source: archlinux wiki)

shopt -s nullglob

[[ ! -f $1 ]] && { printf '%s\n' "${0}: first argument is not a file." 1>&2 ; exit 1 ; }

declare file=$(basename -- "$1") \
        dir=$(dirname -- "$1")
declare -a arr=()

shift 1

cd -- "$dir" &&
{
    for i in *
    do
        [[ -f $i ]] || continue
        arr+=("$i")
        [[ $i == $file ]] && c=$((${#arr[@]}-1))
    done
}

(exec feh "$@" -- "${arr[@]:c}" "${arr[@]:0:c}" &)
