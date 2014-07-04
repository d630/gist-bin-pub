#!/usr/bin/env bash

# Source or print structured all defaults of the configuration settings (Taskwarrrior v2.3.0)

# Usage:
# $ task-cv print
# $ source task-cv

declare -A aliase \
           color_controls \
           customs \
           dates \
           defaults \
           dependencies \
           extensions \
           files \
           holidays \
           journal_entries \
           miscellaneous \
           reports \
           shadow_file \
           shell \
           sync \
           terminal \
           urgency

aliase[alias.burndown]=burndown.weekly
aliase[alias.ghistory]=ghistory.monthly
aliase[alias.history]=history.monthly
aliase[alias._query]=export
aliase[alias.rm]=delete
aliase[alias.shell]='exec tasksh'
color_controls[color.active]='rgb555 on rgb410'
color_controls[color.alternate]='on color233'
color_controls[color.blocked]='white on color8'
color_controls[color.blocking]='white on color6'
color_controls[color.burndown.done]='color0 on rgb050'
color_controls[color.burndown.pending]='color0 on rgb500'
color_controls[color.burndown.started]='color0 on rgb550'
color_controls[color.calendar.due]='color0 on color1'
color_controls[color.calendar.due.today]='color15 on color1'
color_controls[color.calendar.holiday]='color0 on color11'
color_controls[color.calendar.overdue]='color0 on color9'
color_controls[color.calendar.today]='color15 on rgb013'
color_controls[color.calendar.weekend]='color235'
color_controls[color.calendar.weeknumber]='rgb013'
color_controls[color.debug]='color3'
color_controls[color.due]='color1'
color_controls[color.due.today]='rgb400'
color_controls[color.error]='color3'
color_controls[color.footnote]='color3'
color_controls[color.header]='color3'
color_controls[color.history.add]='color0 on rgb500'
color_controls[color.history.delete]='color0 on rgb550'
color_controls[color.history.done]='color0 on rgb050'
color_controls[color]=off
color_controls[color.overdue]='color9'
color_controls[color.pri.H]='rgb255'
color_controls[color.pri.L]='rgb245'
color_controls[color.pri.M]='rgb250'
color_controls[color.pri.none]=''
color_controls[color.recurring]='rgb013'
color_controls[color.scheduled]='rgb444 on rgb410'
color_controls[color.summary.background]='white on color0'
color_controls[color.summary.bar]='black on rgb141'
color_controls[color.sync.added]='rgb005'
color_controls[color.sync.changed]='rgb550'
color_controls[color.sync.rejected]='rgb500'
color_controls[color.tagged]='rgb031'
color_controls[color.undo.after]='color2'
color_controls[color.undo.before]='color1'
color_controls[fontunderline]=yes
color_controls[rule.precedence.color]=due.today,active,blocking,blocked,overdue,due,scheduled,keyword.,project.,tag.,uda.,recurring,pri.,tagged,completed,deleted
customs["#color.keyword.X"]='on blue'
customs["#color.project.X"]='on green'
customs["#color.tag.X"]=yellow
customs["#color.uda.X"]='on green'
customs["#holiday.X.date"]=
customs["#holiday.X.name"]=
customs["#include color.theme"]=
customs["#include holidays.rc"]=
customs["#report.X.annotations"]=DEPRECATED
customs["#report.X.columns"]=
customs["#report.X.dateformat"]=
customs["#report.X.dateformat"]=
customs["#report.X.description"]=
customs["#report.X.filter"]=
customs["#report.X.labels"]=
customs["#report.X.limit"]=DEPRECATED
customs["#report.X.sort"]=
customs["#uda.<name>.default"]=
customs["#uda.<name>.label"]='<column heading>'
customs["#uda.<name>.type"]='string|numeric|date|duration'
customs["#uda.<name>.values"]='A,B,C'
customs["#urgency.uda.<name>.coefficient"]=
customs["#urgency.user.project.<project>.coefficient"]=
customs["#urgency.user.tag.<tag>.coefficient"]=
dates[calendar.details.report]=list
dates[calendar.details]=sparse
dates[calendar.holidays]=none
dates[calendar.legend]=yes
dates[calendar.offset]=no
dates[calendar.offset.value]=-1
dates[dateformat.annotation]=
dates[dateformat.edit]='Y-M-D H:N:S'
dates[dateformat.holiday]=YMD
dates[dateformat.info]='Y-M-D H:N:S'
dates[dateformat.report]=
dates[dateformat]=Y-M-D
dates[displayweeknumber]=yes
dates[due]=7
dates[weekstart]=sunday
defaults[default.command]=next
defaults[default.due]=
defaults[default.priority]=
defaults[default.project]=
dependencies[dependency.confirmation]=on
dependencies[dependency.reminder]=on
extensions[extensions]=off
files["#data.location"]=
files[exit.on.missing.db]=no
files[gc]=on
files[locking]=on
holidays[monthsperline]=3
journal_entries[journal.info]=on
journal_entries[journal.time]=no
journal_entries[journal.time.start.annotation]='Started task'
journal_entries[journal.time.stop.annotation]='Stopped task'
miscellaneous[abbreviation.minimum]=2
miscellaneous[active.indicator]='*'
miscellaneous[bulk]=3
miscellaneous[burndown.bias]=0.666
miscellaneous[column.padding]=1
miscellaneous[complete.all.projects]=no
miscellaneous[complete.all.tags]=no
miscellaneous[confirmation]=yes
miscellaneous[debug]=no
miscellaneous[debug.tls]=0
miscellaneous[dependency.indicator]=D
miscellaneous[dom]=on
miscellaneous[expressions]=on
miscellaneous[_forcecolor]=no
miscellaneous[indent.annotation]=2
miscellaneous[indent.report]=0
miscellaneous[json.array]=off
miscellaneous[list.all.projects]=no
miscellaneous[list.all.tags]=no
miscellaneous[locale]=
miscellaneous[nag]='You have more urgent tasks.'
miscellaneous[patterns]=on
miscellaneous[print.empty.columns]=no
miscellaneous[recurrence.indicator]=R
miscellaneous[recurrence.limit]=1
miscellaneous[regex]=no
miscellaneous[row.padding]=0
miscellaneous[search.case.sensitive]=yes
miscellaneous[tag.indicator]='+'
miscellaneous[undo.style]=side
miscellaneous[verbose]=yes
miscellaneous[xterm.title]=no
reports[report.active.columns]='id,project,priority,due,start.active,entry.age,description'
reports[report.active.description]='Lists'
reports[report.active.filter]='status:pending'
reports[report.active.labels]='ID,Proj,Pri,Due,Active,Age,Description'
reports[report.active.sort]='due+,priority-,project+'
reports[report.all.columns]='id,status,project,priority,due,end,start.active,entry.age,description'
reports[report.all.description]='Lists'
reports[report.all.filter]='status.not:deleted'
reports[report.all.labels]='ID,Status,Proj,Pri,Due,Completed,Active,Age,Description'
reports[report.all.sort]='entry+'
reports[report.blocked.columns]='id,depends,project,priority,due,start.active,entry.age,description'
reports[report.blocked.description]='Lists'
reports[report.blocked.filter]='status:pending'
reports[report.blocked.labels]='ID,Deps,Proj,Pri,Due,Active,Age,Description'
reports[report.blocked.sort]='due+,priority-,start-,project+'
reports[report.blocking.columns]='id,depends,project,priority,due,start.active,entry.age,description'
reports[report.blocking.description]='Lists'
reports[report.blocking.filter]='status:pending'
reports[report.blocking.labels]='ID,Deps,Proj,Pri,Due,Active,Age,Description'
reports[report.blocking.sort]='due+,priority-,start-,project+'
reports[report.completed.columns]='end,project,priority,entry.age,description,uuid'
reports[report.completed.description]='Lists'
reports[report.completed.filter]='status:completed'
reports[report.completed.labels]='Complete,Proj,Pri,Age,Description,UUID'
reports[report.completed.sort]='end+,priority-,project+'
reports[report.list.columns]='id,project,priority,due,start.active,entry.age,description'
reports[report.list.description]='Lists'
reports[report.list.filter]='status:pending'
reports[report.list.labels]='ID,Proj,Pri,Due,Active,Age,Description'
reports[report.list.sort]='due+,priority-,start-,project+'
reports[report.long.columns]='id,project,priority,entry,start,due,recur,due.countdown,entry.age,depends,tags,description'
reports[report.long.description]='Lists'
reports[report.long.filter]='status:pending'
reports[report.long.labels]='ID,Proj,Pri,Added,Started,Due,Recur,Countdown,Age,Deps,Tags,Description'
reports[report.long.sort]='due+,priority-,project+'
reports[report.ls.columns]='id,project,priority,description'
reports[report.ls.description]='Minimal'
reports[report.ls.filter]='status:pending'
reports[report.ls.labels]='ID,Proj,Pri,Description'
reports[report.ls.sort]='priority-,project+'
reports[report.minimal.columns]='id,project,description.truncated'
reports[report.minimal.description]='Minimal'
reports[report.minimal.filter]='status:pending'
reports[report.minimal.labels]='ID,Proj,Description'
reports[report.minimal.sort]='project+,description+'
reports[report.newest.columns]='id,project,priority,due,start.active,entry.age,description'
reports[report.newest.description]='Shows'
reports[report.newest.filter]='status:pending'
reports[report.newest.labels]='ID,Proj,Pri,Due,Active,Age,Description'
reports[report.newest.sort]='id-'
reports[report.next.columns]='id,project,priority,due,start.active,entry.age,urgency,description'
reports[report.next.description]='Lists'
reports[report.next.filter]='status:pending'
reports[report.next.labels]='ID,Proj,Pri,Due,A,Age,Urg,Description'
reports[report.next.sort]='urgency-,due+,priority-,start-,project+'
reports[report.oldest.columns]='id,project,priority,due,start.active,entry.age,description'
reports[report.oldest.description]='Shows'
reports[report.oldest.filter]='status:pending'
reports[report.oldest.labels]='ID,Proj,Pri,Due,Active,Age,Description'
reports[report.oldest.sort]='id+'
reports[report.overdue.columns]='id,project,priority,due,start.active,entry.age,description'
reports[report.overdue.description]='Lists'
reports[report.overdue.filter]='status:pending'
reports[report.overdue.labels]='ID,Proj,Pri,Due,Active,Age,Description'
reports[report.overdue.sort]='due+,priority-,start-,project+'
reports[report.ready.columns]='id,project,priority,due,start.active,entry.age,urgency,description'
reports[report.ready.description]='Lists'
reports[report.ready.filter]="status:pending limit:page -WAITING '(scheduled.none: or scheduled.before:now )'"
reports[report.ready.labels]='ID,Proj,Pri,Due,A,Age,Urg,Description'
reports[report.ready.sort]='urgency-,due+,priority-,start-,project+'
reports[report.recurring.columns]='id,project,priority,due,recur,start.active,entry.age,description'
reports[report.recurring.description]='Lists'
reports[report.recurring.filter]='status:pending'
reports[report.recurring.labels]='ID,Proj,Pri,Due,Recur,Active,Age,Description'
reports[report.recurring.sort]='due+,priority-,start-,project+'
reports[report.unblocked.columns]='id,depends,project,priority,due,start.active,entry.age,description'
reports[report.unblocked.description]='Lists'
reports[report.unblocked.filter]='status:pending'
reports[report.unblocked.labels]='ID,Deps,Proj,Pri,Due,Active,Age,Description'
reports[report.unblocked.sort]='due+,priority-,start-,project+'
reports[report.waiting.columns]='id,project,priority,wait,entry.age,description'
reports[report.waiting.description]='Lists'
reports[report.waiting.filter]='status:waiting'
reports[report.waiting.labels]='ID,Proj,Pri,Wait,Age,Description'
reports[report.waiting.sort]='wait+,priority-,project+'
shadow_file[shadow.command]=list
shadow_file["#shadow.file"]=$HOME/.task/shadow.txt
shadow_file[shadow.notify]=on
shell[shell.prompt]='task>'
sync["#taskd.certificate"]='<path>'
sync["#taskd.ciphers"]=NORMAL
sync["#taskd.credentials"]='<organization>/<user>/<key>'
sync["#taskd.key"]='<path>'
sync["#taskd.server"]='<host>:<port>'
sync["#taskd.trust"]='yes|no'
terminal[avoidlastcolumn]=no
terminal[defaultheight]=24
terminal[defaultwidth]=80
terminal[detection]=off
terminal["#editor"]=vi
terminal["#edit.verbose"]=DEPRECATED
terminal[hyphenate]=on
terminal[reserved.lines]=1
urgency[urgency.active.coefficient]=4.0
urgency[urgency.age.coefficient]=2.0
urgency[urgency.age.max]=365
urgency[urgency.annotations.coefficient]=1.0
urgency[urgency.blocked.coefficient]=-5.0
urgency[urgency.blocking.coefficient]=8.0
urgency[urgency.due.coefficient]=12.0
urgency[urgency.next.coefficient]=15.0
urgency[urgency.priority.coefficient]=6.0
urgency[urgency.project.coefficient]=1.0
urgency[urgency.scheduled.coefficient]=5.0
urgency[urgency.tags.coefficient]=1.0
urgency[urgency.waiting.coefficient]=-3.0

#--- Start.

[[ $1 == print ]] &&
{
    printf "# [Created by task-cv, using task $(task _version) $(date)]
# Taskwarrior program configuration file.
# For more documentation, see http://taskwarrior.org or try \'man task\', \'man task-faq\',
# \'man task-tutorial\', \'man task-color\', \'man task-sync\' or \'man taskrc\'

# Here is an example of entries that use the default, override and blank values
#   variable=foo   -- By specifying a value, this overrides the default
#   variable=      -- By specifying no value, this means no default
#   #variable=foo  -- By commenting out the line, or deleting it, this uses the default

# Use the commands 'task show' or 'task _show' to see all defaults and overrides

# Files
$(for i in "${!files[@]}" ; do printf '%s=%s\n' "$i" "${files[$i]}" ; done | sort)

# Terminal
$(for i in "${!terminal[@]}" ; do printf '%s=%s\n' "$i" "${terminal[$i]}" ; done | sort)

# Shell
$(for i in "${!shell[@]}" ; do printf '%s=%s\n' "$i" "${shell[$i]}" ; done | sort)

# Miscellaneous
$(for i in "${!miscellaneous[@]}" ; do printf '%s=%s\n' "$i" "${miscellaneous[$i]}" ; done | sort)

# Extensions
$(for i in "${!extensions[@]}" ; do printf '%s=%s\n' "$i" "${extensions[$i]}" ; done | sort)

# Dates
$(for i in "${!dates[@]}" ; do printf '%s=%s\n' "$i" "${dates[$i]}" ; done | sort)

# Journal Entries
$(for i in "${!journal_entries[@]}" ; do printf '%s=%s\n' "$i" "${journal_entries[$i]}" ; done | sort)

# Holidays
$(for i in "${!holidays[@]}" ; do printf '%s=%s\n' "$i" "${holidays[$i]}" ; done | sort)

# Dependencies
$(for i in "${!dependencies[@]}" ; do printf '%s=%s\n' "$i" "${dependencies[$i]}" ; done | sort)

# Color Controls
$(for i in "${!color_controls[@]}" ; do printf '%s=%s\n' "$i" "${color_controls[$i]}" ; done | sort)

# Urgency
$(for i in "${!urgency[@]}" ; do printf '%s=%s\n' "$i" "${urgency[$i]}" ; done | sort)

# Shadow File
$(for i in "${!shadow_file[@]}" ; do printf '%s=%s\n' "$i" "${shadow_file[$i]}" ; done | sort)

# Defaults
$(for i in "${!defaults[@]}" ; do printf '%s=%s\n' "$i" "${defaults[$i]}" ; done | sort)

# Sync
$(for i in "${!sync[@]}" ; do printf '%s=%s\n' "$i" "${sync[$i]}" ; done | sort)

# Aliase
$(for i in "${!aliase[@]}" ; do printf '%s=%s\n' "$i" "${aliase[$i]}" ; done)

# Reports
$(for i in "${!reports[@]}" ; do printf '%s=%s\n' "$i" "${reports[$i]}" ; done | sort)

# Custom
$(for i in "${!customs[@]}" ; do printf '%s=%s\n' "$i" "${customs[$i]}" ; done | sort)
"
}
