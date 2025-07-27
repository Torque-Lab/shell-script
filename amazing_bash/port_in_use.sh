#!/bin/bash

echo "🌐 Listing all currently used network ports with associated PIDs and processes..."
echo


printf "%-7s %-10s %10s %6s %-10s %-s\n" "Protocol" "Local_IP" "Port" "PID" "Process" "URL/Remote_Host"
echo "---------------------------------------------------------------------------------------------"

# Use ss or netstat if available
if command -v ss &>/dev/null; then
    # Using ss (more modern than netstat)
    ss -tulnp | tail -n +2 | while read -r line; do
        proto=$(echo "$line" | awk '{print $1}')
        local_addr=$(echo "$line" | awk '{print $5}')
        pid_proc=$(echo "$line" | awk -F 'users:' '{print $2}' | grep -oP 'pid=\K[0-9]+(?=,)|"\K[^"]+')

        ip=$(echo "$local_addr" | cut -d: -f1)
        port=$(echo "$local_addr" | rev | cut -d: -f1 | rev)

        pid=$(echo "$pid_proc" | sed -n '1p')
        proc=$(echo "$pid_proc" | sed -n '2p')

        # Get reverse DNS if remote is included (only TCP)
        remote=""
        if [[ "$proto" == "tcp" || "$proto" == "tcp6" ]]; then
            remote_host=$(echo "$line" | awk '{print $6}' | cut -d: -f1)
            if [[ "$remote_host" != "*" && "$remote_host" != "0.0.0.0" ]]; then
                remote=$(host "$remote_host" 2>/dev/null | awk '/domain name pointer/ {print $5}' | sed 's/\.$//')
            fi
        fi

        printf "%-7s %-10s %10s %6s %-10s %-s\n" "$proto" "$ip" "$port" "$pid" "$proc" "${remote:-N/A}"
    done

else
    echo "❌ 'ss' command not found. Please install 'iproute2' package or use netstat-based version."
    exit 1
fi
