#!/bin/bash

LOG_DIR="/home/mac-r/"
ERROR_PATTERN=("ERROR" "FATAL" "CRITICAL" "FAILED")
REPORT_FILE="/home/mac-r/Desktop/log_report/log.txt"

# Start report
echo "$LOG_DIR" >> "$REPORT_FILE"
echo "List of log files updated in last 24 hours:" >> "$REPORT_FILE"

# Find log files modified in the last 24 hours
LOG_FILES=$(find "$LOG_DIR" -name "*.log" -mtime -1)

for LOG_FILE in $LOG_FILES; do
    echo -e "\n======= ${LOG_FILE} =======" >> "$REPORT_FILE"
    echo "=============================" >> "$REPORT_FILE"

    for PATTERN in "${ERROR_PATTERN[@]}"; do
        echo -e "\nSearching for '$PATTERN' in $LOG_FILE" >> "$REPORT_FILE"
        grep "$PATTERN" "$LOG_FILE" >> "$REPORT_FILE"
        echo -e "\nNumber of '$PATTERN' entries in $LOG_FILE:" >> "$REPORT_FILE"
        ERROR_COUNT=$(grep -c "$PATTERN" "$LOG_FILE" >> "$REPORT_FILE")
        if ["$ERROR_COUNT" -gt 10];then
            echo " !!!!Action required to many error"
        fi
    done
done
echo -e "\nLog analysis completed." >> "$REPORT_FILE"
