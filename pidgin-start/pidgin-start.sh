#!/usr/bin/env bash

# Run pidgin

sudo service avahi-daemon start && (exec pidgin &)
