#!/bin/bash
# Vajra OS Firewall Configuration (UFW wrapper)
set -e
echo "=== Vajra OS Firewall Configuration ==="
echo "  1. Enable firewall"
echo "  2. Disable firewall"
echo "  3. Allow SSH"
echo "  4. Allow HTTP/HTTPS"
echo "  5. Allow specific port"
echo "  6. Deny specific port"
echo "  7. Show status"
echo "  8. Reset to defaults"
echo "  9. Exit"
read -p "Choice: " choice
case "$choice" in
    1) ufw enable; echo "[+] Firewall enabled" ;;
    2) ufw disable; echo "[+] Firewall disabled" ;;
    3) ufw allow ssh; echo "[+] SSH allowed" ;;
    4) ufw allow http; ufw allow https; echo "[+] HTTP/HTTPS allowed" ;;
    5) read -p "Port number: " port; ufw allow "$port"; echo "[+] Port $port allowed" ;;
    6) read -p "Port number: " port; ufw deny "$port"; echo "[+] Port $port denied" ;;
    7) ufw status verbose ;;
    8) ufw reset; echo "[+] Firewall reset" ;;
    9) exit 0 ;;
esac