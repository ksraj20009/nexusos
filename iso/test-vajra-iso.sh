#!/bin/bash
# Vajra OS QEMU Test Script
# Tests the Vajra OS ISO in QEMU virtual machine
#
# Usage:
#   ./test-vajra-iso.sh [path-to-iso]
#
# Requirements:
#   sudo apt install qemu-system-x86 ovmf  (for UEFI test)
#
# This script tests both BIOS and UEFI boot modes.

set -e

ISO="${1:-vajra-os-1.0-amd64.iso}"
RAM="${RAM:-512}"

echo ""
echo "  =================================================="
echo "  |    VAJRA OS QEMU Test Script                   |"
echo "  |    India's Privacy-First AI-Powered OS         |"
echo "  =================================================="
echo ""

if [ ! -f "$ISO" ]; then
    echo "  [ERROR] ISO file not found: $ISO"
    echo "  Usage: $0 [path-to-iso]"
    exit 1
fi

echo "  ISO: $ISO ($(du -h "$ISO" | cut -f1))"
echo "  RAM: ${RAM}MB"
echo ""

# Check if QEMU is installed
if ! command -v qemu-system-x86_64 &>/dev/null; then
    echo "  [ERROR] QEMU not installed."
    echo "  Install: sudo apt install qemu-system-x86"
    exit 1
fi

# Menu
echo "  Select boot mode:"
echo "    1. BIOS boot (default, works on older PCs)"
echo "    2. UEFI boot (modern PCs, needs OVMF)"
echo "    3. BIOS boot with serial console (for headless)"
echo "    4. BIOS boot with more RAM (2GB, for testing apps)"
echo ""
read -p "  Choice [1-4, default=1]: " choice
choice=${choice:-1}

case $choice in
    1)
        echo ""
        echo "  [*] Starting QEMU (BIOS mode, ${RAM}MB RAM)..."
        echo "  [*] Press Ctrl+A then X to exit QEMU"
        echo ""
        qemu-system-x86_64 \
            -cdrom "$ISO" \
            -m "$RAM" \
            -boot d \
            -netdev user,id=net0 -device e1000,netdev=net0 \
            -display gtk
        ;;
    2)
        # Check for OVMF
        OVMF=""
        for path in /usr/share/OVMF/OVMF_CODE.fd /usr/share/ovmf/OVMF.fd /usr/share/edk2/ovmf/OVMF_CODE.fd; do
            if [ -f "$path" ]; then
                OVMF="$path"
                break
            fi
        done
        if [ -z "$OVMF" ]; then
            echo "  [ERROR] OVMF not found. Install: sudo apt install ovmf"
            exit 1
        fi
        echo ""
        echo "  [*] Starting QEMU (UEFI mode, ${RAM}MB RAM)..."
        echo "  [*] OVMF: $OVMF"
        echo "  [*] Press Ctrl+A then X to exit QEMU"
        echo ""
        qemu-system-x86_64 \
            -cdrom "$ISO" \
            -m "$RAM" \
            -boot d \
            -bios "$OVMF" \
            -netdev user,id=net0 -device e1000,netdev=net0 \
            -display gtk
        ;;
    3)
        echo ""
        echo "  [*] Starting QEMU (BIOS + serial, ${RAM}MB RAM)..."
        echo "  [*] Serial console will be in this terminal"
        echo ""
        qemu-system-x86_64 \
            -cdrom "$ISO" \
            -m "$RAM" \
            -boot d \
            -serial mon:stdio \
            -nographic
        ;;
    4)
        echo ""
        echo "  [*] Starting QEMU (BIOS mode, 2048MB RAM)..."
        echo "  [*] Press Ctrl+A then X to exit QEMU"
        echo ""
        qemu-system-x86_64 \
            -cdrom "$ISO" \
            -m 2048 \
            -boot d \
            -netdev user,id=net0 -device e1000,netdev=net0 \
            -display gtk \
            -cpu host -enable-kvm 2>/dev/null || \
        qemu-system-x86_64 \
            -cdrom "$ISO" \
            -m 2048 \
            -boot d \
            -netdev user,id=net0 -device e1000,netdev=net0 \
            -display gtk
        ;;
    *)
        echo "  Invalid choice"
        exit 1
        ;;
esac

echo ""
echo "  QEMU exited."
echo ""
