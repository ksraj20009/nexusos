#!/bin/bash
# Vajra OS Bluetooth Audio Setup
set -e
echo "=== Vajra OS Bluetooth Audio Setup ==="
echo "[*] Installing Bluetooth audio packages..."
apt-get install -y bluez pulseaudio-module-bluetooth blueman 2>/dev/null || true
systemctl enable bluetooth 2>/dev/null || true
systemctl start bluetooth 2>/dev/null || true
echo "[+] Bluetooth installed"
echo "[*] Scanning for audio devices..."
bluetoothctl scan on 2>/dev/null &
sleep 5
bluetoothctl devices 2>/dev/null
echo ""
read -p "Device MAC to pair: " mac
if [ -n "$mac" ]; then
    bluetoothctl pair "$mac" 2>/dev/null
    bluetoothctl connect "$mac" 2>/dev/null
    echo "[+] Connected to $mac"
fi
echo "[+] Bluetooth audio setup complete"