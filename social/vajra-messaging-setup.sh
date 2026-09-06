#!/bin/bash
# Vajra OS Messaging Setup
set -e
echo "=== Vajra OS Messaging Setup ==="
echo "  1. Install Telegram (free)"
echo "  2. Install Signal (free, encrypted)"
echo "  3. WhatsApp Web (free, in browser)"
echo "  4. Install Discord (free)"
echo "  5. Exit"
read -p "Choice: " choice
case "$choice" in
    1) snap install telegram-desktop 2>/dev/null || apt-get install -y telegram-desktop 2>/dev/null; echo "[+] Telegram installed"; telegram-desktop & ;;
    2) snap install signal-desktop 2>/dev/null; echo "[+] Signal installed"; signal-desktop & ;;
    3) echo "WhatsApp: Use web.whatsapp.com in Firefox"
       xdg-open https://web.whatsapp.com 2>/dev/null ;;
    4) snap install discord 2>/dev/null; echo "[+] Discord installed"; discord & ;;
    5) exit 0 ;;
esac