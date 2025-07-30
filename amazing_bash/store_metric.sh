#!/bin/bash

# Configuration
ENDPOINT_URL="http://google.com/metrics"
OUTPUT_FILE="/Desktop/metric/metrics_output.txt"  


TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

RESPONSE=$(curl -s "$ENDPOINT_URL")

# Check if the curl request succeeded
if [ $? -eq 0 ]; then
    echo "[$TIMESTAMP] Fetched metrics successfully" >> "$OUTPUT_FILE"
    echo "$RESPONSE" >> "$OUTPUT_FILE"
    echo "" >> "$OUTPUT_FILE"
else
    echo "[$TIMESTAMP] Failed to fetch metrics from $ENDPOINT_URL" >> "$OUTPUT_FILE"
fi

