#!/bin/bash
# Vajra OS Wine Setup (Windows compatibility)
set -e
echo "=== Vajra OS Wine Setup ==="
echo "[*] Installing Wine..."
apt-get install -y wine winetricks 2>/dev/null || true
echo "[*] Configuring Wine prefix..."
WINEPREFIX=~/.wine-vajra WINEARCH=win64 wine wineboot 2>/dev/null || true
echo "[*] Installing common components..."
winetricks corefonts vcrun2019 dxvk 2>/dev/null || true
echo "[+] Wine configured"
echo "  Run Windows apps: wine app.exe"
echo "  Wine prefix: ~/.wine-vajra"
echo "  Configure: winecfg"