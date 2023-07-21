#!/bin/sh
# This script will create hourly backups by current day and overwritten old hourly backup from yesterday
# Place this under /etc/cron.hourly after edited
/backup_script/rsync-backup.sh <src> <dest> `date +today/%H`