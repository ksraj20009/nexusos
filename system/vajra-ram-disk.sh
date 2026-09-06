#!/bin/bash
# Vajra OS RAM Disk Creator
set -e
echo "=== Vajra OS RAM Disk ==="
echo "  1. Create RAM disk (1GB)"
echo "  2. Create RAM disk (custom size)"
echo "  3. Remove RAM disk"
echo "  4. Exit"
read -p "Choice: " choice
MOUNT_POINT="/mnt/ramdisk"
case "$choice" in
    1) mkdir -p "$MOUNT_POINT"
       mount -t tmpfs -o size=1G tmpfs "$MOUNT_POINT"
       echo "[+] 1GB RAM disk mounted at $MOUNT_POINT" ;;
    2) read -p "Size (e.g. 2G, 512M): " sz
       mkdir -p "$MOUNT_POINT"
       mount -t tmpfs -o size="$sz" tmpfs "$MOUNT_POINT"
       echo "[+] ${sz} RAM disk mounted at $MOUNT_POINT" ;;
    3) umount "$MOUNT_POINT" 2>/dev/null; echo "[+] RAM disk removed" ;;
    4) exit 0 ;;
esac