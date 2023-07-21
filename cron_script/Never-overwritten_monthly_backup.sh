#!/bin/sh
# Put me in cron.monthly, this will just keeps create backup every single month, and won't overwritten any backup being created
/backup_script/rsync-backup.sh <src> <dest> `date +%Y-%m-%d`