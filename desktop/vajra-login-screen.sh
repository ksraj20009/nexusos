#!/bin/bash
# =============================================================
# Vajra OS Login Screen Configuration
# Configures LightDM/GDM with Vajra branding
# =============================================================

set -e

echo "=== Vajra OS Login Screen Setup ==="

WALLPAPER="/usr/share/backgrounds/vajra/vajra-default-1920x1080.png"
LOGO="/usr/share/icons/Vajra/256x256/apps/vajra-os.png"

# --- LightDM Configuration ---
configure_lightdm() {
    echo "[*] Configuring LightDM..."
    mkdir -p /etc/lightdm
    
    cat > /etc/lightdm/lightdm.conf << 'CONF'
[LightDM]
run-directory=/run/lightdm
log-directory=/var/log/lightdm

[Seat:*]
greeter-session=lightdm-gtk-greeter
user-session=vajra-desktop
session-wrapper=/etc/lightdm/Xsession
allow-guest=false
greeter-hide-users=false
enable-manual-login=true
show-language-selector=true
hide-user-image=false
CONF

    cat > /etc/lightdm/lightdm-gtk-greeter.conf << GREETER
[greeter]
background=${WALLPAPER}
logo=${LOGO}
theme-name=Vajra-Dark
icon-theme-name=Vajra
cursor-theme-name=Vajra-Cursors
font-name=Cantarell 11
clock-format=%A, %d %B %Y  %I:%M %p
show-clock=true
show-language-selector=true
show-hostname=true
show-user-image=true
default-user-image=/usr/share/icons/Vajra/256x256/apps/vajra-os.png
indicators=~host;~spacer;~clock;~spacer;~language;~session;~power
GREETER

    echo "[+] LightDM configured"
    mkdir -p /usr/share/lightdm-gtk-greeter-config.d
}

# --- GDM Configuration (fallback) ---
configure_gdm() {
    echo "[*] Configuring GDM (fallback)..."
    mkdir -p /etc/gdm3
    cat > /etc/gdm3/custom.conf << 'GDM'
[daemon]
WaylandEnable=true
AutomaticLoginEnable=false

[security]
DisallowRoot=true

[greeter]
IncludeAll=true
WaylandEnable=true
GDM
    
    if [ -f "$WALLPAPER" ]; then
        cp "$WALLPAPER" /usr/share/backgrounds/gdm-vajra.png 2>/dev/null || true
        echo "[+] GDM background set"
    fi
    echo "[+] GDM configured"
}

# --- Create login screen welcome message ---
cat > /etc/vajra/login-message.txt << 'MSG'

    VAJRA OS (वज्र)
    Thunderbolt Strong. Unbreakable.
    
    Welcome! Please select your user to log in.
MSG

echo "[+] Login message created"

# --- Configure login sound ---
cat > /etc/lightdm/login-sound.sh << 'SOUND'
#!/bin/bash
if [ -f /usr/share/sounds/vajra/login.ogg ]; then
    paplay /usr/share/sounds/vajra/login.ogg 2>/dev/null &
fi
SOUND
chmod +x /etc/lightdm/login-sound.sh
echo "[+] Login sound configured"

# --- Configure accessibility ---
mkdir -p /etc/lightdm/lightdm-gtk-greeter.conf.d
cat > /etc/lightdm/lightdm-gtk-greeter.conf.d/99-accessibility << 'ACCESS'
[greeter]
a11y-states=~keyboard;~contrast
ACCESS
echo "[+] Accessibility features enabled on login screen"

# --- Main ---
if command -v lightdm &>/dev/null || [ -d /etc/lightdm ]; then
    configure_lightdm
else
    echo "[!] LightDM not found, configuring GDM instead"
    configure_gdm
fi

echo ""
echo "=== Login Screen Setup Complete ==="
echo "Background: $WALLPAPER"
echo "Greeter: LightDM GTK Greeter"
echo "Theme: Vajra-Dark"
echo ""
echo "To preview: switch to TTY1 (Ctrl+Alt+F1)"
echo "To restart: sudo systemctl restart lightdm"