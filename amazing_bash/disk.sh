#!/bin/bash

echo "📦 Disk usage in current directory:"
du -sh * 2>/dev/null | sort -hr | head -n 10


echo "📁 File types in current directory:"
find . -type f | sed -n 's/..*\.//p' | sort | uniq -c | sort -nr
