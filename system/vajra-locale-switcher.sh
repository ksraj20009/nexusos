#!/bin/bash
# Vajra OS Locale Switcher (free, built-in)
set -e
echo "=== Vajra OS Locale Switcher ==="
echo "  Available locales:"
locale -a 2>/dev/null | head -20
echo ""
echo "  1. Set to English (India)"
echo "  2. Set to Hindi"
echo "  3. Set to Tamil"
echo "  4. Set to Bengali"
echo "  5. Set custom locale"
echo "  6. Exit"
read -p "Choice: " choice
case "$choice" in
    1) update-locale LANG=en_IN.UTF-8; echo "[+] Set to English (India)" ;;
    2) sed -i 's/# hi_IN.UTF-8 UTF-8/hi_IN.UTF-8 UTF-8/' /etc/locale.gen; locale-gen; update-locale LANG=hi_IN.UTF-8; echo "[+] Set to Hindi" ;;
    3) sed -i 's/# ta_IN.UTF-8 UTF-8/ta_IN.UTF-8 UTF-8/' /etc/locale.gen; locale-gen; update-locale LANG=ta_IN.UTF-8; echo "[+] Set to Tamil" ;;
    4) sed -i 's/# bn_IN.UTF-8 UTF-8/bn_IN.UTF-8 UTF-8/' /etc/locale.gen; locale-gen; update-locale LANG=bn_IN.UTF-8; echo "[+] Set to Bengali" ;;
    5) read -p "Locale code (e.g. gu_IN.UTF-8): " lc
       sed -i "s/# $lc/$lc/" /etc/locale.gen 2>/dev/null; locale-gen; update-locale LANG="$lc"; echo "[+] Set to $lc" ;;
    6) exit 0 ;;
esac