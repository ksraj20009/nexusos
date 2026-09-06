#!/bin/bash
# Vajra OS Network Manager
set -e
echo "=== Vajra OS Network Manager ==="
echo "  1. Show connections"
echo "  2. Connect to Wi-Fi"
echo "  3. Disconnect"
echo "  4. Create hotspot"
echo "  5. Network diagnostics"
echo "  6. Show IP address"
echo "  7. DNS settings"
echo "  8. Exit"
read -p "Choice: " choice
case "$choice" in
    1) nmcli connection show ;;
    2) read -p "SSID: " ssid; read -rsp "Password: " pass; echo ""
       nmcli device wifi connect "$ssid" password "$pass" 2>/dev/null && echo "[+] Connected to $ssid" ;;
    3) nmcli device disconnect "$(nmcli -t -f DEVICE,STATE device | grep connected | head -1 | cut -d: -f1)" 2>/dev/null; echo "[+] Disconnected" ;;
    4) read -p "Hotspot name: " name; read -rsp "Password: " pass; echo ""
       nmcli device wifi hotspot ssid "$name" password "$pass" 2>/dev/null && echo "[+] Hotspot created: $name" ;;
    5) echo "Pinging Google..."; ping -c 4 google.com 2>/dev/null || echo "No internet"
       echo "DNS check..."; nslookup google.com 2>/dev/null || echo "DNS failed"
       echo "Gateway..."; ip route | grep default ;;
    6) ip addr show | grep "inet " ;;
    7) cat /etc/resolv.conf 2>/dev/null; echo ""; echo "Set DNS: sudo nano /etc/resolv.conf" ;;
    8) exit 0 ;;
esac