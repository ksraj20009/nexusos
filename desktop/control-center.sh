#!/bin/bash
# Vajra OS — Control Center
# Unified settings hub like Windows Settings / Mac System Preferences
set -e

echo "◆ Vajra OS — Control Center Setup"

CC_DIR="/opt/vajra/control-center"
mkdir -p "$CC_DIR"

cat > "$CC_DIR/control-center.sh" << 'CC'
#!/bin/bash
# Vajra OS Control Center — All settings in one place

show_menu() {
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  ◆ Vajra OS — Control Center                 ║"
    echo "╠═══════════════════════════════════════════════╣"
    echo "║                                               ║"
    echo "║  1. Display & Resolution                      ║"
    echo "║  2. Sound & Audio                             ║"
    echo "║  3. Network & WiFi                            ║"
    echo "║  4. Bluetooth                                 ║"
    echo "║  5. Power & Battery                           ║"
    echo "║  6. Privacy & Security                        ║"
    echo "║  7. Users & Accounts                          ║"
    echo "║  8. Date & Time                               ║"
    echo "║  9. Language & Region                         ║"
    echo "║ 10. Keyboard & Shortcuts                      ║"
    echo "║ 11. Mouse & Touchpad                          ║"
    echo "║ 12. Printers & Scanners                       ║"
    echo "║ 13. Storage & Disk                            ║"
    echo "║ 14. Apps & Features                           ║"
    echo "║ 15. Updates                                   ║"
    echo "║ 16. Accessibility                             ║"
    echo "║ 17. Buddhi AI Settings                        ║"
    echo "║ 18. About Vajra OS                            ║"
    echo "║  0. Exit                                      ║"
    echo "║                                               ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""
    read -p "  Select option [0-18]: " choice
    case "$choice" in
        1) gnome-control-center display 2>/dev/null || xrandr ;;
        2) gnome-control-center sound 2>/dev/null || alsamixer ;;
        3) gnome-control-center network 2>/dev/null || nmtui ;;
        4) vajra-bt status ;;
        5) vajra-power status ;;
        6) vajra-privacy status ;;
        7) gnome-control-center user-accounts 2>/dev/null || whoami ;;
        8) gnome-control-center datetime 2>/dev/null || timedatectl ;;
        9) locale ;;
        10) gnome-control-center keyboard 2>/dev/null ;;
        11) gnome-control-center mouse 2>/dev/null || xinput list ;;
        12) vajra-print status ;;
        13) df -h ;;
        14) flatpak list 2>/dev/null; echo "Packages: $(dpkg --list | wc -l)" ;;
        15) vajra-update check ;;
        16) echo "Run accessibility-suite.sh" ;;
        17) echo "Buddhi AI: curl http://127.0.0.1:5210/status" ;;
        18) echo "Vajra OS 1.0 — वज्र | Kernel: $(uname -r) | $(nproc) cores" ;;
        0) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
}

while true; do
    show_menu
    echo ""
    read -p "Press Enter to continue..." _
    clear
done
CC
chmod +x "$CC_DIR/control-center.sh"
ln -sf "$CC_DIR/control-center.sh" /usr/local/bin/vajra-control 2>/dev/null || true

echo "  ✓ Control center installed"
echo "  ◆ Usage: vajra-control"
echo "◆ Done"
