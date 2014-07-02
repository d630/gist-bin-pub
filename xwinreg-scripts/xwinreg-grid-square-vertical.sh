#!/usr/bin/env bash

get_xids.sh | xwinpp print -I - --visible -P 0 | xwinreg -I - -L 1,max,grid-square-vertical,alias:0,all
