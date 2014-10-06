#!/usr/bin/env bash

# unhide all windows on current desktop, and the active region of xwinreg

xwinreg-unhide-active-region.sh

get-xids.sh | xwinpp -I - --hidden --desk=curr -p | xwinmo - -U
