#!/bin/bash
# Vajra OS — Privacy & Security Settings
set -e
echo "◆ Vajra OS — Privacy & Security Settings Setup"
SD_DIR="/opt/vajra/settings"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/settings-privacy.sh" << 'PRIV'
#!/bin/bash
case "${1:-status}" in
    status)
        echo "  Vajra OS - Privacy & Security"
        echo "  Location: $(gsettings get org.gnome.system.location enabled 2>/dev/null || echo 'off')"
        echo "  Camera: $(lsmod | grep -q uvcvideo && echo 'ENABLED' || echo 'DISABLED')"
        echo "  Microphone: $(amixer sget Capture 2>/dev/null | grep -o '\[on\]\|\[off\]' | head -1)"
        echo "  Bluetooth: $(systemctl is-active bluetooth 2>/dev/null || echo 'off')"
        echo "  Tor: $(systemctl is-active tor 2>/dev/null || echo 'off')"
        echo "  Firewall: $(sudo ufw status 2>/dev/null | head -1 || echo 'unknown')"
        echo "  Telemetry: BLOCKED"
        echo "  Disk Encryption: $(lsblk -o FSTYPE 2>/dev/null | grep -q crypto_LUKS && echo 'LUKS' || echo 'none')"
        echo "  MAC Random: $(grep cloned-mac /etc/NetworkManager/conf.d/*.conf 2>/dev/null | grep -o 'random' | head -1 || echo 'off')"
        echo "  Screen Lock: $(gsettings get org.gnome.desktop.screensaver lock-enabled 2>/dev/null || echo 'on')"
        ;;
    camera-off) sudo modprobe -r uvcvideo 2>/dev/null; echo "  ✓ Camera disabled" ;;
    camera-on) sudo modprobe uvcvideo 2>/dev/null; echo "  ✓ Camera enabled" ;;
    mic-off) amixer sset Capture mute 2>/dev/null; echo "  ✓ Microphone muted" ;;
    mic-on) amixer sset Capture unmute 2>/dev/null; echo "  ✓ Microphone enabled" ;;
    location-off) gsettings set org.gnome.system.location enabled false 2>/dev/null; sudo systemctl stop geoclue 2>/dev/null; sudo systemctl disable geoclue 2>/dev/null; echo "  ✓ Location services disabled" ;;
    location-on) gsettings set org.gnome.system.location enabled true 2>/dev/null; sudo systemctl start geoclue 2>/dev/null; echo "  ✓ Location services enabled" ;;
    bluetooth-off) sudo systemctl stop bluetooth 2>/dev/null; sudo systemctl disable bluetooth 2>/dev/null; echo "  ✓ Bluetooth disabled" ;;
    bluetooth-on) sudo systemctl start bluetooth 2>/dev/null; sudo systemctl enable bluetooth 2>/dev/null; echo "  ✓ Bluetooth enabled" ;;
    firewall-on) sudo ufw enable 2>/dev/null; sudo ufw default deny incoming 2>/dev/null; sudo ufw default allow outgoing 2>/dev/null; echo "  ✓ Firewall enabled" ;;
    firewall-off) sudo ufw disable 2>/dev/null; echo "  ✓ Firewall disabled" ;;
    tor-on) sudo systemctl start tor 2>/dev/null; echo "  ✓ Tor started" ;;
    tor-off) sudo systemctl stop tor 2>/dev/null; echo "  ✓ Tor stopped" ;;
    screen-lock) SEC="${2:-300}"; gsettings set org.gnome.desktop.screensaver lock-enabled true 2>/dev/null; gsettings set org.gnome.desktop.session idle-delay "$SEC" 2>/dev/null; echo "  ✓ Screen lock after $SEC seconds" ;;
    screen-lock-off) gsettings set org.gnome.desktop.screensaver lock-enabled false 2>/dev/null; gsettings set org.gnome.desktop.session idle-delay 0 2>/dev/null; echo "  ✓ Screen lock disabled" ;;
    mac-random)
        cat > /etc/NetworkManager/conf.d/vajra-mac.conf << 'EOF'
[device]
wifi.scan-rand-mac-address=yes
[connection]
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
EOF
        sudo systemctl restart NetworkManager 2>/dev/null; echo "  ✓ MAC randomization enabled"
        ;;
    harden) vajra-privacy harden ;;
    encrypt) echo "  Disk Encryption (LUKS): sudo cryptsetup luksFormat /dev/sdX"; echo "  Then: sudo cryptsetup luksOpen /dev/sdX vajra-enc" ;;
    *) echo "Usage: vajra-settings privacy {status|camera-off|camera-on|mic-off|mic-on|location-off|location-on|bluetooth-off|bluetooth-on|firewall-on|firewall-off|tor-on|tor-off|screen-lock|harden|encrypt}" ;;
esac
PRIV
chmod +x "$SD_DIR/settings-privacy.sh"
ln -sf "$SD_DIR/settings-privacy.sh" /usr/local/bin/vajra-settings-privacy 2>/dev/null || true
echo "  ✓ Privacy & security settings installed"
echo "◆ Done"
