#!/bin/bash

DESTINATION="google.com"

LOGFILE="trace_output.txt"

TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "[$TIMESTAMP] Tracing route to $DESTINATION..."


traceroute "$DESTINATION" > "$LOGFILE"

echo "Trace complete. Results saved in $LOGFILE"

