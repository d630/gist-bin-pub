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

{ printf '%*s\n%s\n' "$(tput cols)" '' "VORBEREITUNGEN" | tr ' ' '-' ; } 1>&2
backup-preparing.sh

{ printf '%*s\n%s\n' "$(tput cols)" '' "BLEACHBIT" | tr ' ' '-' ; } 1>&2
bleachbit.sh

{ printf '%*s\n%s\n' "$(tput cols)" '' "OBNAM" | tr ' ' '-' ; } 1>&2
obnam.sh

#{ printf '%*s\n%s\n' "$(tput cols)" '' "BUP" | tr ' ' '-' ; } 1>&2
#bup-weekly.sh

{ printf '%*s\n%s\n' "$(tput cols)" '' "DONE."| tr ' ' '-' ; } 1>&2
exit 0
