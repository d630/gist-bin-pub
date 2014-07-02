#!/usr/bin/env bash

# elinks wrapper

elinks -session-ring 1 ${1:+$1}
