#!/bin/bash
# =============================================================
# Vajra OS Window Manager Configuration
# Sets up window manager defaults (Mutter/GNOME Shell)
# =============================================================

set -e

echo "=== Vajra OS Window Manager Setup ==="

MODE=$(cat /etc/vajra/mode 2>/dev/null || echo "beginner")

# --- Mutter configuration ---
configure_mutter() {
    echo "[*] Configuring Mutter..."
    gsettings set org.gnome.mutter edge-tiling true 2>/dev/null || true
    gsettings set org.gnome.mutter attach-modal-dialogs true 2>/dev/null || true
    gsettings set org.gnome.mutter center-new-windows true 2>/dev/null || true
    gsettings set org.gnome.mutter auto-maximize false 2>/dev/null || true
    
    if [ "$MODE" = "pro" ]; then
        gsettings set org.gnome.desktop.wm.preferences focus-mode 'sloppy' 2>/dev/null || true
        gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
        gsettings set org.gnome.mutter dynamic-workspaces true 2>/dev/null || true
    else
        gsettings set org.gnome.desktop.wm.preferences focus-mode 'click' 2>/dev/null || true
        gsettings set org.gnome.desktop.wm.preferences num-workspaces 2
        gsettings set org.gnome.mutter dynamic-workspaces false 2>/dev/null || true
    fi
    
    gsettings set org.gnome.desktop.wm.preferences wrap-workspaces true 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.preferences action-double-click-titlebar 'toggle-maximize' 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.preferences action-middle-click-titlebar 'minimize' 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.preferences raise-on-click true 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.preferences audible-bell true 2>/dev/null || true
    gsettings set org.gnome.desktop.interface enable-animations true 2>/dev/null || true
    echo "[+] Mutter configured"
}

# --- Keyboard shortcuts ---
configure_shortcuts() {
    echo "[*] Configuring window management shortcuts..."
    gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q', '<Alt>F4']" 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.keybindings minimize "['<Super>h']" 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']" 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.keybindings unmaximize "['<Super>Down']" 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>m']" 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['F11']" 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>d']" 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Alt>Tab']" 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "['<Super>Page_Up']" 2>/dev/null || true
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Super>Page_Down']" 2>/dev/null || true
    echo "[+] Shortcuts configured"
}

# --- Window appearance ---
configure_appearance() {
    echo "[*] Configuring window appearance..."
    gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Cantarell Bold 11' 2>/dev/null || true
    if [ "$MODE" = "beginner" ]; then
        gsettings set org.gnome.desktop.wm.preferences button-layout ':close' 2>/dev/null || true
    else
        gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close' 2>/dev/null || true
    fi
    gsettings set org.gnome.desktop.interface gtk-theme 'Vajra-Dark' 2>/dev/null || true
    echo "[+] Appearance configured"
}

# --- Main ---
configure_mutter
configure_shortcuts
configure_appearance

echo ""
echo "=== Window Manager Setup Complete ==="
echo "Mode: $MODE"
echo "Snapping: Super+Arrow keys"
echo "Close: Super+Q | Minimize: Super+H | Maximize: Super+M"
echo "Workspaces: $([ "$MODE" = "beginner" ] && echo "2" || echo "4 dynamic")"