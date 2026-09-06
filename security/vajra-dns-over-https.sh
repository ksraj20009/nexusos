#!/bin/bash
# Vajra OS DNS-over-HTTPS Setup (free, privacy)
set -e
echo "=== Vajra OS DNS-over-HTTPS ==="
echo "  1. Configure Firefox DoH (built-in, free)"
echo "  2. Configure system DoH (dnscrypt-proxy, free)"
echo "  3. Set Cloudflare DNS (1.1.1.1)"
echo "  4. Set Google DNS (8.8.8.8)"
echo "  5. Reset DNS"
echo "  6. Exit"
read -p "Choice: " choice
case "$choice" in
    1) echo "  Firefox > Settings > Privacy > DNS over HTTPS > Enable"
       echo "  Choose: Cloudflare or NextDNS"
       echo "[+] Firefox DoH instructions shown" ;;
    2) apt-get install -y dnscrypt-proxy 2>/dev/null
       systemctl enable dnscrypt-proxy 2>/dev/null
       systemctl start dnscrypt-proxy 2>/dev/null
       echo "[+] dnscrypt-proxy installed (encrypted DNS)" ;;
    3) echo "nameserver 1.1.1.1" > /etc/resolv.conf
       echo "nameserver 1.0.0.1" >> /etc/resolv.conf
       echo "[+] Cloudflare DNS set" ;;
    4) echo "nameserver 8.8.8.8" > /etc/resolv.conf
       echo "nameserver 8.8.4.4" >> /etc/resolv.conf
       echo "[+] Google DNS set" ;;
    5) echo "nameserver 127.0.0.1" > /etc/resolv.conf
       echo "[+] DNS reset to default" ;;
    6) exit 0 ;;
esac