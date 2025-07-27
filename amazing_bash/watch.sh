#!/bin/bash

echo "🧠 System Monitor - Press Ctrl+C to stop"
while true; do
    echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4"%"}')"
    echo "Memory: $(free -h | awk '/Mem:/ {print $3 "/" $2}')"
    echo "---------------------------"
    sleep 10
done
