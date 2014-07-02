#!/usr/bin/env bash

# Find string with find and grep

find . -name "*${2}" -print | xargs grep -nir "${1}"
