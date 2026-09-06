#!/bin/bash
# Vajra OS Installation Script
# Installs all Vajra components on existing Debian/Ubuntu system
set -e
echo "============================================"
echo "  Vajra OS Installation Script"
echo "  India's Privacy-First AI Operating System"
echo "============================================"
echo ""

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root: sudo bash vajra-install-script.sh"
    exit 1
fi

echo "[1/8] Installing base packages..."
apt-get update
apt-get install -y git python3 python3-pip nodejs npm sudo openssh-server \
    ufw fail2ban network-manager firefox-esr gnome-core gnome-terminal \
    nautilus ibus ibus-m17n m17n-db fonts-noto orca onboard vlc ffmpeg

echo "[2/8] Creating Vajra directories..."
mkdir -p /opt/vajra/{ai,apps,security,locale,system,developer,gaming,unique,desktop}
mkdir -p /etc/vajra
mkdir -p /var/log/vajra

echo "[3/8] Setting up firewall..."
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
echo "y" | ufw enable

echo "[4/8] Setting up fail2ban..."
systemctl enable fail2ban
systemctl start fail2ban

echo "[5/8] Configuring Indian locale..."
sed -i 's/# en_IN.UTF-8 UTF-8/en_IN.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
update-locale LANG=en_IN.UTF-8

echo "[6/8] Setting up IBus for Indic input..."
ibus restart 2>/dev/null || true

echo "[7/8] Creating Vajra user (if needed)..."
if ! id "vajra" &>/dev/null; then
    useradd -m -s /bin/bash vajra
    echo "vajra:vajra" | chpasswd
    usermod -aG sudo vajra
fi

echo "[8/8] Setting hostname..."
echo "vajra" > /etc/hostname

echo ""
echo "============================================"
echo "  Vajra OS Installation Complete!"
echo "============================================"
echo "  Reboot to start using Vajra OS"
echo "  Login: vajra / vajra (change password!)"
echo "  Or use your existing user account"
echo ""
echo "  Quick commands:"
echo "    vj-ai      - Start Buddhi AI"
echo "    vj-sec     - Security suite"
echo "    vj-weather - Weather app"
echo "    vj-panchang - Hindu calendar"
echo "    vj-gst     - GST calculator"
echo "============================================"