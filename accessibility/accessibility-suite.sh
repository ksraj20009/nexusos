#!/bin/bash
# Vajra OS — Accessibility Suite
set -e
echo "◆ Vajra OS Accessibility Suite"

echo "[1/4] Setting up screen reader..."
apt-get install -y orca 2>/dev/null || true
if command -v orca &>/dev/null; then
    sudo -u vajra gsettings set org.gnome.desktop.a11y.applications screen-reader-enabled true 2>/dev/null || true
    echo "  ✓ Orca screen reader enabled (Super+Alt+S)"
fi

echo "[2/4] Setting up on-screen keyboard..."
apt-get install -y onboard 2>/dev/null || true
sudo -u vajra gsettings set org.gnome.desktop.a11y.applications on-screen-keyboard-enabled true 2>/dev/null || true
echo "  ✓ On-screen keyboard installed"

echo "[3/4] Setting up screen magnifier..."
sudo -u vajra gsettings set org.gnome.desktop.a11y.magnifier mag-factor 2.0 2>/dev/null || true
sudo -u vajra gsettings set org.gnome.desktop.a11y.magnifier lens-mode true 2>/dev/null || true
sudo -u vajra gsettings set org.gnome.desktop.a11y.magnifier show-cross-hairs true 2>/dev/null || true
echo "  ✓ Magnifier configured (Super+Alt+8)"

echo "[4/4] Setting up high contrast..."
cat > /usr/local/bin/vajra-accessibility << 'AC'
#!/bin/bash
case "$1" in
    reader-on) gsettings set org.gnome.desktop.a11y.applications screen-reader-enabled true; orca &; echo "🔊 Screen reader ON" ;;
    reader-off) gsettings set org.gnome.desktop.a11y.applications screen-reader-enabled false; killall orca 2>/dev/null; echo "Screen reader OFF" ;;
    keyboard-on) gsettings set org.gnome.desktop.a11y.applications on-screen-keyboard-enabled true; onboard &; echo "⌨️ Keyboard ON" ;;
    keyboard-off) gsettings set org.gnome.desktop.a11y.applications on-screen-keyboard-enabled false; killall onboard 2>/dev/null; echo "Keyboard OFF" ;;
    magnifier-on) gsettings set org.gnome.desktop.a11y.applications screen-magnifier-enabled true; echo "🔍 Magnifier ON" ;;
    magnifier-off) gsettings set org.gnome.desktop.a11y.applications screen-magnifier-enabled false; echo "Magnifier OFF" ;;
    high-contrast-on) gsettings set org.gnome.desktop.interface color-scheme "prefer-high-contrast"; gsettings set org.gnome.desktop.interface gtk-theme "HighContrast"; echo "🎨 High contrast ON" ;;
    high-contrast-off) gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"; gsettings set org.gnome.desktop.interface gtk-theme "Vajra-Dark"; echo "High contrast OFF" ;;
    large-text) gsettings set org.gnome.desktop.interface text-scaling-factor 1.5; echo "📝 Large text (1.5x)" ;;
    normal-text) gsettings set org.gnome.desktop.interface text-scaling-factor 1.0; echo "Normal text" ;;
    status) echo "Reader: $(gsettings get org.gnome.desktop.a11y.applications screen-reader-enabled 2>/dev/null)"; echo "Keyboard: $(gsettings get org.gnome.desktop.a11y.applications on-screen-keyboard-enabled 2>/dev/null)"; echo "Magnifier: $(gsettings get org.gnome.desktop.a11y.applications screen-magnifier-enabled 2>/dev/null)"; echo "Text scale: $(gsettings get org.gnome.desktop.interface text-scaling-factor 2>/dev/null)" ;;
    *) echo "Usage: vajra-accessibility [reader-on|off|keyboard-on|off|magnifier-on|off|high-contrast-on|off|large-text|normal-text|status]" ;;
esac
AC
chmod +x /usr/local/bin/vajra-accessibility

echo ""
echo "◆ Accessibility Suite installed!"
echo "  Super+Alt+S — Toggle screen reader"
echo "  Super+Alt+8 — Toggle magnifier"
echo "  Super+Alt+H — Toggle high contrast"
