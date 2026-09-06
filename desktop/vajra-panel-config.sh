#!/bin/bash
# =============================================================
# Vajra OS Desktop Panel / Taskbar Configuration
# Configures GNOME panel / dash with Vajra defaults
# =============================================================

set -e

echo "=== Vajra OS Panel Configuration ==="

MODE=$(cat /etc/vajra/mode 2>/dev/null || echo "beginner")
echo "[*] Mode: $MODE"

configure_gnome() {
    echo "[*] Configuring GNOME Shell panel..."
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM' 2>/dev/null || true
    if [ "$MODE" = "beginner" ]; then
        gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 64 2>/dev/null || true
        gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false 2>/dev/null || true
    else
        gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 40 2>/dev/null || true
        gsettings set org.gnome.shell.extensions.dash-to-dock extend-height true 2>/dev/null || true
    fi
    gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'DYNAMIC' 2>/dev/null || true
    gsettings set org.gnome.shell.extensions.dash-to-dock show-trash true 2>/dev/null || true
    gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts true 2>/dev/null || true
    gsettings set org.gnome.shell.extensions.dash-to-dock show-show-apps-button true 2>/dev/null || true
    if [ "$MODE" = "beginner" ]; then
        gsettings set org.gnome.desktop.wm.preferences num-workspaces 2
    else
        gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
    fi
    gsettings set org.gnome.desktop.interface enable-hot-corners true 2>/dev/null || true
    gsettings set org.gnome.desktop.interface clock-format '12h' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface clock-show-date true 2>/dev/null || true
    gsettings set org.gnome.desktop.interface clock-show-weekday true 2>/dev/null || true
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'in'), ('xkb', 'us')]" 2>/dev/null || true
    gsettings set org.gnome.desktop.peripherals.touchpad tap-to-click true 2>/dev/null || true
    gsettings set org.gnome.desktop.peripherals.touchpad natural-scroll true 2>/dev/null || true
    gsettings set org.gnome.desktop.interface gtk-theme 'Vajra-Dark' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-theme 'Vajra' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface cursor-theme 'Vajra-Cursors' 2>/dev/null || true
    gsettings set org.gnome.desktop.interface font-name 'Cantarell 11' 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close' 2>/dev/null || true
    echo "[+] GNOME Shell configured"
}

configure_desktop_icons() {
    echo "[*] Configuring desktop icons..."
    gsettings set org.gnome.shell.extensions.desktop-icons show-desktop-icons true 2>/dev/null || true
    if [ "$MODE" = "beginner" ]; then
        gsettings set org.gnome.shell.extensions.desktop-icons icon-size 'large' 2>/dev/null || true
    else
        gsettings set org.gnome.shell.extensions.desktop-icons icon-size 'standard' 2>/dev/null || true
    fi
    echo "[+] Desktop icons configured"
}

configure_shortcuts() {
    echo "[*] Configuring Vajra keyboard shortcuts..."
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
        "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', \
          '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', \
          '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', \
          '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']" 2>/dev/null || true
    # Super+Space: Spotlight Search
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Spotlight Search' 2>/dev/null || true
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'bash /opt/vajra/desktop/spotlight-search.sh' 2>/dev/null || true
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>space' 2>/dev/null || true
    # Super+A: Buddhi AI
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Buddhi AI' 2>/dev/null || true
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'python3 /opt/vajra/ai/buddhi-ai.py' 2>/dev/null || true
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Super>a' 2>/dev/null || true
    # Super+T: Terminal
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ name 'Vajra Terminal' 2>/dev/null || true
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ command 'gnome-terminal' 2>/dev/null || true
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding '<Super>t' 2>/dev/null || true
    # Ctrl+Alt+Del: Task Manager
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ name 'Vajra Task Manager' 2>/dev/null || true
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ command 'bash /opt/vajra/desktop/task-manager.sh' 2>/dev/null || true
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/ binding '<Control><Alt>Delete' 2>/dev/null || true
    echo "[+] Keyboard shortcuts configured"
}

configure_autostart() {
    echo "[*] Configuring autostart applications..."
    AUTOSTART_DIR="/etc/xdg/autostart"
    mkdir -p "$AUTOSTART_DIR"
    cat > "$AUTOSTART_DIR/vajra-buddhi-ai.desktop" << 'DESKTOP'
[Desktop Entry]
Name=Buddhi AI
Comment=Vajra OS AI Assistant
Exec=python3 /opt/vajra/ai/buddhi-ai.py --daemon
Icon=buddhi-ai
Terminal=false
Type=Application
Categories=System;
X-GNOME-Autostart-enabled=true
DESKTOP
    cat > "$AUTOSTART_DIR/vajra-notifications.desktop" << 'DESKTOP2'
[Desktop Entry]
Name=Vajra Notifications
Comment=Vajra OS notification daemon
Exec=bash /opt/vajra/desktop/notification-daemon.sh
Icon=notifications
Terminal=false
Type=Application
Categories=System;
X-GNOME-Autostart-enabled=true
DESKTOP2
    cat > "$AUTOSTART_DIR/vajra-night-light.desktop" << 'DESKTOP3'
[Desktop Entry]
Name=Vajra Night Light
Comment=Blue light filter for eye protection
Exec=bash /opt/vajra/desktop/night-light.sh --start
Icon=weather-clear-night
Terminal=false
Type=Application
Categories=Utility;
X-GNOME-Autostart-enabled=true
DESKTOP3
    cat > "$AUTOSTART_DIR/vajra-health-reminder.desktop" << 'DESKTOP4'
[Desktop Entry]
Name=Vajra Health Reminder
Comment=Posture, hydration, and eye rest reminders
Exec=python3 /opt/vajra/system/health-reminder.py
Icon=preferences-system-health
Terminal=false
Type=Application
Categories=Utility;
X-GNOME-Autostart-enabled=true
DESKTOP4
    echo "[+] Autostart applications configured"
}

configure_window_manager() {
    echo "[*] Configuring window manager..."
    gsettings set org.gnome.mutter edge-tiling true 2>/dev/null || true
    gsettings set org.gnome.mutter attach-modal-dialogs true 2>/dev/null || true
    if [ "$MODE" = "beginner" ]; then
        gsettings set org.gnome.desktop.wm.preferences button-layout ':close' 2>/dev/null || true
    else
        gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close' 2>/dev/null || true
    fi
    gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Cantarell Bold 11' 2>/dev/null || true
    echo "[+] Window manager configured"
}

# --- Main ---
configure_gnome
configure_desktop_icons
configure_shortcuts
configure_autostart
configure_window_manager

echo ""
echo "=== Vajra Panel Configuration Complete ==="
echo "Mode: $MODE"
echo "Panel: Bottom dock with Vajra apps"
echo "Shortcuts: Super+Space (search), Super+A (AI), Super+T (terminal)"
echo "Autostart: Buddhi AI, Notifications, Night Light, Health Reminder"
echo ""
echo "To apply changes: log out and log back in"