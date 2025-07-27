#!/bin/bash

LOG_DIR=/home/mac-r/
ERROR_PATTERN=("ERROR","FATAL","CRITICAL")
echo "$LOG_DIR"
echo "List of log file update in 24 hour"
LOG_FILE=$(find $LOG_DIR -name "*.log" -mtime -1)

grep "${ERROR_PATTERN[0]}" sys.log
grep -c "${ERROR_PATTERN[1]}" sys.log
grep -c "${ERROR_PATTERN[2]}"L sys.log
grep "FAILED" backend.log

# it just file contain script which run by single command line by line

