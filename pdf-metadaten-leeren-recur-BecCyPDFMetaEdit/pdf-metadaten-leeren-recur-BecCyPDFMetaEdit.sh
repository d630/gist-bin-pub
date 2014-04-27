#!/usr/bin/env bash

# Remove PDF metadat with BeCyPDFMetaEdit

wine "/home/user/.wine/drive_c/Program Files (x86)/BeCyPDFMetaEdit/BeCyPDFMetaEdit.exe" "./*.pdf" -s -d 2 -T "" -S "" -A "" -K "" -R "" -P "" -C "" -M "" -X 1 -q
