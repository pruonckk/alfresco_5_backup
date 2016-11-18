# This file should be used to define
# variables that should be used by the main script

BKP_DIR="/backup/data/"

RSYNC_HOST="192.168.1.50"
RSYNC_USER="backup"
RSYNC_SECRET_FILE="/backup/etc/rsync.secret"
RSYNC_REMOTE_MODULE="backup"
RSYNC_DB_FOLDER="bases"
RSYNC_GED_FOLDER="backup_files/data/ged"
RSYNC_DIFF_FOLDER="backup_files/diff/ged"
RSYNC_LOG="/tmp/rsync-log-`date +%Y.%m.%d`"

ALFRESCO_SCRIPT="/opt/alfresco-community/alfresco.sh"
PSQL_BIN="/opt/alfresco-community/postgresql/bin/psql"
PGDUMP_BIN="/opt/alfresco-community/postgresql/bin/pg_dump"
PG_DATABASE="alfresco"

# File to be used to check if the rsync is correctly configured
USB_CONTROL_FILE="control"


ALFRESCO_ROOT_DIR="/opt/alfresco-community/alf_data"
