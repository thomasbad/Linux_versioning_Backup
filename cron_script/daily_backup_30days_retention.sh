#!/bin/sh
# This script will create daily backups everyday and overwritten new file to old one after 30 days
# Place this under /etc/cron.daily after edited
/backup_script/rsync-backup.sh <src> <dest> `date +Day-%d`