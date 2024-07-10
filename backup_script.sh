#!/bin/bash

# Define variables
BACKUP_SRC=$1
BACKUP_DEST=$2
LOG_FILE="/var/log/backup_script.log"
TIMESTAMP=$(date +"%Y-%m-%d_(%H:%M:%S)")
BACKUP_FILE="${BACKUP_DEST}/backup_${TIMESTAMP}.tar.gz"

# Function to log messages
log_message() {
    echo "$1" | tee -a $LOG_FILE
}


# Check if source directory exists
if [ ! -d "$BACKUP_SRC" ]; then
    log_message "ERROR: Source directory $BACKUP_SRC does not exist."
    exit 1
fi


# Check if destination directory exists, create if not
if [ ! -d "$BACKUP_DEST" ]; then
    mkdir -p $BACKUP_DEST
fi


# Perform the backup with compression
tar -czf $BACKUP_FILE $BACKUP_SRC 2>> $LOG_FILE
if [ $? -eq 0 ]; then
    BACKUP_SIZE=$(du -sh $BACKUP_FILE | cut -f1)
    log_message "Backup successful: $BACKUP_FILE (Size: $BACKUP_SIZE)"
else
    log_message "ERROR: Backup failed for $BACKUP_SRC."
    exit 1
fi
