#!/bin/bash
# Vajra OS Enhanced Accessibility Settings
set -e
echo "=== Vajra OS Enhanced Accessibility ==="
echo "  1. Screen reader (Orca)"
echo "  2. Magnifier"
echo "  3. High contrast mode"
echo "  4. Large text"
echo "  5. Sticky keys"
echo "  6. Slow keys"
echo "  7. On-screen keyboard"
echo "  8. Visual alerts"
echo "  9. Color blindness filter"
echo " 10. Configure all (recommended)"
echo "  0. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y orca 2>/dev/null; orca &
       echo "[+] Screen reader started" ;;
    2) gsettings set org.gnome.desktop.a11y magnifier-enabled true 2>/dev/null
       echo "[+] Magnifier enabled (Super+Alt+8 to toggle)" ;;
    3) gsettings set org.gnome.desktop.interface gtk-theme 'HighContrast' 2>/dev/null
       echo "[+] High contrast enabled" ;;
    4) gsettings set org.gnome.desktop.interface text-scaling-factor 1.25 2>/dev/null
       echo "[+] Large text enabled (1.25x)" ;;
    5) gsettings set org.gnome.desktop.a11y.keyboard stickykeys-enable true 2>/dev/null
       echo "[+] Sticky keys enabled" ;;
    6) gsettings set org.gnome.desktop.a11y.keyboard slowkeys-enable true 2>/dev/null
       echo "[+] Slow keys enabled" ;;
    7) apt-get install -y onboard 2>/dev/null; onboard &
       echo "[+] On-screen keyboard started" ;;
    8) gsettings set org.gnome.desktop.a11y.visual-bell-enabled true 2>/dev/null
       echo "[+] Visual alerts enabled" ;;
    9) echo "Color blindness filters available in Settings > Display > Color Filters" ;;
    10) apt-get install -y orca onboard 2>/dev/null
        gsettings set org.gnome.desktop.a11y magnifier-enabled true 2>/dev/null
        gsettings set org.gnome.desktop.interface text-scaling-factor 1.25 2>/dev/null
        gsettings set org.gnome.desktop.a11y.keyboard stickykeys-enable true 2>/dev/null
        gsettings set org.gnome.desktop.a11y.visual-bell-enabled true 2>/dev/null
        echo "[+] All accessibility features enabled" ;;
    0) exit 0 ;;
esac