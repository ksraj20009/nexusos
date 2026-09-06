#!/bin/bash
# Vajra OS Advanced Firewall (iptables + UFW, free, built-in)
set -e
echo "=== Vajra OS Advanced Firewall ==="
echo "  1. Enable stealth mode (drop pings)"
echo "  2. Block specific IP"
echo "  3. Rate limit SSH (prevent brute force)"
echo "  4. Enable port knocking"
echo "  5. Show iptables rules"
echo "  6. Reset to defaults"
echo "  7. Exit"
read -p "Choice: " choice
case "$choice" in
    1) iptables -A INPUT -p icmp --icmp-type echo-request -j DROP 2>/dev/null
       echo "[+] Stealth mode: pings dropped" ;;
    2) read -p "IP to block: " ip; iptables -A INPUT -s "$ip" -j DROP 2>/dev/null
       echo "[+] Blocked $ip" ;;
    3) iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set 2>/dev/null
       iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 4 -j DROP 2>/dev/null
       echo "[+] SSH rate limited: max 3 attempts per minute" ;;
    4) echo "Port knocking: Use knockd package for advanced setup" ;;
    5) iptables -L -n -v 2>/dev/null | head -30 ;;
    6) ufw reset 2>/dev/null; echo "[+] Firewall reset" ;;
    7) exit 0 ;;
esac