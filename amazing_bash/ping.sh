#!/bin/bash

SITE="google.com"
LOG="ping_log.txt"

echo "🌐 Pinging $SITE..."
ping -c 4 $SITE | grep 'time=' >> "$LOG"

echo "✅ Results saved to $LOG"
