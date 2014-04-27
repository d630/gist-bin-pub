#!/usr/bin/env bash

# Create Manpage from ronn file

cp -- "$1" "${1%.*}.ronn"
ronn --roff "${1%.*}.ronn"
