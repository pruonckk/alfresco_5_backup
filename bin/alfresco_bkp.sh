#!/bin/bash
#
# Script created by Mike Tesliuk ( pruonckk )


# Prevent script to run without a configuration file
if [ ! -e "../etc/CONFIG.sh" ]; then

	echo "[$(date "+%d.%m.%Y %H.%M.%S")]: Sorry, you have not read our README.md file, please, check your installation"
	exit 1

fi

source ../etc/CONFIG.sh

# Testing the RSYNC connectivity before starting the script

rsync -q --list-only --password-file=$RSYNC_SECRET_FILE $RSYNC_USER@$RSYNC_HOST::$RSYNC_REMOTE_MODULE/$USB_CONTROL_FILE

if [ "$?" -ne "0" ]; then
	echo "We cant contact the $RSYNC_USER@$RSYNC_HOST::$RSYNC_REMOTE_MODULE/$USB_CONTROL_FILE file, so we will not continue the backup operation"
	exit 1
fi




# We need to stop alfresco as recomended by the documentation

echo "[$(date "+%d.%m.%Y %H.%M.%S")]:  Stopping tomcat"

$ALFRESCO_SCRIPT stop tomcat


# Starting the Postgres backup

echo "[$(date "+%d.%m.%Y %H.%M.%S")]: Dumping the database"

$PGDUMP_BIN -U postgres -Fc $PG_DATABASE -f $BKP_DIR/$PG_DATABASE-`date +%Y.%m.%d`.dbc 

# Copying Postgresql Backup

echo "[$(date "+%d.%m.%Y %H.%M.%S")]: Start rsync copy to $RSYNC_REMOTE"

rsync -av --password-file=$RSYNC_SECRET_FILE --delete $BKP_DIR/ $RSYNC_USER@$RSYNC_HOST::$RSYNC_REMOTE_MODULE/$RSYNC_DB_FOLDER


#$ALFRESCO_SCRIPT stop postgres 
# BINARY: pg_dump -U postgres -Fc base -f base.dbc
# RESTORE: pg_dump -U postgres -v -Fc base -f base.dbc


# Starting rsync of ged

echo "[$(date "+%d.%m.%Y %H.%M.%S")]: rsync -av --password-file=$RSYNC_SECRET_FILE  $ALFRESCO_ROOT_DIR/* --backup-dir=$RSYNC_DIFF_FOLDER $RSYNC_USER@$RSYNC_HOST::$RSYNC_REMOTE_MODULE/$RSYNC_GED_FOLDER"

# TODO : check the way to do the diff on the remote server, below you have the entry with the backdir
# rsync -av --password-file=$RSYNC_SECRET_FILE  $ALFRESCO_ROOT_DIR/* --backup-dir=$RSYNC_DIFF_FOLDER $RSYNC_USER@$RSYNC_HOST::$RSYNC_REMOTE_MODULE/$RSYNC_GED_FOLDER

# Right now we are doing backups without the DIFF
rsync -av --password-file=$RSYNC_SECRET_FILE --delete  $ALFRESCO_ROOT_DIR/* $RSYNC_USER@$RSYNC_HOST::$RSYNC_REMOTE_MODULE/$RSYNC_GED_FOLDER

echo "[$(date "+%d.%m.%Y %H.%M.%S")]: Sarting tomcat"

$ALFRESCO_SCRIPT start tomcat

echo "[$(date "+%d.%m.%Y %H.%M.%S")]: Starting to cleanup the postgres backup"

if [ -d $BKP_DIR ]; then
	find $BKP_DIR/ -name "*.dbc" -ctime +$PG_MAX_DAYS -exec rm -vrf {} \; 
fi


echo "[$(date " +%d.%m.%Y %H:%M:%S")] No more task"

