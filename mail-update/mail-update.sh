#!/usr/bin/env bash

# Mail scripts wrapper

(exec mail-sending.sh &)
(exec mail-getting.sh &)
