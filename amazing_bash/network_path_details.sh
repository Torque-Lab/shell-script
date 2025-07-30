#!/bin/bash

DESTINATION="google.com"
LOGFILE="trace_protocol_info.txt"
TMP_TRACE="trace_tmp.txt"

echo "Tracing route to $DESTINATION..."
traceroute -n "$DESTINATION" > "$TMP_TRACE"

echo "[$(date)] Tracing BGP/NAT/Router info to $DESTINATION" > "$LOGFILE"
echo "" >> "$LOGFILE"

# Read IPs from traceroute output
cat "$TMP_TRACE" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | while read IP; do
    echo "Checking IP: $IP" >> "$LOGFILE"
    echo "-----------------------------------" >> "$LOGFILE"
    # whois lookup
    whois "$IP" | grep -E "origin|route|mntner|descr|OrgName|netname|country|AS" >> "$LOGFILE"
    echo "" >> "$LOGFILE"
done

echo "Trace complete. Results saved in $LOGFILE"
rm "$TMP_TRACE"

