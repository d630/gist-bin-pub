#!/usr/bin/env bash

# Show running services started with Upstart

sudo initctl list | grep "process"
