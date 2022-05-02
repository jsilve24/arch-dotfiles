#!/bin/bash

secret=$(gpg --decrypt /home/jds6696/.bw_secret.gpg)
echo $secret | xargs xdotool type
