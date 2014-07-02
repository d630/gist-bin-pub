#!/usr/bin/env bash

# print and number arguments

printf '%b\n' "$0" "$@" | nl -v0 -s": "
