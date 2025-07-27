#!/bin/bash

# Ensure we run as root
# run like sudo ./v2p_dump.sh pid
if [[ $EUID -ne 0 ]]; then
    echo "❌ This script must be run as root." >&2
    exit 1
fi

# Validate input
if [[ -z "$1" ]]; then
    echo "Usage: $0 <PID>"
    exit 1
fi

PID=$1
MAPS_FILE="/proc/$PID/maps"
PAGEMAP_FILE="/proc/$PID/pagemap"
OUTPUT_FILE="${PID}_maping_table.txt"

if [[ ! -r "$MAPS_FILE" || ! -r "$PAGEMAP_FILE" ]]; then
    echo "❌ Cannot read /proc/$PID/maps or pagemap. Check permissions or PID."
    exit 1
fi

echo "🔍 Dumping virtual to physical memory map for PID $PID..."
echo "Output will be saved in $OUTPUT_FILE"
echo

PAGE_SIZE=$(getconf PAGE_SIZE)  # Usually 4096
PAGE_SHIFT=$(awk "BEGIN { print log($PAGE_SIZE)/log(2) }")

> "$OUTPUT_FILE"
printf "%-18s %-18s %-18s\n" "VIRTUAL_ADDR" "PFN" "PHYSICAL_ADDR" >> "$OUTPUT_FILE"
echo "---------------------------------------------------------------" >> "$OUTPUT_FILE"

# Read memory regions from maps
while read -r line; do
    ADDR_RANGE=$(echo "$line" | awk '{print $1}')
    START=$(echo "$ADDR_RANGE" | cut -d- -f1)
    END=$(echo "$ADDR_RANGE" | cut -d- -f2)

    START_DEC=$((0x$START))
    END_DEC=$((0x$END))

    for ((ADDR=START_DEC; ADDR<END_DEC; ADDR+=$PAGE_SIZE)); do
        # Calculate offset in pagemap (each entry is 8 bytes)
        OFFSET=$(( (ADDR / PAGE_SIZE) * 8 ))

        # Read 8 bytes (64 bits) at the offset
        DATA=$(dd if="$PAGEMAP_FILE" bs=1 skip=$OFFSET count=8 2>/dev/null | hexdump -e '1/8 "%016x"')

        if [[ -z "$DATA" ]]; then
            continue
        fi

        # Check if page is present
        PRESENT=$(( 0x${DATA} & (1 << 63) ))
        if [[ $PRESENT -ne 0 ]]; then
            PFN=$(( 0x${DATA} & ((1 << 55) - 1) ))
            PHYS_ADDR=$(( PFN * PAGE_SIZE ))
            printf "0x%-16x %-18d 0x%-16x\n" "$ADDR" "$PFN" "$PHYS_ADDR" >> "$OUTPUT_FILE"
        fi
    done


    echo "Testing memory region: $START - $END"
COUNT=0
for ((ADDR=START_DEC; ADDR<END_DEC; ADDR+=$PAGE_SIZE)); do
    OFFSET=$(( (ADDR / PAGE_SIZE) * 8 ))
    DATA=$(dd if="$PAGEMAP_FILE" bs=1 skip=$OFFSET count=8 2>/dev/null | hexdump -e '1/8 "%016x"')
    if [[ -z "$DATA" ]]; then continue; fi
    PRESENT=$(( 0x${DATA} & (1 << 63) ))
    if [[ $PRESENT -ne 0 ]]; then
        PFN=$(( 0x${DATA} & ((1 << 55) - 1) ))
        PHYS_ADDR=$(( PFN * PAGE_SIZE ))
        printf "0x%-16x %-18d 0x%-16x\n" "$ADDR" "$PFN" "$PHYS_ADDR" >> "$OUTPUT_FILE"
        ((COUNT++))
    fi
    [[ $COUNT -ge 10 ]] && break  # Just to limit output
done
done < "$MAPS_FILE"

echo "✅ Done. Output saved to $OUTPUT_FILE"
