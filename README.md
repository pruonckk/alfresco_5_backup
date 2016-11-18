This is a simple script to backup Alfresco 5 community and copy the files
using rsync

# Prerequisites

* rsync
* bash

# Purpose

This project should be used on the alfresco installation, backuping the information
to a remote server using rsync 

The idea to implement this way is because we have not enough space on the server to performa 
the backup and sincronize that.

This way we copy the backup to the remote server as an image (a copy of the real state of those files) 
and do not need extra space on the alfresco server

# Postgres

The database backup is doing locally and copied after that, the idea is to maintain 3 days of backup on 
the alfresco server and use a second rotine to cleanup on the backup server 


