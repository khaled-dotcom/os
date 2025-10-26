# Makefile for running backup.sh

SOURCE_DIR ?= /home/student/data
BACKUP_DIR ?= /home/student/backups
INTERVAL ?= 3600      # in seconds
BACKUP_COUNT ?= 3

.PHONY: backup

backup:
	chmod +x backup.sh
	./backup.sh $(SOURCE_DIR) $(BACKUP_DIR) $(INTERVAL) $(BACKUP_COUNT)
