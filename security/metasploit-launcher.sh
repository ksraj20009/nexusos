#!/bin/bash
# Vajra OS — Metasploit Framework Launcher
set -e
echo "◆ Vajra OS — Metasploit Launcher"
SD_DIR="/opt/vajra/security"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/metasploit-launcher.sh" << 'MSF'
#!/bin/bash
case "${1:-console}" in
    console)
        echo "  Launching Metasploit Console..."
        if ! command -v msfconsole &>/dev/null; then
            echo "  Installing Metasploit (large download ~500MB)..."
            sudo apt-get update -qq && sudo apt-get install -y metasploit-framework 2>/dev/null
        fi
        msfconsole -q
        ;;
    update)
        echo "  Updating Metasploit..."
        sudo msfupdate 2>/dev/null || sudo apt-get update && sudo apt-get install -y metasploit-framework
        ;;
    db)
        echo "  Starting Metasploit database..."
        sudo systemctl start postgresql 2>/dev/null
        msfdb init 2>/dev/null
        echo "  ✓ Database ready"
        ;;
    help|*)
        echo "  Vajra OS - Metasploit Launcher"
        echo "  Commands:"
        echo "    vajra-metasploit console  - Launch msfconsole"
        echo "    vajra-metasploit update   - Update Metasploit"
        echo "    vajra-metasploit db       - Initialize database"
        echo ""
        echo "  WARNING: Only use on systems you own or have permission to test."
        ;;
esac
MSF
chmod +x "$SD_DIR/metasploit-launcher.sh"
ln -sf "$SD_DIR/metasploit-launcher.sh" /usr/local/bin/vajra-metasploit 2>/dev/null || true
echo "  ✓ Metasploit launcher installed"
echo "◆ Done"
