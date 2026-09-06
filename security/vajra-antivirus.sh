#!/bin/bash
# Vajra OS Antivirus (ClamAV - free, open source)
set -e
echo "=== Vajra OS Antivirus (ClamAV) ==="
echo "  1. Install ClamAV (free)"
echo "  2. Update virus database"
echo "  3. Scan directory"
echo "  4. Quick scan (home)"
echo "  5. Full system scan"
echo "  6. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y clamav clamtk 2>/dev/null; echo "[+] ClamAV installed" ;;
    2) freshclam 2>/dev/null; echo "[+] Virus database updated" ;;
    3) read -p "Directory to scan: " dir; clamscan -r "$dir" 2>/dev/null; echo "[+] Scan complete" ;;
    4) clamscan -r "$HOME" --max-filesize=100M 2>/dev/null; echo "[+] Home scan complete" ;;
    5) clamscan -r / --max-filesize=100M --exclude-dir="/proc|/sys|/dev" 2>/dev/null; echo "[+] Full scan complete" ;;
    6) exit 0 ;;
esac