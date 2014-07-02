#!/usr/bin/env bash

get-xids.sh | xwinpp print --visible -P 0 | xwinreg -I - -L 1,max,grid-vertical,alias:0,all
