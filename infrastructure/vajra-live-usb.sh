#!/bin/bash
# Vajra OS Live USB Creator
set -e
echo "=== Vajra OS Live USB Creator ==="
echo "Available USB drives:"
lsblk | grep -E "^sd|disk"
echo ""
read -p "ISO file path: " iso
read -p "USB device (e.g. /dev/sdb): " usb
echo ""
echo "WARNING: All data on $usb will be destroyed!"
read -p "Confirm (yes): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Cancelled."
    exit 0
fi
echo "[*] Writing ISO to USB (this may take several minutes)..."
dd if="$iso" of="$usb" bs=4M status=progress conv=fsync
sync
echo "[+] Live USB created successfully!"
echo "    Boot from USB to try Vajra OS without installing"