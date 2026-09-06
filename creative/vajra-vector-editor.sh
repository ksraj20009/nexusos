#!/bin/bash
# Vajra OS Vector Editor Setup
set -e
echo "=== Vajra OS Vector Editor ==="
echo "  1. Install Inkscape"
echo "  2. Open Inkscape"
echo "  3. Convert SVG to PNG"
echo "  4. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y inkscape 2>/dev/null; echo "[+] Inkscape installed" ;;
    2) inkscape & ;;
    3) read -p "SVG file: " svg; read -p "Output PNG: " png
       inkscape "$svg" --export-type=png --export-filename="$png" 2>/dev/null && echo "[+] Converted" ;;
    4) exit 0 ;;
esac