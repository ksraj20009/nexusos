#!/bin/bash
# Vajra OS Switch Control (for motor disabilities, free, built-in)
set -e
echo "=== Vajra OS Switch Control ==="
echo "[*] Configuring switch control access..."
gsettings set org.gnome.desktop.a11y.keyboard stickykeys-enable true 2>/dev/null || true
gsettings set org.gnome.desktop.a11y.keyboard stickykeys-two-key-off true 2>/dev/null || true
gsettings set org.gnome.desktop.a11y.keyboard slowkeys-enable true 2>/dev/null || true
gsettings set org.gnome.desktop.a11y.keyboard bouncekeys-enable true 2>/dev/null || true
gsettings set org.gnome.desktop.a11y.mouse click-type-window-visible true 2>/dev/null || true
echo "[+] Switch control enabled:"
echo "    - Sticky keys: ON (press one key at a time)"
echo "    - Slow keys: ON (key must be held longer)"
echo "    - Bounce keys: ON (ignore rapid repeats)"
echo "    - Simulated click: ON"
echo "[*] Configure in Settings > Accessibility > Typing"