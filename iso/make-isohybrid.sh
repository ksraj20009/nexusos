#!/bin/bash
# Vajra OS ISO Hybrid Converter
# Converts a regular ISO to isohybrid (bootable as both USB and CD)
#
# Usage: ./make-isohybrid.sh [iso-file]
#
# Requirements: xorriso, isolinux, syslinux-common
# Install: sudo apt install xorriso isolinux syslinux-common

set -e

ISO="${1:-vajra-os-1.0-amd64.iso}"

if [ ! -f "$ISO" ]; then
    echo "  [ERROR] ISO not found: $ISO"
    exit 1
fi

echo ""
echo "  =================================================="
echo "  |    Vajra OS ISO Hybrid Converter               |"
echo "  =================================================="
echo ""

# Check for isohybrid
if ! command -v isohybrid &>/dev/null; then
    echo "  [!] isohybrid not found. Trying xorriso..."
    if command -v xorriso &>/dev/null; then
        echo "  [*] Using xorriso to rebuild as hybrid..."
        xorriso -as genisoimage \
            -o "${ISO%.iso}-hybrid.iso" \
            -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
            -c boot.cat \
            -b isolinux/isolinux.bin \
            -no-emul-boot -boot-load-size 4 -boot-info-table \
            -eltorito-alt-boot \
            -e efi/boot/bootx64.efi \
            -no-emul-boot -isohybrid-gpt-hfsplus \
            -V "VAJRA_OS_1.0" \
            -J -R \
            "$ISO"
        echo "  [+] Hybrid ISO: ${ISO%.iso}-hybrid.iso"
    else
        echo "  [ERROR] Neither isohybrid nor xorriso found"
        echo "  Install: sudo apt install xorriso isolinux syslinux-common"
        exit 1
    fi
else
    echo "  [*] Converting with isohybrid..."
    isohybrid "$ISO"
    echo "  [+] ISO is now hybrid (USB + CD bootable)"
    echo "  [+] File: $ISO"
fi

echo ""
echo "  Flash to USB:  dd if=$ISO of=/dev/sdX bs=4M status=progress"
echo "  Burn to CD:    xorriso -as cdrecord -v dev=/dev/sr0 $ISO"
echo ""
