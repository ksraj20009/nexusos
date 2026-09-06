#!/bin/bash
# Vajra OS AMD Driver Installer
set -e
echo "=== Vajra OS AMD Driver Installer ==="
echo "  1. Install AMD driver (Mesa/Radeon)"
echo "  2. Install AMDPRO (professional)"
echo "  3. Verify installation"
echo "  4. Exit"
read -p "Choice: " choice
case "$choice" in
    1) echo "[*] Installing Mesa/Radeon drivers..."
       apt-get install -y mesa-vulkan-drivers mesa-utils firmware-amd-graphics 2>/dev/null
       echo "[+] AMD Mesa drivers installed" ;;
    2) echo "[*] Downloading AMDPRO from amd.com..."
       echo "  Visit: https://www.amd.com/en/support"
       echo "  Download and run the .run installer"
       apt-get install -y libdrm-amdgpu1 2>/dev/null ;;
    3) glxinfo | grep "OpenGL renderer" 2>/dev/null || echo "Install mesa-utils first"
       vainfo 2>/dev/null | head -5 || echo "Install vainfo for hardware acceleration info" ;;
    4) exit 0 ;;
esac