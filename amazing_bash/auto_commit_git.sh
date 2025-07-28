#!/bin/bash
# export PATH=$PATH:/new/path   to add any path in env
cd ~/Desktops/alogritms

git add .
git commit -m "Auto commit on $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main

echo "Changes pushed to GitHub!"

