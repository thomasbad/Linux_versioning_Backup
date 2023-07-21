#!/bin/sh
# Usage: rsync-backup.sh <src> <dst> <label>
# if there is less then 3 arguments being input to this script, tell user the error.
if [ "$#" -ne 3 ]; then
    echo "$0: Expected 3 arguments, received $#: $@" >&2
    exit 1
fi
#if there is a hardlink found in $2/__prev/, then use the hardlink for incoming backup, else, backup everything
if [ -d "$2/__prev/" ]; then
    rsync -a --delete --link-dest="$2/__prev/" "$1" "$2/$3"
else
    rsync -a                                   "$1" "$2/$3"
fi
#Remove previous hardlink
rm -f "$2/__prev"
#Create new softlink to new backup location 
ln -s "$3" "$2/__prev"