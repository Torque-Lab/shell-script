#!/bin/bash

echo "🧠 Accurate Memory Map Report - Per Process (with Resident Memory)"
echo "Scanning all processes... (requires permission to read /proc/*)"
echo
printf "%-8s %-20s %-10s %-10s\n" "PID" "COMMAND" "MAP_MB" "RSS_MB"
echo "---------------------------------------------------------------"

for pid in $(ls /proc | grep -E '^[0-9]+$'); do
    map_file="/proc/$pid/maps"
    statm_file="/proc/$pid/statm"
    exe_cmd=$(ps -p "$pid" -o comm= 2>/dev/null)

    # Skip if not readable
    if [[ ! -r "$map_file" || ! -r "$statm_file" ]]; then
        continue
    fi

    ### ── Step 1: Calculate total mapped memory (virtual address space) ── ###
    total_kb=0
    while read -r line; do
        range=$(echo "$line" | awk '{print $1}')
        start_hex=$(echo "$range" | cut -d'-' -f1)
        end_hex=$(echo "$range" | cut -d'-' -f2)

        start_dec=$((0x$start_hex))
        end_dec=$((0x$end_hex))

        region_kb=$(( (end_dec - start_dec) / 1024 ))
        total_kb=$(( total_kb + region_kb ))
    done < "$map_file"

    map_mb=$(( total_kb / 1024 ))

    ### ── Step 2: Get RSS (resident memory) from statm ── ###
    rss_pages=$(awk '{print $2}' "$statm_file")
    rss_kb=$(( rss_pages * 4 ))  # assuming 4KB pages
    rss_mb=$(( rss_kb / 1024 ))

    ### ── Output ── ###
    printf "%-8s %-20s %-10s %-10s\n" "$pid" "$exe_cmd" "$map_mb" "$rss_mb"
done
