#!/bin/bash
# Vajra OS — Accessibility Settings
set -e
echo "◆ Vajra OS — Accessibility Settings Setup"
SD_DIR="/opt/vajra/settings"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/settings-accessibility.sh" << 'ACC'
#!/bin/bash
case "${1:-status}" in
    status)
        echo "  Vajra OS - Accessibility"
        echo "  Visual:"
        echo "    High Contrast: $(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | grep -q HighContrast && echo 'ON' || echo 'off')"
        echo "    Large Text: $(gsettings get org.gnome.desktop.interface text-scaling-factor 2>/dev/null || echo '1.0')"
        echo "    Screen Reader: $(gsettings get org.gnome.desktop.interface toolkit-accessibility 2>/dev/null || echo 'off')"
        echo "    Magnifier: $(gsettings get org.gnome.desktop.a11y.applications screen-magnifier-enabled 2>/dev/null || echo 'off')"
        echo "    Cursor Size: $(gsettings get org.gnome.desktop.interface cursor-size 2>/dev/null || echo '24')"
        echo "  Hearing:"
        echo "    Visual Alerts: $(gsettings get org.gnome.desktop.wm.preferences visual-bell 2>/dev/null || echo 'off')"
        echo "  Motor:"
        echo "    Sticky Keys: $(gsettings get org.gnome.desktop.a11y.keyboard stickykeys-enable 2>/dev/null || echo 'off')"
        echo "    Slow Keys: $(gsettings get org.gnome.desktop.a11y.keyboard slowkeys-enable 2>/dev/null || echo 'off')"
        echo "    Mouse Keys: $(gsettings get org.gnome.desktop.a11y.keyboard mousekeys-enable 2>/dev/null || echo 'off')"
        echo "    On-Screen Keyboard: $(gsettings get org.gnome.desktop.a11y.applications screen-keyboard-enabled 2>/dev/null || echo 'off')"
        ;;
    high-contrast)
        case "${2:-on}" in
            on) gsettings set org.gnome.desktop.interface gtk-theme 'HighContrast' 2>/dev/null; echo "  ✓ High contrast enabled" ;;
            off) gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita' 2>/dev/null; echo "  ✓ High contrast disabled" ;;
        esac
        ;;
    large-text)
        case "${2:-on}" in
            on) gsettings set org.gnome.desktop.interface text-scaling-factor 1.5 2>/dev/null; echo "  ✓ Large text enabled" ;;
            off) gsettings set org.gnome.desktop.interface text-scaling-factor 1.0 2>/dev/null; echo "  ✓ Large text disabled" ;;
        esac
        ;;
    screen-reader)
        case "${2:-on}" in
            on) gsettings set org.gnome.desktop.interface toolkit-accessibility true 2>/dev/null; orca --setup 2>/dev/null & echo "  ✓ Screen reader enabled (Orca)" ;;
            off) gsettings set org.gnome.desktop.interface toolkit-accessibility false 2>/dev/null; echo "  ✓ Screen reader disabled" ;;
        esac
        ;;
    magnifier)
        case "${2:-on}" in
            on) gsettings set org.gnome.desktop.a11y.magnifier mag-factor 2.0 2>/dev/null; gsettings set org.gnome.desktop.a11y.applications screen-magnifier-enabled true 2>/dev/null; echo "  ✓ Magnifier enabled (2x)" ;;
            off) gsettings set org.gnome.desktop.a11y.applications screen-magnifier-enabled false 2>/dev/null; echo "  ✓ Magnifier disabled" ;;
        esac
        ;;
    sticky-keys)
        case "${2:-on}" in
            on) gsettings set org.gnome.desktop.a11y.keyboard stickykeys-enable true 2>/dev/null; echo "  ✓ Sticky keys enabled" ;;
            off) gsettings set org.gnome.desktop.a11y.keyboard stickykeys-enable false 2>/dev/null; echo "  ✓ Sticky keys disabled" ;;
        esac
        ;;
    slow-keys)
        case "${2:-on}" in
            on) gsettings set org.gnome.desktop.a11y.keyboard slowkeys-enable true 2>/dev/null; echo "  ✓ Slow keys enabled" ;;
            off) gsettings set org.gnome.desktop.a11y.keyboard slowkeys-enable false 2>/dev/null; echo "  ✓ Slow keys disabled" ;;
        esac
        ;;
    mouse-keys)
        case "${2:-on}" in
            on) gsettings set org.gnome.desktop.a11y.keyboard mousekeys-enable true 2>/dev/null; echo "  ✓ Mouse keys enabled" ;;
            off) gsettings set org.gnome.desktop.a11y.keyboard mousekeys-enable false 2>/dev/null; echo "  ✓ Mouse keys disabled" ;;
        esac
        ;;
    onscreen-keyboard)
        case "${2:-on}" in
            on) gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true 2>/dev/null; echo "  ✓ On-screen keyboard enabled" ;;
            off) gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false 2>/dev/null; echo "  ✓ On-screen keyboard disabled" ;;
        esac
        ;;
    visual-alerts)
        case "${2:-on}" in
            on) gsettings set org.gnome.desktop.wm.preferences visual-bell true 2>/dev/null; echo "  ✓ Visual alerts enabled" ;;
            off) gsettings set org.gnome.desktop.wm.preferences visual-bell false 2>/dev/null; echo "  ✓ Visual alerts disabled" ;;
        esac
        ;;
    cursor-size) gsettings set org.gnome.desktop.interface cursor-size "${2:-24}" 2>/dev/null; echo "  ✓ Cursor size set to ${2:-24}" ;;
    color-blind) echo "  Color Blind Filters: 1.Deuteranopia 2.Protanopia 3.Tritanopia"; echo "  Apply via: magna --color-filter <type>" ;;
    *) echo "Usage: vajra-settings accessibility {status|high-contrast|large-text|screen-reader|magnifier|sticky-keys|slow-keys|mouse-keys|onscreen-keyboard|visual-alerts|cursor-size|color-blind}" ;;
esac
ACC
chmod +x "$SD_DIR/settings-accessibility.sh"
ln -sf "$SD_DIR/settings-accessibility.sh" /usr/local/bin/vajra-settings-accessibility 2>/dev/null || true
echo "  ✓ Accessibility settings installed"
echo "◆ Done"
