#!/bin/bash
TMP_PATH="/tmp/current_bg"
MAX=`ls ~/.config/hypr/wallpapers | wc -l`

if test -f "$TMP_PATH"; then
    echo "$TMP_PATH exists"
else
    echo 1 > $TMP_PATH
fi

VALUE=`cat $TMP_PATH`

echo "Current BG: $VALUE Max: $MAX"

if [ $VALUE -ge $MAX ]
then
    echo 1 > $TMP_PATH
    else
    expr $VALUE + 1 > $TMP_PATH
fi
hyprctl hyprpaper wallpaper eDP-1,~/.config/hypr/wallpapers/$VALUE.jpg

