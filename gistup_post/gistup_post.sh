#!/usr/bin/env bash

find /home/user/code/gist-pub/ -mindepth 2 -maxdepth 2 -type d -name ".git" -exec rename -f 's/.git/ign/' {} +

cd -- /home/user/code/gist-pub &&
{
    git add -A .
    git commit -m "auto"
    git push origin master
}

find /home/user/code/gist-pub/ -mindepth 2 -maxdepth 2 -type d -name "ign" -exec rename -f 's/ign/.git/' {} +
