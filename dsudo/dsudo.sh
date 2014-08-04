#!/usr/bin/env bash

# Using sudo with dmenu2 via SUDO_ASKPASS

declare -rx SUDO_ASKPASS=${HOME}/bin/smenu.sh
sudo -A $@
