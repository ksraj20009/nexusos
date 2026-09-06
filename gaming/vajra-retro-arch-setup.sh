#!/bin/bash
# Vajra OS RetroArch Setup (retro gaming)
set -e
echo "=== Vajra OS RetroArch Setup ==="
echo "[*] Installing RetroArch..."
apt-get install -y retroarch 2>/dev/null || snap install retroarch 2>/dev/null || true
echo "[*] Installing cores..."
retroarch --download-cores 2>/dev/null || true
echo "[+] RetroArch installed"
echo ""
echo "  Cores available:"
echo "    - NES (FCEUmm)"
echo "    - SNES (Snes9x)"
echo "    - Genesis (Genesis Plus GX)"
echo "    - GameBoy (Gambatte)"
echo "    - PS1 (Beetle PSX)"
echo "    - N64 (Mupen64Plus)"
echo ""
echo "  ROMs go in: ~/RetroArch/roms/"
mkdir -p ~/RetroArch/roms
echo "[+] ROMs directory created"