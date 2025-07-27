#!/bin/bash

# Check for nethogs
if ! command -v nethogs &> /dev/null; then
    echo "❌ 'nethogs' is not installed. Install it with: sudo apt install nethogs"
    exit 1
fi

echo "🌐 Monitoring per-process network usage (MB/s). Press Ctrl+C to stop."
echo

# Run nethogs in text mode and parse output
sudo nethogs -t -d 1 | awk '
BEGIN {
    print "Timestamp       PID     Program        Sent(MB/s)    Received(MB/s)"
    print "---------------------------------------------------------------"
}
{
    split($1, time, ":")
    ts = strftime("%Y-%m-%d %H:%M:%S")

    # Format: <program>/<pid> <device> <sent> <received>
    split($1, proc, "/")
    pid = proc[2]
    prog = proc[1]

    sent = $3 / 1024       # KB to MB
    recv = $4 / 1024

    printf "%s  %-7s %-13s %-12.3f %-12.3f\n", ts, pid, prog, sent, recv
}'
