#!/bin/bash

COUNTER=1

for FILE in *.jpg; do
    NEW_NAME="image_$COUNTER.jpg"
    mv "$FILE" "$NEW_NAME"
    ((COUNTER++))
done

echo "Renamed all JPG files."

