#!/bin/bash
# Vajra OS — Aircrack-ng WiFi Auditing Suite
set -e
echo "◆ Vajra OS — Aircrack-ng Suite"
SD_DIR="/opt/vajra/security"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/aircrack-ng-suite.sh" << 'AIR'
#!/bin/bash
case "${1:-help}" in
    monitor)
        IFACE="${2:-wlan0}"
        echo "  Enabling monitor mode on $IFACE ..."
        sudo airmon-ng start "$IFACE" 2>/dev/null
        echo "  ✓ Monitor mode enabled"
        ;;
    stop)
        IFACE="${2:-wlan0mon}"
        sudo airmon-ng stop "$IFACE" 2>/dev/null
        echo "  ✓ Monitor mode stopped"
        ;;
    scan)
        IFACE="${2:-wlan0mon}"
        echo "  Scanning for WiFi networks (10 seconds)..."
        sudo timeout 10 airodump-ng "$IFACE" 2>/dev/null
        ;;
    capture)
        IFACE="$2"; BSSID="$3"; CH="$4"
        [ -z "$IFACE" ] || [ -z "$BSSID" ] || [ -z "$CH" ] && echo "  Usage: vajra-aircrack capture <iface> <bssid> <channel>" && exit 1
        echo "  Capturing on $BSSID channel $CH ..."
        sudo airodump-ng -c "$CH" --bssid "$BSSID" -w /tmp/vajra-wifi "$IFACE" 2>/dev/null
        ;;
    crack)
        FILE="$2"; WL="${3:-/usr/share/wordlists/rockyou.txt}"
        [ -z "$FILE" ] && echo "  Usage: vajra-aircrack crack <capture.cap> [wordlist]" && exit 1
        aircrack-ng -w "$WL" "$FILE" 2>/dev/null
        ;;
    help|*)
        echo "  Vajra OS - Aircrack-ng WiFi Auditing Suite"
        echo "  Commands:"
        echo "    vajra-aircrack monitor <iface>              - Enable monitor mode"
        echo "    vajra-aircrack stop <iface>                 - Stop monitor mode"
        echo "    vajra-aircrack scan <iface>                - Scan for networks"
        echo "    vajra-aircrack capture <iface> <bssid> <ch> - Capture handshake"
        echo "    vajra-aircrack crack <file.cap> [wordlist]  - Crack WPA handshake"
        echo ""
        echo "  WARNING: Only audit WiFi networks you own or have permission to test."
        ;;
esac
AIR
chmod +x "$SD_DIR/aircrack-ng-suite.sh"
ln -sf "$SD_DIR/aircrack-ng-suite.sh" /usr/local/bin/vajra-aircrack 2>/dev/null || true
echo "  ✓ Aircrack-ng suite installed"
echo "◆ Done"
