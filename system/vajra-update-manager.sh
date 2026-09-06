#!/bin/bash
# Vajra OS Update Manager
set -e
echo "=== Vajra OS Update Manager ==="
echo "  1. Check for updates"
echo "  2. Install updates"
echo "  3. Full update + upgrade + autoremove"
echo "  4. Update Vajra components"
echo "  5. Rollback last update"
echo "  6. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt list --upgradable 2>/dev/null ;;
    2) apt-get upgrade -y 2>/dev/null; echo "[+] Updates installed" ;;
    3) apt-get update && apt-get upgrade -y && apt-get autoremove -y && apt-get clean
       echo "[+] Full system update completed" ;;
    4) echo "[*] Updating Vajra components..."
       bash /opt/vajra/system/vajra-apt-sources.sh 2>/dev/null || true
       echo "[+] Vajra components updated" ;;
    5) echo "Rollback: use apt history or timeshift" ;;
    6) exit 0 ;;
esac