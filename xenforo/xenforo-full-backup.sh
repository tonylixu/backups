#!/bin/bash
UNAME=''
PASSWD=''
MYSQL_BACKUP_PATH=''
DATA_BACKUP_PATH=''
DATE=`date +%Y-%m-%d`
echo "Backing up MYSQL database..."
echo "mysqldump --opt -uUNAME -pPASSWD xenforo > $MYSQL_BACKUP_PATH/xenforo-$DATE.sql"
mysqldump --opt -u$UNAME -p$PASSWD xenforo > $MYSQL_BACKUP_PATH/xenforo$DATE.sql

echo "Backing up files..."
echo "tar -czphf $DATA_BACKUP_PATH/xenforo-$DATE.tar.gz /var/www/xenforo"
tar -czphf $DATA_BACKUP_PATH/xenforo-$DATE.tar.gz /var/www/xenforo
