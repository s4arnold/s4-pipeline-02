#!/bin/bash


# AWS CLI Configuration
AWS_PROFILE="your_aws_cli_profile"
S3_BUCKET="s4-bucket-arnold"

# Backup Settings
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
BACKUP_FILE="${DB_NAME}_backup_${TIMESTAMP}.sql"

# Create .pgpass file
echo "$DB_HOST:$DB_PORT:$DB_NAME:$DB_USER:$DB_PASSWORD" > "$PGPASS_FILE"
chmod 600 "$PGPASS_FILE"

# Perform database backup
PGPASSFILE="$PGPASS_FILE" pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" > "$BACKUP_FILE"

# Remove .pgpass file
rm -f "$PGPASS_FILE"

# Check the exit status of pg_dump
if [ $? -eq 0 ]; then
    echo "Backup completed successfully. Backup file: $BACKUP_FILE"

    # Upload backup file to S3
    aws s3 cp "$BACKUP_FILE" "s3://$S3_BUCKET/"

    # Check the exit status of aws s3 cp
    if [ $? -eq 0 ]; then
        echo "Backup file uploaded to S3 successfully."
    else
        echo "Failed to upload backup file to S3. Check the error message above for details."
    fi
else
    echo "Backup failed. Check the error message above for details."
fi
