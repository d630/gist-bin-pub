#!/usr/bin/env bash

# Wrapper for getting my news

feedcacher.sh
newsbeuter -r -l 3 -d "${X_XDG_LOG_HOME}/newsbeuter.log"
newsbeuter -X
{ printf -v horiz '%*s' "80" '' ; printf '%s\n' "${horiz// /-}" ; } 1>&2
(XDG_DATA_HOME=$X_XDG_LIB_DIR urldiff -nv)
