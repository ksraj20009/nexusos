#!/bin/bash
# Vajra OS Service Manager (systemd wrapper)
set -e
echo "=== Vajra OS Service Manager ==="
echo "  1. List all services"
echo "  2. Start service"
echo "  3. Stop service"
echo "  4. Restart service"
echo "  5. Enable service (boot)"
echo "  6. Disable service"
echo "  7. Service status"
echo "  8. Exit"
read -p "Choice: " choice
case "$choice" in
    1) systemctl list-units --type=service --state=running ;;
    2) read -p "Service: " s; systemctl start "$s" && echo "[+] Started $s" ;;
    3) read -p "Service: " s; systemctl stop "$s" && echo "[+] Stopped $s" ;;
    4) read -p "Service: " s; systemctl restart "$s" && echo "[+] Restarted $s" ;;
    5) read -p "Service: " s; systemctl enable "$s" && echo "[+] Enabled $s" ;;
    6) read -p "Service: " s; systemctl disable "$s" && echo "[+] Disabled $s" ;;
    7) read -p "Service: " s; systemctl status "$s" ;;
    8) exit 0 ;;
esac