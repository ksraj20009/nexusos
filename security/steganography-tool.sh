#!/bin/bash
# Vajra OS Steganography Tool
# Hide and extract data in images
set -e
echo "=== Vajra OS Steganography Tool ==="
echo "  1. Hide data in image"
echo "  2. Extract data from image"
echo "  3. Install steghide"
echo "  4. Exit"
read -p "Choice: " choice
case "$choice" in
    1) read -p "Image file: " img; read -p "Data file: " data; read -rsp "Passphrase: " pass; echo ""
       steghide embed -cf "$img" -ef "$data" -p "$pass" -f 2>/dev/null && echo "[+] Data hidden in $img" || echo "[-] Failed" ;;
    2) read -p "Image file: " img; read -rsp "Passphrase: " pass; echo ""
       steghide extract -sf "$img" -p "$pass" -f 2>/dev/null && echo "[+] Data extracted" || echo "[-] Failed or wrong passphrase" ;;
    3) apt-get install -y steghide 2>/dev/null; echo "[+] steghide installed" ;;
    4) exit 0 ;;
esac