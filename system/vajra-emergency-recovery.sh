#!/bin/bash
# Vajra OS — Emergency Recovery
case "${1:-menu}" in
    menu)
        echo "  Vajra OS - Emergency Recovery"
        echo "  [1] System won't boot [2] Recover lost data [3] Reset password"
        echo "  [4] Fix broken packages [5] Restore from backup [6] Repair GRUB"
        echo "  [7] System scan [8] Create recovery USB [9] Safe mode"
        read -p "  Choose (1-9): " c
        case "$c" in 1) vajra-emergency-recovery no-boot ;; 2) vajra-emergency-recovery data ;; 3) vajra-emergency-recovery password ;; 4) vajra-emergency-recovery packages ;; 5) vajra-emergency-recovery restore ;; 6) vajra-emergency-recovery grub ;; 7) vajra-emergency-recovery scan ;; 8) vajra-emergency-recovery usb ;; 9) vajra-emergency-recovery safe ;; esac
        ;;
    no-boot) echo "  1. Try Recovery Mode: Reboot > Advanced > Recovery"; echo "  2. Boot from Vajra USB"; echo "  3. Fix GRUB: vajra-emergency-recovery grub"; echo "  4. Check disk: sudo fsck /dev/sda1" ;;
    data) echo "  1. Stop using disk immediately!"; echo "  2. Boot from Vajra USB"; echo "  3. vajra-forensics file-carve /dev/sdX /tmp/recovered"; echo "  4. Or: sudo photorec /dev/sdX" ;;
    password) echo "  1. Reboot > press 'e' at boot menu"; echo "  2. Add 'init=/bin/bash' to linux line"; echo "  3. Ctrl+X to boot"; echo "  4. mount -o remount,rw /"; echo "  5. passwd <username>"; echo "  6. reboot -f" ;;
    packages) sudo dpkg --configure -a; sudo apt-get --fix-broken install; sudo apt-get update; echo "  Done." ;;
    restore) vajra-backup list; echo "  Run: vajra-restore restore <backup-name>" ;;
    grub) echo "  Boot from Vajra USB, then:"; echo "  1. sudo mount /dev/sdXN /mnt"; echo "  2. sudo grub-install --root-directory=/mnt /dev/sdX"; echo "  3. sudo update-grub" ;;
    scan) echo "  Scanning for malware..."; sudo clamscan -r /home 2>/dev/null || echo "  Install: sudo apt-get install clamav"; echo "  Scanning for rootkits..."; sudo rkhunter --check 2>/dev/null || echo "  Install: sudo apt-get install rkhunter" ;;
    usb) echo "  1. Insert USB (8GB+)"; echo "  2. Find device: lsblk"; echo "  3. Flash: sudo dd if=vajra-os.iso of=/dev/sdX bs=4M status=progress" ;;
    safe) echo "  1. Reboot"; echo "  2. Select 'Advanced Options'"; echo "  3. Select 'Recovery Mode'"; echo "  4. Choose: fsck, root, or dpkg" ;;
    help|*) echo "  Run: vajra-emergency-recovery menu" ;;
esac
