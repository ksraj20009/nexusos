#!/bin/bash
# Vajra OS Disk Manager
set -e
echo "=== Vajra OS Disk Manager ==="
echo "  1. List disks"
echo "  2. Disk usage"
echo "  3. Format partition"
echo "  4. Mount partition"
echo "  5. Unmount partition"
echo "  6. Create swap"
echo "  7. Check disk health (SMART)"
echo "  8. Exit"
read -p "Choice: " choice
case "$choice" in
    1) lsblk -f ;;
    2) df -h ;;
    3) read -p "Partition (e.g. /dev/sdb1): " p; read -p "Filesystem (ext4/btrfs/ntfs): " fs
       echo "WARNING: All data will be lost!"
       read -p "Confirm (yes): " c; [ "$c" = "yes" ] && mkfs."$fs" "$p" && echo "[+] Formatted" ;;
    4) read -p "Partition: " p; read -p "Mount point: " m; mkdir -p "$m"; mount "$p" "$m" && echo "[+] Mounted" ;;
    5) read -p "Mount point: " m; umount "$m" && echo "[+] Unmounted" ;;
    6) read -p "Swap partition: " p; mkswap "$p" && swapon "$p" && echo "[+] Swap enabled" ;;
    7) read -p "Disk (e.g. /dev/sda): " d; smartctl -a "$d" 2>/dev/null || echo "Install smartmontools" ;;
    8) exit 0 ;;
esac