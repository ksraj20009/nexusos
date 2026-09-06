#!/bin/bash
# Vajra OS Game Manager
set -e
echo "=== Vajra OS Game Manager ==="
echo "  1. Install Steam"
echo "  2. Install RetroArch"
echo "  3. Install Lutris (all platforms)"
echo "  4. Install Wine (Windows games)"
echo "  5. Install Heroic Games Launcher (Epic/GOG)"
echo "  6. Game performance (Gamemode)"
echo "  7. Exit"
read -p "Choice: " choice
case "$choice" in
    1) bash /opt/vajra/gaming/vajra-steam-setup.sh ;;
    2) bash /opt/vajra/gaming/vajra-retro-arch-setup.sh ;;
    3) apt-get install -y lutris 2>/dev/null || echo "Install from lutris.net"; echo "[+] Lutris installed" ;;
    4) apt-get install -y wine winetricks 2>/dev/null; echo "[+] Wine installed" ;;
    5) apt-get install -y heroic 2>/dev/null || snap install heroic 2>/dev/null || echo "Install from heroicgameslauncher.com"; echo "[+] Heroic installed" ;;
    6) apt-get install -y gamemode 2>/dev/null; echo "[+] Feral Gamemode installed - use 'gamemoderun ./game'" ;;
    7) exit 0 ;;
esac