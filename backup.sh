#!/bin/bash
SOURCE_DIR="$1"
DEST_DIR="$2"
TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')


echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "Total arguments: $#"
echo "All arguments: $@"

if [ -z "$SOURCE_DIR" ] || [ -z "$DEST_DIR" ]; then
    echo "Usage: $0 <source_dir> <dest_dir>"
    exit 1
fi


BACKUP_NAME="backup_$TIMESTAMP.tar.gz"
tar -czf "$DEST_DIR/$BACKUP_NAME" -C "$SOURCE_DIR" .

echo "Backup of $SOURCE_DIR completed at $DEST_DIR/$BACKUP_NAME"
