#!/bin/bash

# customize these
WGET=/usr/bin/wget
ICS2ORG=~/bin/ical2org.awk
ICSFILE=~/.cache/ical2org/psu_cal.ics
ORGFILE=~/Dropbox/org/exclude-beorg/cal-psu.org
URL=https://outlook.office365.com/owa/calendar/83f9d82ee6474d86a4cf8d54b63a4d8f@psu.edu/14f437ce04884f40b18347008af154563232586173734917328/calendar.ics 

# no customization needed below

$WGET -O $ICSFILE $URL
$ICS2ORG < $ICSFILE > $ORGFILE
