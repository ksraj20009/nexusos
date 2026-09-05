#!/bin/bash
# Vajra OS — WiFi Security Auditor
case "${1:-help}" in
    scan)
        echo "  Scanning WiFi networks..."
        nmcli device wifi list 2>/dev/null
        ;;
    security)
        echo "  WiFi security info:"
        nmcli -f SSID,SECURITY,SIGNAL device wifi list 2>/dev/null
        echo ""
        echo "  Warning: Open networks are insecure!"
        nmcli -f SSID,SECURITY device wifi list 2>/dev/null | grep -i "open" && echo "  Open networks detected!"
        ;;
    wps)
        IFACE="${2:-wlan0}"
        echo "  Checking WPS on $IFACE ..."
        sudo reaver -i "$IFACE" -b "$(iwgetid -r)" --scan 2>/dev/null || echo "  Install reaver for WPS testing"
        ;;
    handshake)
        IFACE="$2"; BSSID="$3"; CH="$4"
        [ -z "$IFACE" ] || [ -z "$BSSID" ] || [ -z "$CH" ] && echo "  Usage: vajra-wifi handshake <iface> <bssid> <channel>" && exit 1
        echo "  Capturing WPA handshake..."
        sudo airmon-ng start "$IFACE" 2>/dev/null
        sudo airodump-ng -c "$CH" --bssid "$BSSID" -w /tmp/vajra-handshake "${IFACE}mon" 2>/dev/null
        ;;
    help|*)
        echo "  Vajra OS - WiFi Security Auditor"
        echo "  Commands: scan, security, wps [iface], handshake <iface> <bssid> <ch>"
        ;;
esac
