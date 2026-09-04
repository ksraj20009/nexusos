#!/bin/bash
# Vajra OS — Desktop Experience Suite
set -e
echo "◆ Vajra OS Desktop Suite"

# === Keyboard Shortcuts ===
cat > /usr/local/bin/vajra-shortcuts << 'SC'
#!/bin/bash
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "Buddhi AI" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "gnome-terminal -- buddhi" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "<Super>space" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "Voice Widget" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "python3 /opt/vajra/ai/widgets/voice-widget.py &" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "<Super>v" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name "Tor Toggle" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command "systemctl toggle tor" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding "<Super>t" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name "Screenshot" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command "gnome-screenshot -i" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding "<Super>s" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/ name "Files" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/ command "nautilus" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/ binding "<Super>f" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/ name "Lock Screen" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/ command "loginctl lock-session" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/ binding "<Super>l" 2>/dev/null || true
echo "✓ Keyboard shortcuts configured"
SC
chmod +x /usr/local/bin/vajra-shortcuts

# === Dark/Light Auto-Switch ===
cat > /usr/local/bin/vajra-theme-switch << 'TS'
#!/bin/bash
HOUR=$(date +%H)
if [ "$HOUR" -ge 19 ] || [ "$HOUR" -lt 7 ]; then
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    gsettings set org.gnome.desktop.interface gtk-theme "Vajra-Dark"
    echo "🌙 Dark mode (night)"
else
    gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
    gsettings set org.gnome.desktop.interface gtk-theme "Vajra-Dark"
    echo "☀️ Light mode (day)"
fi
TS
chmod +x /usr/local/bin/vajra-theme-switch
cat > /etc/cron.hourly/vajra-theme << 'CR'
#!/bin/bash
/usr/local/bin/vajra-theme-switch
CR
chmod +x /etc/cron.hourly/vajra-theme

# === Privacy Screen ===
cat > /usr/local/bin/vajra-privacy-screen << 'PS'
#!/bin/bash
echo "◆ Vajra Privacy Screen"
if command -v motion &>/dev/null; then
    while true; do
        MOTION=$(motion -n -d /tmp/vajra-motion 2>/dev/null | grep -c "motion_detected")
        if [ "$MOTION" -gt 3 ]; then
            loginctl lock-session 2>/dev/null
            notify-send "🔒 Privacy Screen" "Someone is behind you!" 2>/dev/null
        fi
        sleep 5
    done
else
    echo "Install motion: sudo apt install motion"
    echo "Or use manual lock: Super+L"
fi
PS
chmod +x /usr/local/bin/vajra-privacy-screen

# === GNOME Extensions ===
cat > /usr/local/bin/vajra-extensions << 'EXT'
#!/bin/bash
echo "Installing GNOME Shell extensions..."
apt-get install -y gnome-shell-extensions 2>/dev/null || true
for ext in user-theme dash-to-dock appindicators blur-my-shell; do
    gnome-extensions enable "$ext" 2>/dev/null || true
done
echo "✓ Extensions enabled"
EXT
chmod +x /usr/local/bin/vajra-extensions

# === System Widget ===
cat > /usr/local/bin/vajra-system-widget << 'SW'
#!/bin/bash
while true; do
    CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    RAM=$(free -m | awk '/Mem:/ {printf "%.0f%%", $3/$2*100}')
    DISK=$(df -h / | awk 'NR==2 {print $5}')
    echo "CPU: ${CPU}% | RAM: ${RAM} | Disk: ${DISK}"
    sleep 5
done
SW
chmod +x /usr/local/bin/vajra-system-widget

echo "◆ Desktop Suite installed!"
echo "  Super+Space — Buddhi AI"
echo "  Super+V     — Voice widget"
echo "  Super+T     — Toggle Tor"
echo "  Super+S     — Screenshot"
echo "  Super+F     — Files"
echo "  Super+L     — Lock screen"
