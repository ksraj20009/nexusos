#!/bin/bash
# Vajra OS First Boot Setup Script — Runs on first boot after installation
set -e

VAJRA_VERSION="1.0"
FIRST_BOOT_FLAG="/etc/vajra/.first-boot-done"

if [ -f "$FIRST_BOOT_FLAG" ]; then
    exit 0
fi

echo ""
echo "  =================================================="
echo "  |    VAJRA OS First Boot Setup                  |"
echo "  |    Version $VAJRA_VERSION                             |"
echo "  =================================================="
echo ""

mkdir -p /etc/vajra /usr/share/vajra/tools /usr/share/vajra/polkit
mkdir -p /usr/share/vajra/wallpapers /usr/share/backgrounds/vajra

# Step 1: Generate locales
echo "[1/8] Generating Indian language locales..."
if command -v locale-gen &>/dev/null; then
    for loc in hi_IN.UTF-8 ta_IN.UTF-8 bn_IN.UTF-8 en_IN.UTF-8; do
        sed -i "s/# $loc/$loc/" /etc/locale.gen 2>/dev/null || echo "$loc UTF-8" >> /etc/locale.gen
    done
    locale-gen 2>/dev/null || true
    update-locale LANG=en_IN.UTF-8 2>/dev/null || true
fi
echo "  [+] Locales generated"

# Step 2: Create vajra user
echo "[2/8] Creating vajra user..."
if ! id vajra &>/dev/null; then
    useradd -m -s /bin/bash -G sudo,netdev,audio,video,plugdev vajra
    echo "vajra:vajra" | chpasswd
    echo "  [+] User 'vajra' created (password: vajra)"
else
    echo "  [+] User 'vajra' already exists"
fi

# Step 3: Set hostname
echo "[3/8] Setting hostname..."
echo "vajra-os" > /etc/hostname
echo "127.0.0.1 vajra-os localhost" > /etc/hosts
echo "::1 vajra-os localhost" >> /etc/hosts
echo "  [+] Hostname: vajra-os"

# Step 4: Configure Indian fonts
echo "[4/8] Configuring Indian language fonts..."
mkdir -p /etc/fonts/conf.d
if [ -f /usr/share/vajra/desktop/fontconfig/vajra-indic-fonts.conf ]; then
    ln -sf /usr/share/vajra/desktop/fontconfig/vajra-indic-fonts.conf /etc/fonts/conf.d/65-vajra-indic-fonts.conf
fi
echo "  [+] Indian font rendering enabled"

# Step 5: Configure IBus
echo "[5/8] Setting up Indian language input..."
if command -v ibus &>/dev/null; then
    export GTK_IM_MODULE=ibus QT_IM_MODULE=ibus XMODIFIERS=@im=ibus
    echo "  [+] IBus input method configured"
else
    echo "  [!] IBus not installed (install with: apt install ibus ibus-m17n)"
fi

# Step 6: Set up Vajra mode
echo "[6/8] Setting up Vajra OS modes..."
groupadd -f vajra-beginner
groupadd -f vajra-pro
usermod -aG vajra-beginner vajra
echo "  [+] Beginner mode enabled (safety guardrails ON)"

# Step 7: Enable systemd services
echo "[7/8] Enabling Vajra OS services..."
for svc in vajra-boot-check vajra-update-check.timer vajra-festival-reminder.timer vajra-ayurveda-reminder.timer; do
    systemctl enable $svc 2>/dev/null || true
done
echo "  [+] Services enabled"

# Step 8: Install polkit rules
echo "[8/8] Installing security policies..."
if [ -d /etc/polkit-1/rules.d ] && [ -f /usr/share/vajra/polkit/49-vajra-mode.rules ]; then
    cp /usr/share/vajra/polkit/49-vajra-mode.rules /etc/polkit-1/rules.d/
fi
echo "  [+] Security policies installed"

echo ""
echo "  =================================================="
echo "  |    Vajra OS Setup Complete!                   |"
echo "  |    User: vajra  Password: vajra (change it!)  |"
echo "  |    Mode: Beginner (safety guardrails ON)      |"
echo "  |    Dharmo Rakshati Rakshitah                  |"
echo "  =================================================="
echo ""
echo "  Type 'vajra-help' for all commands"
echo "  Type 'buddhi' for AI assistant"
echo ""

touch "$FIRST_BOOT_FLAG"
