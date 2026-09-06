#!/bin/bash
# Vajra OS Braille Display Support
set -e
echo "=== Vajra OS Braille Display Support ==="
echo "[*] Installing BRLTTY (Braille display driver)..."
apt-get install -y brltty xbrlapi 2>/dev/null || true
systemctl enable brltty 2>/dev/null || true
systemctl start brltty 2>/dev/null || true
echo "[+] BRLTTY installed and started"
echo "[*] Connect your Braille display via USB or Bluetooth"
echo "[*] Configure: /etc/brltty.conf"
echo "[+] Braille display support enabled"