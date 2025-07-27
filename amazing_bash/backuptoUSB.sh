#!/bin/bash

USB_PATH="/media/usb"
BACKUP_FILE="home_backup_$(date +'%Y-%m-%d').tar.gz"

if [ ! -d "$USB_PATH" ]; then
    echo " USB not mounted at $USB_PATH"
    exit 1
fi

echo " Backing up /home to $USB_PATH/$BACKUP_FILE"
tar -czf "$USB_PATH/$BACKUP_FILE" /home --exclude=/home/*/.cache

echo " Backup complete."
