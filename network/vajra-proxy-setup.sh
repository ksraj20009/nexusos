#!/bin/bash
# Vajra OS Proxy Setup
set -e
echo "=== Vajra OS Proxy Setup ==="
echo "  1. Set HTTP proxy"
echo "  2. Set HTTPS proxy"
echo "  3. Set SOCKS proxy"
echo "  4. Clear proxy"
echo "  5. Show current proxy"
echo "  6. Exit"
read -p "Choice: " choice
case "$choice" in
    1) read -p "Proxy (host:port): " p; export http_proxy="http://$p"; export HTTP_PROXY="http://$p"
       echo "[+] HTTP proxy set to http://$p" ;;
    2) read -p "Proxy (host:port): " p; export https_proxy="https://$p"; export HTTPS_PROXY="https://$p"
       echo "[+] HTTPS proxy set" ;;
    3) read -p "Proxy (host:port): " p; export ALL_PROXY="socks5://$p"
       echo "[+] SOCKS proxy set" ;;
    4) unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY
       echo "[+] Proxy cleared" ;;
    5) echo "http_proxy=$http_proxy"; echo "https_proxy=$https_proxy"; echo "ALL_PROXY=$ALL_PROXY" ;;
    6) exit 0 ;;
esac