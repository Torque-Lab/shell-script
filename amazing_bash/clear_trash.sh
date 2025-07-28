#!/bin/bash

TRASH="$HOME/.local/share/Trash"

rm -rf "$TRASH/files/"*
rm -rf "$TRASH/info/"*

echo "Trash emptied!"

