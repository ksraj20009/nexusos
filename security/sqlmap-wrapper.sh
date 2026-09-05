#!/bin/bash
# Vajra OS — SQLmap SQL Injection Tool Wrapper
set -e
echo "◆ Vajra OS — SQLmap Wrapper"
SD_DIR="/opt/vajra/security"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/sqlmap-wrapper.sh" << 'SQLI'
#!/bin/bash
case "${1:-help}" in
    scan)
        URL="$2"
        [ -z "$URL" ] && echo "  Usage: vajra-sqlmap scan <url>" && exit 1
        echo "  Testing $URL for SQL injection..."
        sqlmap -u "$URL" --batch 2>/dev/null
        ;;
    dump)
        URL="$2"
        [ -z "$URL" ] && echo "  Usage: vajra-sqlmap dump <url>" && exit 1
        echo "  Dumping database from $URL ..."
        sqlmap -u "$URL" --dump --batch 2>/dev/null
        ;;
    dbs)
        URL="$2"
        [ -z "$URL" ] && echo "  Usage: vajra-sqlmap dbs <url>" && exit 1
        sqlmap -u "$URL" --dbs --batch 2>/dev/null
        ;;
    os-shell)
        URL="$2"
        [ -z "$URL" ] && echo "  Usage: vajra-sqlmap os-shell <url>" && exit 1
        echo "  Attempting OS shell via SQL injection..."
        sqlmap -u "$URL" --os-shell --batch 2>/dev/null
        ;;
    help|*)
        echo "  Vajra OS - SQLmap SQL Injection Tool"
        echo "  Commands:"
        echo "    vajra-sqlmap scan <url>       - Test for SQL injection"
        echo "    vajra-sqlmap dump <url>      - Dump database tables"
        echo "    vajra-sqlmap dbs <url>       - List databases"
        echo "    vajra-sqlmap os-shell <url>  - Try to get OS shell"
        echo ""
        echo "  WARNING: Only test websites you own or have permission to test."
        ;;
esac
SQLI
chmod +x "$SD_DIR/sqlmap-wrapper.sh"
ln -sf "$SD_DIR/sqlmap-wrapper.sh" /usr/local/bin/vajra-sqlmap 2>/dev/null || true
echo "  ✓ SQLmap wrapper installed"
echo "◆ Done"
