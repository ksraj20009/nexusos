#!/bin/bash
# ============================================================
#  NexusOS First Boot Setup Script
#  Runs automatically on first boot of the installed system
# ============================================================
set -e

LOG="/var/log/nexusos-firstboot.log"
exec 2>&1 | tee "$LOG"

echo "======================================"
echo "  NexusOS First Boot Setup"
echo "======================================"
echo ""

# --- 1. Detect hardware ---
echo "[1/8] Detecting hardware..."
CPU_ARCH=$(uname -m)
CPU_CORES=$(nproc)
TOTAL_RAM=$(free -g | awk '/^Mem:/{print $2}')
echo "  Architecture: $CPU_ARCH"
echo "  CPU cores:    $CPU_CORES"
echo "  RAM:          ${TOTAL_RAM}GB"

# --- 2. Configure package repositories ---
echo ""
echo "[2/8] Configuring package repositories..."
cat > /etc/pacman.conf << 'PACCONF'
[options]
HoldPkg = pacman glibc
Architecture = auto
CheckSpace
SigLevel = Required DatabaseOptional
LocalFileSigLevel = Optional

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[community]
Include = /etc/pacman.d/mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist

[nexusos]
Server = https://github.com/ksraj20009/nexusos/raw/main/repo/x86_64
SigLevel = Optional TrustAll
PACCONF

# --- 3. Update system ---
echo ""
echo "[3/8] Updating system packages..."
pacman -Syu --noconfirm || echo "  Warning: some updates failed (continuing)"

# --- 4. Set up Tor ---
echo ""
echo "[4/8] Configuring Tor..."
if [[ -f /opt/nexusos/privacy/torrc ]]; then
    cp /opt/nexusos/privacy/torrc /etc/tor/torrc
    systemctl enable tor 2>/dev/null || true
    systemctl start tor 2>/dev/null || true
    echo "  ✓ Tor configured and started"
else
    echo "  → Tor config not found, skipping"
fi

# --- 5. Set up firewall ---
echo ""
echo "[5/8] Configuring firewall..."
if [[ -f /opt/nexusos/privacy/firewall.rules ]]; then
    cp /opt/nexusos/privacy/firewall.rules /etc/nexusos/firewall.rules
    if systemctl list-unit-files | grep -q firewalld; then
        systemctl enable firewalld
        systemctl start firewalld
        firewall-cmd --permanent --set-default-zone=drop
        firewall-cmd --permanent --add-service=dhcpv6-client
        firewall-cmd --permanent --add-service=ssh
        firewall-cmd --reload
        echo "  ✓ Firewall configured (default zone: drop)"
    fi
else
    echo "  → Firewall config not found"
fi

# --- 6. Set up DNS encryption ---
echo ""
echo "[6/8] Configuring encrypted DNS..."
if [[ -f /opt/nexusos/privacy/dns.conf ]]; then
    cp /opt/nexusos/privacy/dns.conf /etc/systemd/resolved.conf
    systemctl restart systemd-resolved 2>/dev/null || true
    echo "  ✓ DNS-over-HTTPS configured"
fi

# --- 7. Set up MAC randomization ---
echo ""
echo "[7/8] Configuring MAC address randomization..."
mkdir -p /etc/NetworkManager/conf.d
cat > /etc/NetworkManager/conf.d/nexusos-mac.conf << 'MACCONF'
[device]
wifi.scan-rand-mac-address=yes

[connection]
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
MACCONF
systemctl restart NetworkManager 2>/dev/null || true
echo "  ✓ MAC randomization enabled"

# --- 8. Set up AI assistant ---
echo ""
echo "[8/8] Setting up AI assistant..."
if [[ -f /opt/nexusos/ai/nexus-ai.py ]]; then
    pip3 install --no-cache-dir requests vosk sounddevice || true
    systemctl enable nexus-ai 2>/dev/null || true
    systemctl start nexus-ai 2>/dev/null || true
    echo "  ✓ AI assistant configured"
fi

# --- Final setup ---
echo ""
echo "Setting up user directories..."
for dir in Desktop Documents Downloads Music Pictures Videos; do
    mkdir -p "/home/$SUDO_USER/$dir" 2>/dev/null || true
    mkdir -p "/root/$dir" 2>/dev/null || true
done

echo "nexusos" > /etc/hostname
timedatectl set-timezone Asia/Kolkata 2>/dev/null || true
timedatectl set-ntp true 2>/dev/null || true

# --- Welcome message ---
cat > /etc/motd << 'MOTD'

    ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆

    ◆                              ◆
    ◆        NexusOS 1.0           ◆
    ◆        "Aurora"              ◆
    ◆                              ◆
    ◆   Your OS. Your Rules.       ◆
    ◆         Your Privacy.        ◆
    ◆                              ◆
    ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆

    Type "nexus-ai" to talk to your AI assistant.
    Press Ctrl+Space for the AI command bar.

MOTD

# Mark first boot as complete
rm -f /etc/systemd/system/multi-user.target.wants/nexus-firstboot.service
systemctl daemon-reload

echo ""
echo "======================================"
echo "  NexusOS First Boot Complete! ✓"
echo "======================================"
echo ""
echo "Your private, AI-powered OS is ready."
echo "Press Ctrl+Space to use the AI assistant."
echo ""