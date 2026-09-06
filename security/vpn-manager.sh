#!/bin/bash
# Vajra OS VPN Manager (WireGuard/OpenVPN)
set -e
echo "=== Vajra OS VPN Manager ==="
echo "  1. Install WireGuard"
echo "  2. Install OpenVPN"
echo "  3. Configure WireGuard connection"
echo "  4. Configure OpenVPN connection"
echo "  5. Connect VPN"
echo "  6. Disconnect VPN"
echo "  7. Check VPN status"
echo "  8. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y wireguard wireguard-tools 2>/dev/null; echo "[+] WireGuard installed" ;;
    2) apt-get install -y openvpn 2>/dev/null; echo "[+] OpenVPN installed" ;;
    3) echo "Enter WireGuard config file path:"; read -r cfg; cp "$cfg" /etc/wireguard/wg0.conf; echo "[+] Config saved" ;;
    4) echo "Enter OpenVPN config file path:"; read -r cfg; cp "$cfg" /etc/openvpn/client.conf; echo "[+] Config saved" ;;
    5) echo "1. WireGuard  2. OpenVPN"; read -p "Type: " vpn
       if [ "$vpn" = "1" ]; then wg-quick up wg0 2>/dev/null && echo "[+] WireGuard connected"
       else systemctl start openvpn@client 2>/dev/null && echo "[+] OpenVPN connected"; fi ;;
    6) wg-quick down wg0 2>/dev/null; systemctl stop openvpn@client 2>/dev/null; echo "[+] VPN disconnected" ;;
    7) wg show 2>/dev/null; systemctl status openvpn@client 2>/dev/null; echo "" ;;
    8) exit 0 ;;
esac