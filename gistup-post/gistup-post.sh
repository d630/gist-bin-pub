#!/usr/bin/env bash

# Postprocessing for gists on https://github.com/D630/gist-pub

find "${HOME}/code/gist-pub/" -mindepth 2 -maxdepth 2 -type d -name ".git" -exec rename -f 's/\.git/gistup_ign/' {} +

cd -- "${HOME}/code/gist-pub" &&
{
    git add -A .
    git commit -m "auto"
    git push origin master
}

find "${HOME}/code/gist-pub/" -mindepth 2 -maxdepth 2 -type d -name "gistup_ign" -exec rename -f 's/gistup_ign/\.git/' {} +
