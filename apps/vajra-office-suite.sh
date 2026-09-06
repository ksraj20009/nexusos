#!/bin/bash
# Vajra OS Office Suite Setup
set -e
echo "=== Vajra OS Office Suite ==="
echo "  1. Install LibreOffice (full, free)"
echo "  2. Install OnlyOffice (free)"
echo "  3. Install Calligra Suite (free)"
echo "  4. Open Writer"
echo "  5. Open Calc"
echo "  6. Open Impress"
echo "  7. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y libreoffice libreoffice-gnome 2>/dev/null; echo "[+] LibreOffice installed" ;;
    2) apt-get install -y onlyoffice-desktopeditors 2>/dev/null || snap install onlyoffice-desktopeditors 2>/dev/null; echo "[+] OnlyOffice installed" ;;
    3) apt-get install -y calligra 2>/dev/null; echo "[+] Calligra installed" ;;
    4) libreoffice --writer & ;;
    5) libreoffice --calc & ;;
    6) libreoffice --impress & ;;
    7) exit 0 ;;
esac