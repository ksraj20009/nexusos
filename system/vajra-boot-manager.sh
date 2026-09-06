#!/bin/bash
# Vajra OS Boot Manager
set -e
echo "=== Vajra OS Boot Manager ==="
echo "  1. Show boot entries"
echo "  2. Set default boot entry"
echo "  3. Set boot timeout"
echo "  4. Update GRUB"
echo "  5. Reinstall GRUB"
echo "  6. Boot recovery"
echo "  7. Exit"
read -p "Choice: " choice
case "$choice" in
    1) grep "menuentry" /boot/grub/grub.cfg 2>/dev/null | head -10 || echo "No GRUB config" ;;
    2) read -p "Entry number: " n; sed -i "s/GRUB_DEFAULT=.*/GRUB_DEFAULT=$n/" /etc/default/grub; update-grub 2>/dev/null; echo "[+] Default set" ;;
    3) read -p "Seconds: " t; sed -i "s/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=$t/" /etc/default/grub; update-grub 2>/dev/null; echo "[+] Timeout set to ${t}s" ;;
    4) update-grub 2>/dev/null; echo "[+] GRUB updated" ;;
    5) read -p "Disk (e.g. /dev/sda): " d; grub-install "$d" 2>/dev/null; update-grub; echo "[+] GRUB reinstalled" ;;
    6) echo "Boot recovery: Use Vajra installation USB" ;;
    7) exit 0 ;;
esac