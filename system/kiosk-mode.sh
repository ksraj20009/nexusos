#!/bin/bash
# Vajra OS — Kiosk Mode
# Lock down the system to run a single application in fullscreen
set -e

echo "◆ Vajra OS — Kiosk Mode Setup"

KIOSK_DIR="/opt/vajra/kiosk"
mkdir -p "$KIOSK_DIR"

# Kiosk configuration
cat > "$KIOSK_DIR/kiosk.conf" << 'CONF'
# Vajra OS Kiosk Configuration
KIOSK_APP="firefox-esr"
KIOSK_URL="https://vajra.os"
KIOSK_USER="kiosk"
KIOSK_DISPLAY=":0"
KIOSK_ROTATE=false
KIOSK_SCREENSAVER=false
KIOSK_INACTIVITY_TIMEOUT=0
CONF

# Kiosk launcher script
cat > "$KIOSK_DIR/kiosk-launch.sh" << 'LAUNCH'
#!/bin/bash
source /opt/vajra/kiosk/kiosk.conf

# Disable screensaver
xset s off 2>/dev/null
xset s noblank 2>/dev/null
xset -dpms 2>/dev/null

# Hide cursor after inactivity (if unclutter installed)
if command -v unclutter &>/dev/null; then
    unclutter -idle 1 -root &
fi

# Start kiosk app in fullscreen
while true; do
    case "$KIOSK_APP" in
        firefox-esr|firefox|chromium|chromium-browser)
            $KIOSK_APP --kiosk "$KIOSK_URL" --noerrdialogs \
                --disable-translate --disable-features=TranslateUI \
                --disable-session-crashed-bubble --disable-infobars \
                --no-first-run --no-default-browser-check \
                2>/dev/null
            ;;
        *)
            $KIOSK_APP 2>/dev/null
            ;;
    esac
    sleep 2
done
LAUNCH
chmod +x "$KIOSK_DIR/kiosk-launch.sh"

# Create kiosk user
if ! id "$KIOSK_USER" &>/dev/null; then
    useradd -m -s /bin/bash "$KIOSK_USER" 2>/dev/null || true
    echo "  ✓ Created kiosk user"
fi

# Auto-login kiosk user (if on display)
cat > "/etc/systemd/system/kiosk.service" << 'SVC'
[Unit]
Description=Vajra OS Kiosk Mode
After=graphical.target

[Service]
Type=simple
User=root
ExecStart=/opt/vajra/kiosk/kiosk-launch.sh
Restart=always
RestartSec=3
Environment=DISPLAY=:0

[Install]
WantedBy=graphical.target
SVC

# Lockdown: disable TTY switching
cat > "/etc/X11/xorg.conf.d/10-kiosk.conf" << 'XORG'
Section "ServerFlags"
    Option "DontVTSwitch" "true"
    Option "DontZap" "true"
EndSection

Section "InputClass"
    Identifier "Keyboard Defaults"
    Option "XkbOptions" ""
EndSection
XORG

case "${1:-setup}" in
    enable)
        systemctl enable kiosk.service 2>/dev/null
        systemctl start kiosk.service 2>/dev/null
        echo "  ✓ Kiosk mode ENABLED — reboot to activate"
        ;;
    disable)
        systemctl disable kiosk.service 2>/dev/null
        systemctl stop kiosk.service 2>/dev/null
        rm -f /etc/X11/xorg.conf.d/10-kiosk.conf
        echo "  ✓ Kiosk mode DISABLED"
        ;;
    status)
        systemctl status kiosk.service 2>/dev/null || echo "  Not running"
        ;;
    setup|*)
        echo "  ✓ Kiosk mode installed"
        echo "  Usage: $0 {enable|disable|status}"
        echo "  Config: $KIOSK_DIR/kiosk.conf"
        ;;
esac
echo "◆ Done"
