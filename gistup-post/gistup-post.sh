#!/usr/bin/env bash

# Postprocessing for gists on https://github.com/D630/gist-pub

find "${HOME}/stow/bin/gist-pub/" -mindepth 2 -maxdepth 2 -type d -name ".git" -exec rename -f 's/\.git/gistup_ign/' {} +

cd -- "${HOME}/stow/bin/gist-pub" &&
{
    git add -A .
    git commit -m "${1:-auto-update}"
    git push -u origin master
}

find "${HOME}/stow/bin/gist-pub/" -mindepth 2 -maxdepth 2 -type d -name "gistup_ign" -exec rename -f 's/gistup_ign/\.git/' {} +
