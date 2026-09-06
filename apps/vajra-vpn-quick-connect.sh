#!/bin/bash
# Vajra OS VPN Quick Connect
set -e
echo "=== Vajra OS VPN Quick Connect ==="
echo "  1. Connect to WireGuard VPN (free)"
echo "  2. Connect to OpenVPN (free)"
echo "  3. Disconnect VPN"
echo "  4. VPN status"
echo "  5. Install WireGuard + OpenVPN"
echo "  6. Exit"
read -p "Choice: " choice
case "$choice" in
    1) read -p "Config file: " conf; wg-quick up "$conf" 2>/dev/null && echo "[+] VPN connected" ;;
    2) read -p "Config file: " conf; openvpn --config "$conf" 2>/dev/null & echo "[+] OpenVPN started" ;;
    3) wg-quick down all 2>/dev/null; killall openvpn 2>/dev/null; echo "[+] VPN disconnected" ;;
    4) wg show 2>/dev/null; ip link show tun0 2>/dev/null; echo "[+] Status checked" ;;
    5) apt-get install -y wireguard openvpn 2>/dev/null; echo "[+] VPN tools installed" ;;
    6) exit 0 ;;
esac