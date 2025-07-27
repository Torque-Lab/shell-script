#!/bin/bash

echo "🧠 Watching Resourse hungery Process System Monitor Live... - Press Ctrl+C to stop"
echo "Updating every 100 seconds..."
echo
while true; do
    clear

    echo "==== 🧠 CPU & MEMORY SUMMARY ===="
    CPU_LINE=$(top -bn1 | grep "Cpu(s)")
    CPU_USER=$(echo "$CPU_LINE" | awk '{print $2}')
    CPU_SYSTEM=$(echo "$CPU_LINE" | awk '{print $4}')
    CPU_IDLE=$(echo "$CPU_LINE" | awk '{print $8}')
    echo "CPU Usage:"
    echo "  User:   $CPU_USER%"
    echo "  System: $CPU_SYSTEM%"
    echo "  Idle:   $CPU_IDLE%"

    # Get total memory in KB (convert to MB later)
    TOTAL_MEM_KB=$(free | awk '/Mem:/ {print $2}')
    TOTAL_MEM_MB=$((TOTAL_MEM_KB / 1024))
    USED_MEM_KB=$(free | awk '/Mem:/ {print $3}')
    USED_MEM_MB=$((USED_MEM_KB / 1024))
    echo "Memory Usage: ${USED_MEM_MB}MB / ${TOTAL_MEM_MB}MB"

    echo
    echo "==== 🔝 TOP 50 PROCESSES BY CPU ===="
    printf "%-6s %-10s %-6s %-10s %s\n" "PID" "USER" "CPU%" "MEM(MB)" "COMMAND"
    echo "--------------------------------------------------------------------------------"

    # Loop over top 50 processes sorted by CPU
    ps -eo pid,user,%cpu,%mem,command --sort=-%cpu | awk -v total_mem_kb="$TOTAL_MEM_KB" '
    NR>1 && NR<=51 {
        mem_mb = ($4 / 100) * total_mem_kb / 1024;
        printf "%-6s %-10s %-6s %-10.1f %s\n", $1, $2, $3, mem_mb, $5
    }'

    echo
    echo "==== 🔝 TOP 50 PROCESSES BY MEMORY ===="
    printf "%-6s %-10s %-6s %-10s %s\n" "PID" "USER" "CPU%" "MEM(MB)" "COMMAND"
    echo "--------------------------------------------------------------------------------"

    # Loop over top 50 processes sorted by MEM
    ps -eo pid,user,%cpu,%mem,command --sort=-%mem | awk -v total_mem_kb="$TOTAL_MEM_KB" '
    NR>1 && NR<=51 {
        mem_mb = ($4 / 100) * total_mem_kb / 1024;
        printf "%-6s %-10s %-6s %-10.1f %s\n", $1, $2, $3, mem_mb, $5
    }'

    echo
    echo "⌛ Updating in 100 seconds... (Ctrl+C to quit)"
    sleep 100
done
