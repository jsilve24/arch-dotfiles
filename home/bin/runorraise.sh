#!/bin/bash

cmd="$1"
class="$2"
pgrepcmd=${3:-$cmd}
pgrep -f $pgrepcmd && i3-msg "[class=${class}] focus" || $cmd
