#!/bin/bash

secret=$(gpg --decrypt /home/jds6696/.bw_secret.gpg)
# secret=$(echo $secret | sed 's/./& /g')
# secret=$(echo $secret | sed 's/!/Shift+1/g')
# secret=$(echo $secret | sed 's/@/Shift+2/g')
# secret=$(echo $secret | sed 's/!/Shift+3/g')
# secret=$(echo $secret | sed 's/\$/Shift+4/g')
# secret=$(echo $secret | sed 's/%/Shift+5/g')
# secret=$(echo $secret | sed 's/\^/Shift+6/g')
# secret=$(echo $secret | sed 's/&/Shift+7/g')
# secret=$(echo $secret | sed 's/\*/Shift+8/g')
# secret=$(echo $secret | sed 's/(/Shift+9/g')
# secret=$(echo $secret | sed 's/)/Shift+0/g')
# echo $secret | xargs xdotool key
echo $secret | xargs xdotool type
