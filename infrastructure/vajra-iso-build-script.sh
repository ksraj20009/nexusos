#!/bin/bash
# Vajra OS ISO Build Script
# Creates a bootable ISO using live-build
set -e
echo "=== Vajra OS ISO Builder ==="
WORKDIR="/scratch/work/vajra-iso"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

echo "[*] Installing live-build..."
apt-get install -y live-build calamares 2>/dev/null || true

echo "[*] Initializing live-build config..."
lb config \
    --distribution bookworm \
    --architecture amd64 \
    --debian-installer live \
    --iso-volume "Vajra OS" \
    --iso-publisher "Vajra OS Project" \
    --application-title "Vajra OS" \
    --hostname vajra

echo "[*] Adding Vajra packages..."
mkdir -p config/package-lists
cat > config/package-lists/vajra-core.list.chroot << 'PKGS'
gnome-core
firefox-esr
gnome-terminal
nautilus
gedit
file-roller
evince
eog
sudo
openssh-server
ufw
fail2ban
network-manager
vlc
ffmpeg
gimp
git
python3
python3-pip
nodejs
npm
docker.io
ibus
ibus-m17n
m17n-db
fonts-noto
orca
onboard
PKGS

echo "[*] Adding Vajra custom files..."
mkdir -p config/includes.chroot/opt/vajra
mkdir -p config/includes.chroot/etc/skel/.config

echo "[*] Building ISO..."
lb build 2>&1 | tee build.log

echo "[+] ISO created: $WORKDIR/live-image-amd64.hybrid.iso"
echo "    Rename to: vajra-os-$(date +%Y%m%d).iso"
echo "    Write to USB: dd if=vajra-os.iso of=/dev/sdX bs=4M status=progress"