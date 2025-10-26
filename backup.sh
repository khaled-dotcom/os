#!/bin/bash

# backup.sh
# Usage: ./backup.sh <source_dir> <backup_dir> <interval_in_seconds> <backup_count>

SOURCE_DIR="$1"
BACKUP_DIR="$2"
INTERVAL="$3"
MAX_BACKUPS="$4"

# Check if all parameters are provided
if [ -z "$SOURCE_DIR" ] || [ -z "$BACKUP_DIR" ] || [ -z "$INTERVAL" ] || [ -z "$MAX_BACKUPS" ]; then
    echo "Usage: $0 <source_dir> <backup_dir> <interval_in_seconds> <backup_count>"
    exit 1
fi

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Start the backup loop
while true; do
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    BACKUP_NAME="backup_$TIMESTAMP.tar.gz"
    
    echo "Creating backup: $BACKUP_NAME"
    tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$SOURCE_DIR" .
    
    # Remove older backups if exceeding MAX_BACKUPS
    BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/backup_*.tar.gz 2>/dev/null | wc -l)
    if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
        OLDEST=$(ls -1t "$BACKUP_DIR"/backup_*.tar.gz | tail -n 1)
        echo "Removing old backup: $OLDEST"
        rm -f "$OLDEST"
    fi
    
    echo "Backup complete. Next backup in $INTERVAL seconds."
    sleep "$INTERVAL"
done
