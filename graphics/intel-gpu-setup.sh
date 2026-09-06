#!/bin/bash
# Vajra OS Intel GPU Setup
set -e
echo "=== Vajra OS Intel GPU Setup ==="
echo "[*] Installing Intel graphics drivers..."
apt-get install -y mesa-utils intel-media-va-driver libgl1-mesa-dri 2>/dev/null
echo "[+] Intel drivers installed"
echo "[*] Installing Vulkan support..."
apt-get install -y mesa-vulkan-drivers 2>/dev/null
echo "[+] Vulkan support added"
echo "[*] GPU info:"
lspci | grep -i vga
glxinfo | grep "OpenGL renderer" 2>/dev/null || echo "  Reboot to activate"
echo "[+] Intel GPU setup complete"