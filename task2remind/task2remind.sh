#!/usr/bin/env bash

# Taskwarrior > ical > Remind

# modified line in task_export-ical.pl :
# my $command = join (' ', ("env PATH=$ENV{PATH} task rc:/home/user/.taskrc rc.verbose=nothing rc.json.array=no due.after:2013-01-01_00:01 and '(status:pending or status:waiting)' export", @ARGV));

ical2rem-cli -t --lead-time "" < <(task_export-ical.pl | grep -v "PRIORITY:") | sed 's#[[:blank:]][[:blank:]]##g' > /home/user/.ical2rem
