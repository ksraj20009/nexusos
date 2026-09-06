#!/bin/bash
# Vajra OS Fan Control
set -e
echo "=== Vajra OS Fan Control ==="
echo "  1. Auto fan control (recommended)"
echo "  2. Install fancontrol (free)"
echo "  3. Show fan speeds"
echo "  4. Exit"
read -p "Choice: " choice
case "$choice" in
    1) echo "[*] Enabling automatic fan control..."
       echo 0 > /sys/devices/virtual/thermal/thermal_zone0/mode 2>/dev/null || true
       systemctl enable fancontrol 2>/dev/null || true
       echo "[+] Auto fan control enabled" ;;
    2) apt-get install -y lm-sensors fancontrol 2>/dev/null
       sensors-detect --auto 2>/dev/null
       systemctl enable fancontrol 2>/dev/null
       echo "[+] fancontrol installed and configured" ;;
    3) sensors 2>/dev/null | grep -i fan || echo "No fan sensors found" ;;
    4) exit 0 ;;
esac