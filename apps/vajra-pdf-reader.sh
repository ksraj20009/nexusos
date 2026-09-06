#!/bin/bash
# Vajra OS PDF Reader Setup
set -e
echo "=== Vajra OS PDF Reader ==="
echo "  1. Install Evince (GNOME PDF reader)"
echo "  2. Install Okular (KDE PDF reader)"
echo "  3. Install Zathura (minimal)"
echo "  4. Open PDF file"
echo "  5. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y evince 2>/dev/null; echo "[+] Evince installed" ;;
    2) apt-get install -y okular 2>/dev/null; echo "[+] Okular installed" ;;
    3) apt-get install -y zathura 2>/dev/null; echo "[+] Zathura installed" ;;
    4) read -p "PDF file path: " pdf; evince "$pdf" 2>/dev/null || okular "$pdf" 2>/dev/null || zathura "$pdf" 2>/dev/null || echo "No PDF reader installed" ;;
    5) exit 0 ;;
esac