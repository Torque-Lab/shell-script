#!/bin/bash

# Default root directory to scan
TARGET_DIR="${1:-/}"

echo "📦 Scanning disk usage for: $TARGET_DIR"
echo "This may take a while depending on size..."

echo
echo "==== 💽 DISK USAGE PER DIRECTORY (Top 50) ===="
# Show directory sizes in MB, sort by size, show top 50
du -BM -x "$TARGET_DIR" 2>/dev/null | sort -nr | head -n 50 | awk '{printf "%-8s %s\n", $1, $2}'

# echo
# echo "==== 📁 DISK USAGE PER FILE (Top 50 largest files) ===="
# # Find all files, print size + path, sort and display top 50
# find "$TARGET_DIR" -type f -exec du -BM {} + 2>/dev/null | sort -nr | head -n 50 | awk '{printf "%-8s %s\n", $1, $2}'

echo
echo "==== �� TOTAL DISK USAGE ===="
# Overall disk usage (used, free, total)
df -h "$TARGET_DIR" | awk 'NR==1 || NR==2 {print}'

echo
echo "✅ Done."
