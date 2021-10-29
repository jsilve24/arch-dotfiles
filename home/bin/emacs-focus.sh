#!/usr/bin/env bash

# xdotool search --onlyvisible --classname "emacs" | head -1 && i3-msg "[class=Emacs] focus" || emacsclient -c
ID=$(xdotool search --onlyvisible --classname "emacs" | head -1)
if [ -n "$ID" ]
then
    echo $ID
    i3-msg "[id=${ID}] focus"
    emacsclient -e "(ace-window 'global)"
else
    emacsclient -c
fi
