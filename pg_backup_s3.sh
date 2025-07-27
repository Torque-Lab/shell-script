#!/bin/bash

# ========= Parameters =========
DB_NAME="$1"
DB_USER="$2"
S3_BUCKET="$3"
REGION="${4:-us-east-1}"  # Default region if not passed
TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
BACKUP_FILE="/tmp/${DB_NAME}_backup_${TIMESTAMP}.sql.gz"

# ========= Check Parameters =========
if [ -z "$DB_NAME" ] || [ -z "$DB_USER" ] || [ -z "$S3_BUCKET" ]; then
    echo "Usage: $0 <db_name> <db_user> <s3_bucket> [aws_region]"
    exit 1
fi

# ========= Run pg_dump =========
echo "Creating PostgreSQL backup..."
pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_FILE"

# Check if pg_dump succeeded
if [ $? -ne 0 ]; then
    echo " pg_dump failed. Aborting."
    exit 2
fi

# ========= Upload to S3 =========
echo "Uploading backup to S3..."
aws s3 cp "$BACKUP_FILE" "s3://$S3_BUCKET/" --region "$REGION"

# Check if upload succeeded
if [ $? -ne 0 ]; then
    echo " S3 upload failed."
    exit 3
fi

# ========= Cleanup =========
echo "Cleaning up local backup file..."
rm -f "$BACKUP_FILE"

echo " Backup complete: $BACKUP_FILE uploaded to s3://$S3_BUCKET/"
