#!/usr/bin/env bash

# Man2pdf

man -w "$@" 2>/dev/null
man -t "$@" | ps2pdf - "${@}.pdf"
printf '%s\n' "${@}.pdf"
