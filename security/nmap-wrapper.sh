#!/bin/bash
# Vajra OS — Nmap Network Scanner Wrapper
set -e
echo "◆ Vajra OS — Nmap Network Scanner"
SD_DIR="/opt/vajra/security"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/nmap-wrapper.sh" << 'NMAP'
#!/bin/bash
case "${1:-help}" in
    scan)
        TARGET="$2"
        [ -z "$TARGET" ] && echo "  Usage: vajra-nmap scan <ip/domain>" && exit 1
        echo "  Scanning $TARGET ..."
        nmap -sS -sV -O "$TARGET" 2>/dev/null
        ;;
    quick)
        TARGET="$2"
        [ -z "$TARGET" ] && echo "  Usage: vajra-nmap quick <ip>" && exit 1
        nmap -T4 -F "$TARGET" 2>/dev/null
        ;;
    full)
        TARGET="$2"
        [ -z "$TARGET" ] && echo "  Usage: vajra-nmap full <ip>" && exit 1
        echo "  Full scan (may take 10+ minutes)..."
        nmap -sS -sV -O -A -p- "$TARGET" 2>/dev/null
        ;;
    udp)
        TARGET="$2"
        [ -z "$TARGET" ] && echo "  Usage: vajra-nmap udp <ip>" && exit 1
        echo "  UDP scan (slow)..."
        nmap -sU "$TARGET" 2>/dev/null
        ;;
    stealth)
        TARGET="$2"
        [ -z "$TARGET" ] && echo "  Usage: vajra-nmap stealth <ip>" && exit 1
        echo "  Stealth SYN scan..."
        nmap -sS -T2 "$TARGET" 2>/dev/null
        ;;
    vuln)
        TARGET="$2"
        [ -z "$TARGET" ] && echo "  Usage: vajra-nmap vuln <ip>" && exit 1
        echo "  Vulnerability scan..."
        nmap --script vuln "$TARGET" 2>/dev/null
        ;;
    os)
        TARGET="$2"
        [ -z "$TARGET" ] && echo "  Usage: vajra-nmap os <ip>" && exit 1
        nmap -O "$TARGET" 2>/dev/null
        ;;
    ports)
        TARGET="$2"; PORTS="$3"
        [ -z "$TARGET" ] && echo "  Usage: vajra-nmap ports <ip> <port-range>" && exit 1
        nmap -p "${PORTS:-1-1000}" "$TARGET" 2>/dev/null
        ;;
    subnet)
        SUBNET="$2"
        [ -z "$SUBNET" ] && echo "  Usage: vajra-nmap subnet <CIDR>" && exit 1
        echo "  Scanning subnet $SUBNET ..."
        nmap -sn "$SUBNET" 2>/dev/null
        ;;
    help|*)
        echo "  Vajra OS - Nmap Network Scanner"
        echo "  Commands:"
        echo "    vajra-nmap scan <ip>         - Standard scan (SYN, version, OS)"
        echo "    vajra-nmap quick <ip>         - Fast scan (top 100 ports)"
        echo "    vajra-nmap full <ip>          - Full scan (all 65535 ports + scripts)"
        echo "    vajra-nmap udp <ip>           - UDP port scan"
        echo "    vajra-nmap stealth <ip>       - Stealth SYN scan (slow, evasive)"
        echo "    vajra-nmap vuln <ip>          - Vulnerability detection scripts"
        echo "    vajra-nmap os <ip>            - OS fingerprinting"
        echo "    vajra-nmap ports <ip> <range> - Specific port range"
        echo "    vajra-nmap subnet <CIDR>      - Ping sweep subnet (e.g. 192.168.1.0/24)"
        ;;
esac
NMAP
chmod +x "$SD_DIR/nmap-wrapper.sh"
ln -sf "$SD_DIR/nmap-wrapper.sh" /usr/local/bin/vajra-nmap 2>/dev/null || true
echo "  ✓ Nmap wrapper installed"
echo "◆ Done"
