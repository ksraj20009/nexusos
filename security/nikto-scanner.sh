#!/bin/bash
# Vajra OS — Nikto Web Vulnerability Scanner
set -e
echo "◆ Vajra OS — Nikto Scanner"
SD_DIR="/opt/vajra/security"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/nikto-scanner.sh" << 'NIKTO'
#!/bin/bash
case "${1:-help}" in
    scan)
        TARGET="$2"
        [ -z "$TARGET" ] && echo "  Usage: vajra-nikto scan <host>" && exit 1
        echo "  Scanning $TARGET for vulnerabilities..."
        nikto -h "$TARGET" 2>/dev/null
        ;;
    ssl)
        TARGET="$2"
        [ -z "$TARGET" ] && echo "  Usage: vajra-nikto ssl <host>" && exit 1
        echo "  SSL scan of $TARGET ..."
        nikto -h "$TARGET" -ssl 2>/dev/null
        ;;
    port)
        TARGET="$2"; PORT="$3"
        [ -z "$TARGET" ] || [ -z "$PORT" ] && echo "  Usage: vajra-nikto port <host> <port>" && exit 1
        nikto -h "$TARGET" -p "$PORT" 2>/dev/null
        ;;
    help|*)
        echo "  Vajra OS - Nikto Web Vulnerability Scanner"
        echo "  Commands:"
        echo "    vajra-nikto scan <host>         - Standard web scan"
        echo "    vajra-nikto ssl <host>          - SSL/HTTPS scan"
        echo "    vajra-nikto port <host> <port>  - Scan specific port"
        ;;
esac
NIKTO
chmod +x "$SD_DIR/nikto-scanner.sh"
ln -sf "$SD_DIR/nikto-scanner.sh" /usr/local/bin/vajra-nikto 2>/dev/null || true
echo "  ✓ Nikto scanner installed"
echo "◆ Done"
