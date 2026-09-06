#!/bin/bash
# Vajra OS Screenshot Tool
set -e
DIR="${HOME}/Pictures/Screenshots"
mkdir -p "$DIR"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
FILE="$DIR/vajra-screenshot-$TIMESTAMP.png"
echo "=== Vajra OS Screenshot Tool ==="
echo "  1. Full screen"
echo "  2. Active window"
echo "  3. Selected area"
echo "  4. Delayed (5s)"
read -p "Choice: " choice
case "$choice" in
    1) gnome-screenshot -f "$FILE" 2>/dev/null || scrot "$FILE" 2>/dev/null || import -window root "$FILE" ;;
    2) gnome-screenshot -w -f "$FILE" 2>/dev/null || scrot -u "$FILE" 2>/dev/null ;;
    3) gnome-screenshot -a -f "$FILE" 2>/dev/null || scrot -s "$FILE" 2>/dev/null ;;
    4) sleep 5; gnome-screenshot -f "$FILE" 2>/dev/null || scrot "$FILE" 2>/dev/null ;;
esac
if [ -f "$FILE" ]; then
    echo "[+] Screenshot saved: $FILE"
    xdg-open "$FILE" 2>/dev/null &
else
    echo "[-] Screenshot failed"
fi