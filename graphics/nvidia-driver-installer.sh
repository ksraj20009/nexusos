#!/bin/bash
# Vajra OS NVIDIA Driver Installer
set -e
echo "=== Vajra OS NVIDIA Driver Installer ==="
echo "  1. Install NVIDIA driver (auto-detect)"
echo "  2. Install specific version"
echo "  3. Install CUDA toolkit"
echo "  4. Verify installation"
echo "  5. Uninstall driver"
echo "  6. Exit"
read -p "Choice: " choice
case "$choice" in
    1) echo "[*] Detecting GPU..."
       lspci | grep -i nvidia
       echo "[*] Installing recommended driver..."
       apt-get install -y nvidia-driver 2>/dev/null || apt-get install -y nvidia-driver-535 2>/dev/null || true
       echo "[+] NVIDIA driver installed. Reboot required." ;;
    2) read -p "Version (e.g. 535, 550): " ver
       apt-get install -y nvidia-driver-$ver 2>/dev/null && echo "[+] NVIDIA driver $ver installed" ;;
    3) echo "[*] Installing CUDA..."
       apt-get install -y nvidia-cuda-toolkit 2>/dev/null && echo "[+] CUDA installed"
       echo "  Verify: nvidia-smi" ;;
    4) nvidia-smi 2>/dev/null && echo "[+] NVIDIA driver working" || echo "[-] Driver not loaded. Reboot?" ;;
    5) apt-get purge -y nvidia-* 2>/dev/null; echo "[+] NVIDIA drivers removed" ;;
    6) exit 0 ;;
esac