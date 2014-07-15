#!/usr/bin/env bash

# Weekly home backup with bup

declare -x \
           BUP_DIR=/media/truecrypt1/ubuntu/bup \
           today=$(date +%Y-%m-%d)

while IFS= read -r -d ''
do
    (( ${today//-/} - ${REPLY//-/} > 14 )) &&
    tmp_dir=$(mktemp -d --tmpdir) &&
    rsync -var --delete "${tmp_dir}/" "${BUP_DIR}/${REPLY}/" &&
    trap 'rm -Rf "$tmp_dir" "${BUP_DIR}/${REPLY}"' EXIT &&
    printf '%s\n' "${BUP_DIR}/${REPLY} has been deleted." 1>&2
done < <(find "$BUP_DIR" -maxdepth 1 -type d -printf '%f\0' | sort -zn | sed -zn '$!p')

BUP_DIR=/media/truecrypt1/ubuntu/bup/${today}

bup index -ux /home --exclude=${HOME}/stow/local/cpan/.cpan
bup save -n home /home
