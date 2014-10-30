#!/usr/bin/env bash

# MediathekView (german tv)

case $1 in
    run)
        java -jar "${X_XDG_CODE_DIR}/java/MediathekView/MediathekView.jar"
        ;;
    load)
        "${X_XDG_CODE_DIR}/java/MediathekView/MediathekView__Linux.sh" -auto -noGui
        ;;
    *)
        { echo "Usage: mediathekiew.sh (run|load)" 1>&2 ; exit 1 ; }
esac
