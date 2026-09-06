#!/bin/bash
# Vajra OS Torrent Client Setup
set -e
echo "=== Vajra OS Torrent Client ==="
echo "  1. Install Transmission (lightweight, free)"
echo "  2. Install qBittorrent (full-featured, free)"
echo "  3. Open torrent file"
echo "  4. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y transmission-gtk 2>/dev/null; echo "[+] Transmission installed"; transmission-gtk & ;;
    2) apt-get install -y qbittorrent 2>/dev/null; echo "[+] qBittorrent installed"; qbittorrent & ;;
    3) read -p "Torrent file: " tf; xdg-open "$tf" 2>/dev/null || transmission-gtk "$tf" 2>/dev/null ;;
    4) exit 0 ;;
esac