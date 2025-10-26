# Automatic Backup Script

## Features
- Periodic backups using time intervals.
- Timestamped `.tar.gz` files.
- Keeps only a limited number of backups.

## Usage

Run backup:

```bash
make backup SOURCE_DIR=/home/student/data BACKUP_DIR=/home/student/backups INTERVAL=3600 BACKUP_COUNT=5
