#!/usr/bin/env bash

# Full backup to Meinecke (wrapper)

read -p "Is Meinecke ready?" answer
case $answer in
    Yes|yes|Y|y|ja|j)
            echo "Ok. Then go." 1>&2
            ;;
    No|no|N|n|nein)
            truecrypt-mount.sh || exit 1
            ;;
    *)
            echo "Hää?" 1>&2
            exit 2
            ;;
esac

{ printf -v horiz '%*s\n%s' "80" '' "HBLOCk" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
hblock-run.sh

{ printf -v horiz '%*s\n%s' "80" '' "VORBEREITUNGEN" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
backup-preparing.sh

{ printf -v horiz '%*s\n%s' "80" '' "BLEACHBIT" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
bleachbit.sh

{ printf -v horiz '%*s\n%s' "80" '' "OBNAM" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
obnam.sh

{ printf -v horiz '%*s\n%s' "80" '' "BUP" ; printf '%s\n' "${horiz// /-}" ; } 1>&2
#bup-weekly.sh

{ printf -v horiz '%*s\n%s' "80" '' "DONE." ; printf '%s\n' "${horiz// /-}" ; } 1>&2
exit 0
