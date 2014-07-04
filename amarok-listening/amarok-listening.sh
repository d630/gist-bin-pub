#!/usr/bin/env bash

# Amarok message about listening using qdbus.

# Lese qdbus und baue dessen relevanten Output zu normalen bash-Variablen um.
# Deklaration mittels eval.
while read -r var val
do
    [[ $var =~ (title:|artist:|location:) ]] &&
    {
        var=${var/:/}
        eval "${var/-/_}=\"${val}\""
    }
done < <(qdbus org.kde.amarok /Player org.freedesktop.MediaPlayer.GetMetadata 2>/dev/null)

[[ $artist || $location || $title ]] &&
{
    # Baue aus der Variable $location ein Array und gebe die letzten beiden Elemente aus, um $file und $dir zu bauen.
    IFS='/' read -r -a array <<< "$location"
    file=${array[-1]}
    dir=${array[-2]}
    # Ohne Array.
    #IFS='/' read -r _ _ _ _ _ _ _ _ _ _ dir file <<< "$location"

    # Die Variablen $artist und $title sind bereits deklariert worden.
    message="/me is listening now: \"${artist-unknown}\" - \"${title-unknown}\" from file \"${file-unknown}\" in dir \"${dir-unknown}\""
}

printf '%s\n' "${message-/me is listening silence now}"
