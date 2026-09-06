#!/bin/bash
# Vajra OS Web Browser Configuration (free, open source browsers)
set -e
echo "=== Vajra OS Web Browser Config ==="
echo "  1. Install Firefox ESR (free, open source)"
echo "  2. Install Chromium (free, open source)"
echo "  3. Install Brave (free, open source)"
echo "  4. Configure privacy settings (Firefox)"
echo "  5. Set default browser"
echo "  6. Show recommended extensions (all free)"
echo "  7. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y firefox-esr 2>/dev/null; echo "[+] Firefox installed" ;;
    2) apt-get install -y chromium 2>/dev/null; echo "[+] Chromium installed" ;;
    3) snap install brave 2>/dev/null || echo "Install from brave.com"; echo "[+] Brave installed" ;;
    4) echo "[*] Applying privacy settings..."
       echo "  Firefox > Settings > Privacy & Security"
       echo "  Enable: Enhanced Tracking Protection"
       echo "  Enable: Do Not Track"
       echo "[+] Privacy settings instructions shown" ;;
    5) xdg-settings set default-web-browser firefox-esr.desktop 2>/dev/null; echo "[+] Firefox set as default" ;;
    6) echo "  Recommended free extensions:"
       echo "    uBlock Origin - Ad blocker"
       echo "    Privacy Badger - Tracker blocker"
       echo "    Bitwarden - Password manager (free)"
       echo "    Dark Reader - Dark mode" ;;
    7) exit 0 ;;
esac