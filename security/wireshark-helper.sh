#!/bin/bash
# Vajra OS — Wireshark Packet Analyzer Helper
set -e
echo "◆ Vajra OS — Wireshark Helper"
SD_DIR="/opt/vajra/security"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/wireshark-helper.sh" << 'WSH'
#!/bin/bash
case "${1:-launch}" in
    launch)
        if ! command -v wireshark &>/dev/null; then
            echo "  Installing Wireshark..."
            sudo apt-get update -qq && sudo apt-get install -y wireshark 2>/dev/null
        fi
        sudo usermod -aG wireshark "$USER" 2>/dev/null
        wireshark &
        echo "  ✓ Wireshark launched"
        ;;
    capture)
        IFACE="${2:-eth0}"
        echo "  Capturing on $IFACE for 60 seconds..."
        sudo timeout 60 tshark -i "$IFACE" -w /tmp/vajra-capture.pcap 2>/dev/null
        echo "  ✓ Capture saved to /tmp/vajra-capture.pcap"
        ;;
    read)
        FILE="$2"
        [ -z "$FILE" ] && echo "  Usage: vajra-wireshark read <file.pcap>" && exit 1
        tshark -r "$FILE" 2>/dev/null | head -50
        ;;
    http)
        IFACE="${2:-eth0}"
        echo "  Capturing HTTP traffic on $IFACE..."
        sudo tshark -i "$IFACE" -Y "http" -T fields -e ip.src -e http.host 2>/dev/null | head -30
        ;;
    dns)
        IFACE="${2:-eth0}"
        echo "  Capturing DNS queries on $IFACE..."
        sudo tshark -i "$IFACE" -Y "dns.qry.name" -T fields -e ip.src -e dns.qry.name 2>/dev/null | head -30
        ;;
    help|*)
        echo "  Vajra OS - Wireshark Helper"
        echo "  Commands:"
        echo "    vajra-wireshark launch          - Open Wireshark GUI"
        echo "    vajra-wireshark capture <iface> - Capture 60s to file"
        echo "    vajra-wireshark read <file>     - Read pcap file"
        echo "    vajra-wireshark http <iface>    - Live HTTP capture"
        echo "    vajra-wireshark dns <iface>     - Live DNS capture"
        ;;
esac
WSH
chmod +x "$SD_DIR/wireshark-helper.sh"
ln -sf "$SD_DIR/wireshark-helper.sh" /usr/local/bin/vajra-wireshark 2>/dev/null || true
echo "  ✓ Wireshark helper installed"
echo "◆ Done"
