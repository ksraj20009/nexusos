#!/bin/bash
# Vajra OS Honeypot - Detect and trap attackers (free, open source)
set -e
echo "=== Vajra OS Honeypot ==="
echo "WARNING: Only run on systems you own. This is for detection."
echo ""
echo "  1. Install Cowrie (SSH honeypot, free)"
echo "  2. Start honeypot"
echo "  3. View honeypot logs"
echo "  4. Stop honeypot"
echo "  5. Exit"
read -p "Choice: " choice
case "$choice" in
    1) echo "[*] Installing Cowrie..."
       apt-get install -y python3-virtualenv 2>/dev/null
       echo "[+] Install Cowrie from: https://github.com/cowrie/cowrie"
       echo "[+] This is a detection tool - attracts attackers to a fake SSH" ;;
    2) echo "[*] Start Cowrie manually after installation" ;;
    3) tail -f /opt/cowrie/var/log/cowrie/cowrie.log 2>/dev/null || echo "No honeypot logs" ;;
    4) pkill -f cowrie 2>/dev/null; echo "[+] Honeypot stopped" ;;
    5) exit 0 ;;
esac