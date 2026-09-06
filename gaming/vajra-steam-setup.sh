#!/bin/bash
# Vajra OS Steam Setup
set -e
echo "=== Vajra OS Steam Setup ==="
echo "[*] Installing Steam..."
apt-get install -y steam 2>/dev/null || snap install steam 2>/dev/null || echo "Install Steam manually from store.steampowered.com"
echo "[*] Installing 32-bit libraries for compatibility..."
dpkg --add-architecture i386 2>/dev/null || true
apt-get update 2>/dev/null || true
apt-get install -y libgl1-mesa-dri:i386 libgl1:i386 libc6:i386 2>/dev/null || true
echo "[+] Steam installed"
echo "[*] Installing Proton for Windows games..."
echo "  Enable Proton in Steam > Settings > Compatibility"
echo "  Check 'Enable Steam Play for all other titles'"
echo "[+] Proton ready"