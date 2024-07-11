#!/bin/bash

# Define variables
SOURCE_DIR="$1"
BACKUP_DIR="$2"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
LOG_FILE="/var/log/backup_script.log"

# Function to perform the backup
perform_backup() {
    local src=$1
    local dest=$2
    rsync -av --delete "$src" "$dest"
}

# Function to log messages
log_message() {
    echo "[$(date +"%Y-%m-%d (%H:%M:%S)")] $1" | tee -a "$LOG_FILE"
}

# Ensure backup directory exists
mkdir -p "$BACKUP_DIR"

log_message "Starting backup from $SOURCE_DIR to $BACKUP_DIR"

# Perform the backup in parallel for multiple source directories
for dir in $(find "$SOURCE_DIR" -maxdepth 1 -type d); do
    [ "$dir" = "$SOURCE_DIR" ] && continue  # Skip the root source directory itself
    perform_backup "$dir" "$BACKUP_DIR/$(basename "$dir")" &
done

# Wait for all background processes to complete
wait

log_message "Backup completed"

# Check backup size
BACKUP_SIZE=$(du -sh "$BACKUP_DIR" | cut -f1)
log_message "Backup size: $BACKUP_SIZE"







