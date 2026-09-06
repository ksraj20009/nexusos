#!/bin/bash
# Vajra OS VM Image Creation
# Creates a QEMU/VirtualBox compatible image
set -e
echo "=== Vajra OS VM Image Creator ==="
echo "  1. Create QEMU image (qcow2)"
echo "  2. Create VirtualBox image (vdi)"
echo "  3. Create VMware image (vmdk)"
echo "  4. Run in QEMU"
echo "  5. Exit"
read -p "Choice: " choice
case "$choice" in
    1) read -p "ISO file: " iso; read -p "Output name: " out
       qemu-img create -f qcow2 "$out.qcow2" 20G
       qemu-system-x86_64 -m 4096 -smp 2 -hda "$out.qcow2" -cdrom "$iso" -boot d
       echo "[+] QEMU image created: $out.qcow2" ;;
    2) read -p "ISO file: " iso; read -p "Output name: " out
       VBoxManage createhd --filename "$out.vdi" --size 20480
       echo "[+] VirtualBox image created: $out.vdi"
       echo "    Attach ISO and install in VirtualBox" ;;
    3) read -p "ISO file: " iso; read -p "Output name: " out
       qemu-img create -f vmdk "$out.vmdk" 20G
       echo "[+] VMware image created: $out.vmdk" ;;
    4) read -p "Image file: " img
       qemu-system-x86_64 -m 4096 -smp 2 -hda "$img" -boot c -net nic -net user
       ;;
    5) exit 0 ;;
esac