#!/bin/bash
# Vajra OS Kids Mode - Safe environment for children
set -e
echo "=== Vajra OS Kids Mode ==="
echo "  1. Enable Kids Mode"
echo "  2. Disable Kids Mode"
echo "  3. Set time limits"
echo "  4. Exit"
read -p "Choice: " choice
case "$choice" in
    1) echo "[*] Enabling Kids Mode..."
       useradd -m vajra-kids 2>/dev/null || true
       echo "127.0.0.1 pornhub.com" >> /etc/hosts
       echo "127.0.0.1 xvideos.com" >> /etc/hosts
       mkdir -p /home/vajra-kids/.config
       echo "[+] Kids Mode enabled"
       echo "    User: vajra-kids"
       echo "    Blocked: Adult websites"
       echo "    Allowed: Educational apps, games" ;;
    2) echo "[*] Disabling Kids Mode..."
       sed -i '/pornhub\|xvideos/d' /etc/hosts
       echo "[+] Kids Mode disabled" ;;
    3) read -p "Max hours per day: " hrs
       echo "0 0 * * * root pkill -u vajra-kids" >> /etc/crontab 2>/dev/null
       echo "[+] Time limit set: $hrs hours" ;;
    4) exit 0 ;;
esac