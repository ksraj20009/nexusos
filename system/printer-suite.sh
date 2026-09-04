#!/bin/bash
# Vajra OS — Printer Suite
# Printer and scanning management
set -e

echo "◆ Vajra OS — Printer Suite Setup"

PR_DIR="/opt/vajra/printing"
mkdir -p "$PR_DIR"

cat > "$PR_DIR/printer-suite.sh" << 'PR'
#!/bin/bash

case "${1:-status}" in
    status)
        echo "◆ Vajra OS — Printer Status"
        if command -v lpstat &>/dev/null; then
            echo "  Printers:"
            lpstat -p 2>/dev/null || echo "  No printers configured"
            echo ""
            echo "  Default printer:"
            lpstat -d 2>/dev/null || echo "  No default set"
        else
            echo "  ⚠ CUPS not installed. Run: vajra-print install"
        fi
        ;;
    install)
        echo "◆ Installing printing support..."
        sudo apt-get install -y cups system-config-printer hplip 2>/dev/null || true
        sudo systemctl enable cups 2>/dev/null || true
        sudo systemctl start cups 2>/dev/null || true
        sudo usermod -aG lpadmin "$USER" 2>/dev/null || true
        echo "  ✓ CUPS installed and started"
        echo "  Web UI: http://localhost:631"
        ;;
    add)
        PRINTER_NAME="$2"
        PRINTER_URL="$3"
        [ -z "$PRINTER_NAME" ] || [ -z "$PRINTER_URL" ] && echo "  Usage: vajra-print add <name> <url>" && exit 1
        sudo lpadmin -p "$PRINTER_NAME" -E -v "$PRINTER_URL" -m everywhere 2>/dev/null
        echo "  ✓ Printer $PRINTER_NAME added"
        ;;
    remove)
        sudo lpadmin -x "$2" 2>/dev/null
        echo "  ✓ Printer $2 removed"
        ;;
    default)
        sudo lpadmin -d "$2" 2>/dev/null
        echo "  ✓ Default printer set to $2"
        ;;
    list)
        echo "◆ Configured Printers:"
        lpstat -p 2>/dev/null || echo "  None"
        ;;
    print)
        FILE="$2"
        [ -f "$FILE" ] && lpr "$FILE" && echo "  ✓ Sent $FILE to printer" || echo "  ✗ File not found"
        ;;
    scan)
        echo "◆ Scanning..."
        if command -v simple-scan &>/dev/null; then
            simple-scan 2>/dev/null
        else
            sudo apt-get install -y simple-scan 2>/dev/null
            simple-scan 2>/dev/null || echo "  ⚠ No scanner found"
        fi
        ;;
    queue)
        echo "◆ Print Queue:"
        lpstat -o 2>/dev/null || echo "  Queue empty"
        ;;
    cancel)
        cancel "$2" 2>/dev/null
        echo "  ✓ Cancelled job $2"
        ;;
    *)
        echo "Usage: vajra-print {status|install|add|remove|default|list|print|scan|queue|cancel}"
        ;;
esac
PR
chmod +x "$PR_DIR/printer-suite.sh"
ln -sf "$PR_DIR/printer-suite.sh" /usr/local/bin/vajra-print 2>/dev/null || true

echo "  ✓ Printer suite installed"
echo "  ◆ Usage: vajra-print {status|install|add|remove|print|scan|queue}"
echo "◆ Done"
