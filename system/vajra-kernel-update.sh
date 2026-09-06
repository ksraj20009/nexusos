#!/bin/bash
# Vajra OS Kernel Update
set -e
echo "=== Vajra OS Kernel Update ==="
echo "[*] Current kernel:"
uname -r
echo ""
echo "  1. Install latest kernel"
echo "  2. Install specific kernel version"
echo "  3. List available kernels"
echo "  4. Remove old kernels"
echo "  5. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y linux-image-amd64 linux-headers-amd64 2>/dev/null
       echo "[+] Latest kernel installed. Reboot to use." ;;
    2) read -p "Version (e.g. 6.1.0-18): " ver
       apt-get install -y linux-image-$ver-amd64 2>/dev/null && echo "[+] Kernel $ver installed" ;;
    3) dpkg -l | grep linux-image | awk '{print $2, $3}' ;;
    4) apt-get autoremove --purge -y 2>/dev/null; echo "[+] Old kernels removed" ;;
    5) exit 0 ;;
esac