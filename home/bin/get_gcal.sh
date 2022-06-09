#!/bin/bash

# customize these
WGET=/usr/bin/wget
ICS2ORG=~/.local/bin/ical2orgpy
# ICS2ORG=~/bin/ical2org.awk	# 
ICSFILE=~/.cache/ical2org/gcal_cal.ics
ORGFILE=~/Dropbox/org/cal-gmail.org
URL=https://calendar.google.com/calendar/ical/jsilve24%40gmail.com/private-7fc1475a4519184d3a2b8a200b2121fd/basic.ics


# create cache folder if it doesn't exist already
mkdir -p /home/jds6696/.cache/ical2org/

# no customization needed below

$WGET -O $ICSFILE $URL
# $ICS2ORG < $ICSFILE > $ORGFILE
$ICS2ORG $ICSFILE $ORGFILE
rm -f $ICSFILE
