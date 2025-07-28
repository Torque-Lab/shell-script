#!/bin/bash

LOG_DIR="/var/log/system"
DAYS=7

find "$LOG_DIR" -name "*.log" -type f -mtime +$DAYS -exec rm {} \;

echo "Deleted log files older than $DAYS days from $LOG_DIR"

