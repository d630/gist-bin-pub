#!/usr/bin/env bash

# Home backup with bup

declare -xr BUP_DIR=/media/truecrypt1/ubuntu/bup

bup index -ux /home --exclude=${HOME}/.cpan
bup save -n home /home
