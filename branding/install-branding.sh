#!/bin/bash
# Vajra OS Branding Installer
set -e
echo "◆ Vajra OS Branding Installer"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# GNOME Theme
mkdir -p /usr/share/themes/Vajra-Dark/gtk-3.0
cat > /usr/share/themes/Vajra-Dark/gtk-3.0/gtk.css << 'CSS'
@define-color vajra_bg #1a1a2e;
@define-color vajra_fg #e0e0e0;
@define-color vajra_accent #c8500c;
window { background-color: @vajra_bg; color: @vajra_fg; }
button { background: @vajra_accent; color: white; border-radius: 6px; padding: 6px 16px; }
button:hover { background: shade(@vajra_accent, 1.2); }
entry { background: shade(@vajra_bg, 0.8); color: @vajra_fg; border-radius: 6px; padding: 6px; }
headerbar { background: @vajra_bg; color: @vajra_fg; border-bottom: 2px solid @vajra_accent; }
switch:checked { background: @vajra_accent; }
scale highlight { background: @vajra_accent; }
CSS

# Wallpaper
mkdir -p /usr/share/backgrounds/vajra
python3 "${SCRIPT_DIR}/wallpaper/generate-wallpaper.py"

# GRUB
if [ -f /etc/default/grub ]; then
    sed -i 's/GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="Vajra OS"/' /etc/default/grub
    update-grub 2>/dev/null || true
fi

# GDM
mkdir -p /etc/gdm3
cat > /etc/gdm3/daemon.conf << 'GDM'
[daemon]
AutomaticLoginEnable=true
AutomaticLogin=vajra
WaylandEnable=false
[security]
DisallowRoot=true
GDM

# GNOME Settings
sudo -u vajra gsettings set org.gnome.desktop.background picture-uri "file:///usr/share/backgrounds/vajra/wallpaper.png" 2>/dev/null || true
sudo -u vajra gsettings set org.gnome.desktop.interface gtk-theme "Vajra-Dark" 2>/dev/null || true
sudo -u vajra gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" 2>/dev/null || true

# Hostname
echo "vajra" > /etc/hostname
hostname vajra 2>/dev/null || true

echo "◆ Vajra OS branding installed!"
