#!/bin/bash
#
# Script created by Mike Tesliuk ( pruonckk )


# Prevent script to run without a configuration file
if [ ! -e "../etc/CONFIG.sh" ]; then

	echo "Sorry, you have not read our README.md file, please, check your installation"
	exit 1

fi

source ../etc/CONFIG.sh


# We need to stop alfresco as recomended by the documentation

$ALFRESCO_SCRIPT stop tomcat


# Starting the Postgres backup

$PGDUMP_BIN -U postgres -Fc $PG_DATABASE -f $BKP_DIR/$PG_DATABASE-`date +%Y.%m.%d``   

# Copying Postgresql Backup

rsync -av --password-file=$RSYNC_SECRET_FILE  $BKP_DIR/* $RSYNC_USER@$RSYNC_HOST::$RSYNC_REMOTE_MODULE/$RSYNC_DB_FOLDER


#$ALFRESCO_SCRIPT stop postgres 
# BINARY: pg_dump -U postgres -Fc base -f base.dbc
# RESTORE: pg_dump -U postgres -v -Fc base -f base.dbc


