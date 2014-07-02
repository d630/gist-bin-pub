#!/usr/bin/env bash

# dpkg --purge

dpkg -l | grep '^rc ' | cut -d " " -f3 | xargs dpkg --purge
