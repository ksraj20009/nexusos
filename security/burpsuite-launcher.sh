#!/bin/bash
# Vajra OS — Burp Suite Web Proxy Launcher
set -e
echo "◆ Vajra OS — Burp Suite Launcher"
SD_DIR="/opt/vajra/security"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/burpsuite-launcher.sh" << 'BURP'
#!/bin/bash
case "${1:-launch}" in
    launch)
        echo "  Launching Burp Suite..."
        if command -v burpsuite &>/dev/null; then
            burpsuite &
        elif [ -f /usr/bin/burpsuite ]; then
            /usr/bin/burpsuite &
        else
            echo "  Burp Suite not installed."
            echo "  Install with: sudo apt-get install burpsuite"
        fi
        echo "  ✓ Burp Suite launched (configure browser proxy to 127.0.0.1:8080)"
        ;;
    proxy)
        echo "  Setting system proxy to 127.0.0.1:8080..."
        gsettings set org.gnome.system.proxy mode 'manual' 2>/dev/null
        gsettings set org.gnome.system.proxy.http host '127.0.0.1' 2>/dev/null
        gsettings set org.gnome.system.proxy.http port 8080 2>/dev/null
        gsettings set org.gnome.system.proxy.https host '127.0.0.1' 2>/dev/null
        gsettings set org.gnome.system.proxy.https port 8080 2>/dev/null
        echo "  ✓ Proxy configured"
        ;;
    proxy-off)
        gsettings set org.gnome.system.proxy mode 'none' 2>/dev/null
        echo "  ✓ Proxy disabled"
        ;;
    help|*)
        echo "  Vajra OS - Burp Suite Launcher"
        echo "  Commands:"
        echo "    vajra-burpsuite launch     - Launch Burp Suite"
        echo "    vajra-burpsuite proxy      - Set system proxy to 127.0.0.1:8080"
        echo "    vajra-burpsuite proxy-off  - Disable proxy"
        ;;
esac
BURP
chmod +x "$SD_DIR/burpsuite-launcher.sh"
ln -sf "$SD_DIR/burpsuite-launcher.sh" /usr/local/bin/vajra-burpsuite 2>/dev/null || true
echo "  ✓ Burp Suite launcher installed"
echo "◆ Done"
