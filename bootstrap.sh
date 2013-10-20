#!/bin/bash
# Update chef to a specific version
gem install chef --version 11.4.0 --no-rdoc --no-ri --conservative

# Backup databases
######TO BE MODIFIED#####

### System Setup ###
BACKUP='/vagrant/backups'

### MySQL Setup ###
MUSER="root"
MPASS="worschdsalat"
MHOST="localhost"

######DO NOT MAKE MODIFICATION BELOW#####
#########################################

### Binaries ###
TAR="$(which tar)"
GZIP="$(which gzip)"
FTP="$(which ftp)"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"

### Today + hour in 24h format ###
NOW=$(date +"%d-%m-%y-%H-%M")

### Create hourly dir ###

mkdir -p $BACKUP/$NOW

### Get all databases name ###
DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
for db in $DBS
do

### Create dir for each databases, backup tables in individual files ###
  mkdir $BACKUP/$NOW/$db

  for i in `echo "show tables" | $MYSQL -u $MUSER -h $MHOST -p$MPASS $db|grep -v Tables_in_`;
  do
    FILE=$BACKUP/$NOW/$db/$i.sql.gz
    echo $i; $MYSQLDUMP --add-drop-table --allow-keywords -q -c -u $MUSER -h $MHOST -p$MPASS $db $i | $GZIP -9 > $FILE
  done
done

### Compress all tables in one nice file to upload ###

ARCHIVE=$BACKUP/$NOW.tar.gz
ARCHIVED=$BACKUP/$NOW

$TAR -cvf $ARCHIVE $ARCHIVED

### Delete the backup dir and keep archive ###

rm -rf $ARCHIVED
