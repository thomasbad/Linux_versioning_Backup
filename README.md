# Linux_versioning_Backup
Backup stuff in versioning / file retention by using rsync in Linux

## What is this?
This is a bundle of backup script, try to make use of rsync without bunch of google-ing, and try to do the backup by:
1. Ensure the backup is being save in the date/time format
2. Backup the file in hardlink instead, try to save the space as much as it can

*hardlink means the file is being save into the harddisk "directly" instead. 
If it is the same content, every file you've created is actually just a "shortcut" pointed to a specific harddisk location.
Unless you removed every hardlink, the file will be still exist on the harddisk.
(For the shortcut type link Windows one, it is called softlink in Linux)*

## How to use them?
The detail of each script usage have been comment in the script. 
The main script (**main_backup.sh**) are default assume you are putting in the **/backup_script**.
<src> means the backup source
<dest> means the location you want to backup to
Just edit this path/location stuff in the script will simply make it work.

For example, if you want to backup **/home** to **/backup** by 7 days retention, then you should use **daily_backup_7days_retention.sh** in the cron_script folder, 
edit it look like this before put it in the **/etc/cron.daily** :

```
#!/bin/sh
# This script will create daily backups everyday and overwritten after 7 days
/backup_script/rsync-backup.sh /home /backup `date +%A`
```
**Make sure all the scripts' access right are for root only with rwxrxrx right, to ensure the script have run access and correct edit right by security reasons.**
For example, for main_backup.sh:
```
sudo chown root:root main_backup.sh && sudo chmod 755 main_backup.sh
```
Simple

## Will this waste a lot of harddisk space?
No, this script backup stuff in hardlink, or you may call it backup thing by comparing differences.

## Damn, I want to use it all, by doing the backup in Monthly, daily and hourly together.
For some of the case, this kind of backup is commonly seen in the server side, like Veeam Backup also try to provide this kind of backup retention policy when you create the backup job.
Although the script already try to save the space by hardlink stuff, because it won't copy every files. But using all these script together will create bunch of directories and bunch of hardlink, which is hard to maintain and still some extra backup may create (For example, at 1-Dec, you will have a monthly backup, a daily backup and hourly backup in the same hour around 4:00am, 3 duplicated copies.).

As the magic is all stored in **main_backup.sh** (Actually you can create any backup policy by make use of it, syntax is: 
```
rsync-backup.sh <src> <dst> <label>
```
), it would be much better to just simply use /etc/cron.d or crontab in below format alike:
```
# First day of month -> persistent
7 23   1    * * rsync-backup.sh /home /backup `date +\%Y-\%m-\%d`
# Other days of month -> recycled next month
7 23   2-31 * * rsync-backup.sh /home /backup `date +thismonth/\%d`
# Other hours of day -> recycled next day
7 0-22 *    * * rsync-backup.sh /home /backup `date +today/\%H`
```
Please note for the extra backslashes before the percent signs, as cron will change unescaped percent signs to newlines, that must not be removed.
Which means: 
Every first day of the month at 23:07, it will first backup once and this backup will not be remove.
Then, after the first day, it will still backup everyday, and will overwrite the old one after a month.
Finally, it will backup every hour from 00:07 to 22:07, and overwrite the old one after 24 hours. Where is the 23:07 backup? You've already got it in daily backup!

## I still don't know what you means
Please do Google "how to use crontab" and "linux how to change file access right"
