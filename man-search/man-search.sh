#!/usr/bin/env bash

# man searching

man "$1" | grep -iC2 --color=always "$2" | more
