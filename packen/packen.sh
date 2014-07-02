#!/usr/bin/env bash

# tar and gzip $1

tar czvf "$1-$(date +%y%m%d-%H%M%S).tar.gz" "$1"
