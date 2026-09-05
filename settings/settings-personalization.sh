#!/bin/bash
# Vajra OS — Personalization Settings
set -e
echo "◆ Vajra OS — Personalization Setup"
SD_DIR="/opt/vajra/settings"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/settings-personalization.sh" << 'PERS'
#!/bin/bash
case "${1:-status}" in
    status)
        echo "  Vajra OS - Personalization"
        echo "  Theme: $(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null || echo 'default')"
        echo "  Icons: $(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null || echo 'default')"
        echo "  Cursor: $(gsettings get org.gnome.desktop.interface cursor-theme 2>/dev/null || echo 'default')"
        echo "  Font: $(gsettings get org.gnome.desktop.interface font-name 2>/dev/null || echo 'default')"
        echo "  Dark Mode: $(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null || echo 'light')"
        echo "  Accent: $(gsettings get org.gnome.desktop.interface accent-color 2>/dev/null || echo 'blue')"
        ;;
    dark) gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null; gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark' 2>/dev/null; echo "  ✓ Dark mode enabled" ;;
    light) gsettings set org.gnome.desktop.interface color-scheme 'prefer-light' 2>/dev/null; gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita' 2>/dev/null; echo "  ✓ Light mode enabled" ;;
    theme) gsettings set org.gnome.desktop.interface gtk-theme "${2:-Adwaita}" 2>/dev/null; echo "  ✓ Theme set to ${2:-Adwaita}" ;;
    icons) gsettings set org.gnome.desktop.interface icon-theme "${2:-Adwaita}" 2>/dev/null; echo "  ✓ Icon theme set to ${2:-Adwaita}" ;;
    wallpaper)
        FILE="$2"; [ -z "$FILE" ] && echo "  Usage: vajra-settings personalization wallpaper <file>" && exit 1
        gsettings set org.gnome.desktop.background picture-uri "file://$FILE" 2>/dev/null
        gsettings set org.gnome.desktop.background picture-uri-dark "file://$FILE" 2>/dev/null
        echo "  ✓ Wallpaper set to $FILE"
        ;;
    font) FONT="${2:-Noto Sans 11}"; gsettings set org.gnome.desktop.interface font-name "$FONT" 2>/dev/null; gsettings set org.gnome.desktop.interface document-font-name "$FONT" 2>/dev/null; echo "  ✓ Font set to $FONT" ;;
    accent) gsettings set org.gnome.desktop.interface accent-color "${2:-blue}" 2>/dev/null; echo "  ✓ Accent color set to ${2:-blue}" ;;
    cursor) gsettings set org.gnome.desktop.interface cursor-size "${2:-24}" 2>/dev/null; echo "  ✓ Cursor size set to ${2:-24}" ;;
    lock-screen) FILE="$2"; [ -z "$FILE" ] && echo "  Usage: vajra-settings personalization lock-screen <file>" && exit 1; gsettings set org.gnome.desktop.screensaver picture-uri "file://$FILE" 2>/dev/null; echo "  ✓ Lock screen wallpaper set" ;;
    auto-lock) SEC="${2:-300}"; gsettings set org.gnome.desktop.session idle-delay "$SEC" 2>/dev/null; echo "  ✓ Auto-lock after $SEC seconds" ;;
    animations) case "${2:-on}" in on) gsettings set org.gnome.desktop.interface enable-animations true 2>/dev/null; echo "  ✓ Animations on" ;; off) gsettings set org.gnome.desktop.interface enable-animations false 2>/dev/null; echo "  ✓ Animations off" ;; esac ;;
    themes-list) echo "  GTK themes:"; ls /usr/share/themes/ 2>/dev/null | head -20; echo "  Icon themes:"; ls /usr/share/icons/ 2>/dev/null | head -20 ;;
    *) echo "Usage: vajra-settings personalization {status|dark|light|theme|icons|wallpaper|font|accent|cursor|lock-screen|auto-lock|animations}" ;;
esac
PERS
chmod +x "$SD_DIR/settings-personalization.sh"
ln -sf "$SD_DIR/settings-personalization.sh" /usr/local/bin/vajra-settings-personalization 2>/dev/null || true
echo "  ✓ Personalization settings installed"
echo "◆ Done"
