#!/bin/bash
# Vajra OS Boot Process Manager
# Manages the full boot sequence: firmware → bootloader → kernel → init → services → login
# This is the fundamental boot orchestrator — like systemd/bootctl on Linux, bootcfg on Windows
set -e

BOOT_LOG="/var/log/vajra/boot.log"
BOOT_STATE="/var/lib/vajra/boot-state"
GRUB_CONFIG="/etc/default/grub"
INITRAMFS_DIR="/boot"

mkdir -p /var/log/vajra /var/lib/vajra

show_boot_menu() {
    echo "============================================"
    echo "         VAJRA OS BOOT MANAGER"
    echo "============================================"
    echo "  1. View boot sequence status"
    echo "  2. Configure bootloader (GRUB)"
    echo "  3. Set default kernel"
    echo "  4. Set boot timeout"
    echo "  5. Enable/disable services at boot"
    echo "  6. Rebuild initramfs"
    echo "  7. View boot log"
    echo "  8. Set boot mode (UEFI/Legacy)"
    echo "  9. Create boot snapshot"
    echo "  10. Restore boot snapshot"
    echo "  11. Verify boot integrity"
    echo "  0. Exit"
    echo "============================================"
}

view_boot_status() {
    echo ""
    echo "--- Boot Sequence Status ---"
    echo ""
    echo "[1] FIRMWARE (BIOS/UEFI)"
    if [ -d /sys/firmware/efi ]; then
        echo "    Mode: UEFI"
        echo "    EFI vars: $(ls /sys/firmware/efi/efivars 2>/dev/null | wc -l) variables"
        echo "    Secure Boot: $(if [ -f /sys/firmware/efi/efivars/SecureBoot* ]; then echo "Enabled"; else echo "Disabled/Unknown"; fi)"
    else
        echo "    Mode: Legacy BIOS"
    fi
    echo ""
    echo "[2] BOOTLOADER (GRUB)"
    if [ -f /boot/grub/grub.cfg ]; then
        echo "    Installed: Yes"
        echo "    Config: /boot/grub/grub.cfg"
        echo "    Default kernel: $(grep -m1 'menuentry' /boot/grub/grub.cfg 2>/dev/null | head -1 | sed 's/.*menuentry //;s/ {.*//')"
    else
        echo "    Installed: No (WARNING: system may not boot!)"
    fi
    echo ""
    echo "[3] KERNEL"
    if [ -f /boot/vmlinuz* ]; then
        echo "    Loaded: $(ls /boot/vmlinuz-* 2>/dev/null | head -1 | sed 's|/boot/||')"
        echo "    Initramfs: $(ls /boot/initrd.img-* 2>/dev/null | head -1 | sed 's|/boot/||' || echo 'None')"
    fi
    echo ""
    echo "[4] INIT SYSTEM"
    if [ -f /sbin/init ] || [ -L /sbin/init ]; then
        echo "    Init: $(readlink -f /sbin/init 2>/dev/null || echo '/sbin/init')"
        echo "    PID 1: $(ps -p 1 -o comm= 2>/dev/null || echo 'unknown')"
    fi
    echo ""
    echo "[5] SERVICES AT BOOT"
    local enabled=$(systemctl list-unit-files --state=enabled --type=service 2>/dev/null | grep -c enabled || echo "0")
    echo "    Enabled services: $enabled"
    echo ""
    echo "[6] LOGIN MANAGER"
    if systemctl is-active gdm 2>/dev/null | grep -q active; then
        echo "    Display manager: GDM (active)"
    elif systemctl is-active lightdm 2>/dev/null | grep -q active; then
        echo "    Display manager: LightDM (active)"
    elif systemctl is-active sddm 2>/dev/null | grep -q active; then
        echo "    Display manager: SDDM (active)"
    else
        echo "    Display manager: None (TTY login only)"
    fi
    echo ""
    echo "[7] BOOT TIME"
    echo "    Last boot: $(uptime -s 2>/dev/null || echo 'unknown')"
    echo "    Uptime: $(uptime -p 2>/dev/null || echo 'unknown')"
    echo ""
}

configure_grub() {
    echo ""
    echo "--- GRUB Configuration ---"
    if [ ! -f "$GRUB_CONFIG" ]; then
        echo "[-] GRUB config not found at $GRUB_CONFIG"
        return
    fi
    echo "Current settings:"
    grep -E '^(GRUB_TIMEOUT|GRUB_DEFAULT|GRUB_CMDLINE_LINUX|GRUB_DISABLE_RECOVERY)' "$GRUB_CONFIG" 2>/dev/null
    echo ""
    read -p "Set boot timeout (seconds) [current: $(grep GRUB_TIMEOUT $GRUB_CONFIG | cut -d= -f2 | tr -d "'" 2>/dev/null || echo 5)]: " timeout
    if [ -n "$timeout" ]; then
        sed -i "s/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=$timeout/" "$GRUB_CONFIG"
        echo "[+] Timeout set to $timeout seconds"
    fi
    read -p "Set kernel parameters: " params
    if [ -n "$params" ]; then
        sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT=\"$params\"/" "$GRUB_CONFIG"
        echo "[+] Kernel parameters updated"
    fi
    echo ""
    echo "[*] Updating GRUB..."
    if command -v update-grub &>/dev/null; then
        update-grub 2>&1 | tail -5
    elif command -v grub-mkconfig &>/dev/null; then
        grub-mkconfig -o /boot/grub/grub.cfg 2>&1 | tail -5
    else
        echo "[-] Cannot update GRUB (update-grub/grub-mkconfig not found)"
    fi
    echo "[+] GRUB configuration complete"
}

set_default_kernel() {
    echo ""
    echo "--- Set Default Kernel ---"
    echo "Available kernels:"
    local i=1
    local kernels=()
    for k in /boot/vmlinuz-*; do
        [ -f "$k" ] || continue
        local ver=$(echo "$k" | sed 's|/boot/vmlinuz-||')
        echo "  $i. $ver"
        kernels+=("$ver")
        ((i++))
    done
    if [ ${#kernels[@]} -eq 0 ]; then
        echo "[-] No kernels found in /boot/"
        return
    fi
    read -p "Select default kernel number: " choice
    if [ -n "$choice" ] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#kernels[@]} ]; then
        local ver="${kernels[$((choice-1))]}"
        if [ -f "$GRUB_CONFIG" ]; then
            sed -i "s/GRUB_DEFAULT=.*/GRUB_DEFAULT=\"Advanced options for Vajra OS>$ver\"/" "$GRUB_CONFIG"
            echo "[+] Default kernel set to $ver"
            update-grub 2>/dev/null || grub-mkconfig -o /boot/grub/grub.cfg 2>/dev/null
        fi
    fi
}

manage_boot_services() {
    echo ""
    echo "--- Boot Services ---"
    echo "  1. List enabled services"
    echo "  2. Enable a service"
    echo "  3. Disable a service"
    echo "  4. List failed services"
    read -p "Choice: " c
    case "$c" in
        1) systemctl list-unit-files --state=enabled --type=service 2>/dev/null | head -30 ;;
        2) read -p "Service name: " svc; systemctl enable "$svc" 2>/dev/null && echo "[+] Enabled $svc" || echo "[-] Failed" ;;
        3) read -p "Service name: " svc; systemctl disable "$svc" 2>/dev/null && echo "[+] Disabled $svc" || echo "[-] Failed" ;;
        4) systemctl --failed 2>/dev/null ;;
    esac
}

rebuild_initramfs() {
    echo ""
    echo "--- Rebuild Initramfs ---"
    echo "[*] Rebuilding initramfs (this loads drivers needed at boot)..."
    if command -v update-initramfs &>/dev/null; then
        sudo update-initramfs -u -k all 2>&1 | tail -5
        echo "[+] Initramfs rebuilt successfully"
    elif command -v dracut &>/dev/null; then
        sudo dracut --force 2>&1 | tail -5
        echo "[+] Initramfs rebuilt with dracut"
    else
        echo "[-] No initramfs tool found (update-initramfs/dracut)"
    fi
}

create_boot_snapshot() {
    echo ""
    echo "--- Create Boot Snapshot ---"
    local snapshot_dir="/var/lib/vajra/boot-snapshots"
    mkdir -p "$snapshot_dir"
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local snap="$snapshot_dir/boot-$timestamp"
    mkdir -p "$snap"
    cp "$GRUB_CONFIG" "$snap/" 2>/dev/null || true
    cp /boot/grub/grub.cfg "$snap/" 2>/dev/null || true
    systemctl list-unit-files --state=enabled > "$snap/enabled-services.txt" 2>/dev/null
    ls /boot/vmlinuz-* > "$snap/kernels.txt" 2>/dev/null
    echo "[+] Boot snapshot saved: $snap"
}

restore_boot_snapshot() {
    echo ""
    echo "--- Restore Boot Snapshot ---"
    local snapshot_dir="/var/lib/vajra/boot-snapshots"
    if [ ! -d "$snapshot_dir" ]; then
        echo "[-] No snapshots found"
        return
    fi
    echo "Available snapshots:"
    local i=1
    local snaps=()
    for s in "$snapshot_dir"/boot-*; do
        [ -d "$s" ] || continue
        echo "  $i. $(basename $s)"
        snaps+=("$s")
        ((i++))
    done
    read -p "Select snapshot: " choice
    if [ -n "$choice" ] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#snaps[@]} ]; then
        local snap="${snaps[$((choice-1))]}"
        cp "$snap/grub" "$GRUB_CONFIG" 2>/dev/null || true
        cp "$snap/grub.cfg" /boot/grub/grub.cfg 2>/dev/null || true
        echo "[+] Boot configuration restored from $snap"
        echo "[*] Run 'Update GRUB' to apply changes"
    fi
}

verify_boot_integrity() {
    echo ""
    echo "--- Boot Integrity Check ---"
    local issues=0
    echo "[1] Checking bootloader..."
    [ -f /boot/grub/grub.cfg ] && echo "    OK: GRUB config exists" || { echo "    FAIL: GRUB config missing"; ((issues++)); }
    echo "[2] Checking kernel..."
    [ -f /boot/vmlinuz-* ] && echo "    OK: Kernel image exists" || { echo "    FAIL: No kernel found"; ((issues++)); }
    echo "[3] Checking initramfs..."
    [ -f /boot/initrd.img-* ] && echo "    OK: Initramfs exists" || { echo "    WARN: No initramfs (may cause boot issues)"; ((issues++)); }
    echo "[4] Checking init system..."
    [ -f /sbin/init ] || [ -L /sbin/init ] && echo "    OK: Init exists" || { echo "    FAIL: No init system"; ((issues++)); }
    echo "[5] Checking root filesystem..."
    [ -f /etc/fstab ] && echo "    OK: fstab exists" || { echo "    WARN: No fstab"; ((issues++)); }
    echo "[6] Checking EFI..."
    if [ -d /sys/firmware/efi ]; then
        [ -d /boot/efi ] && echo "    OK: EFI partition mounted" || { echo "    WARN: EFI partition not mounted"; ((issues++)); }
    fi
    echo ""
    if [ "$issues" -eq 0 ]; then
        echo "[+] Boot integrity: ALL CHECKS PASSED"
    else
        echo "[-] Boot integrity: $issues issue(s) found"
    fi
}

main() {
    while true; do
        show_boot_menu
        read -p "  Choice: " choice
        case "$choice" in
            1) view_boot_status ;;
            2) configure_grub ;;
            3) set_default_kernel ;;
            4) echo ""; read -p "Timeout (seconds): " t; sed -i "s/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=$t/" "$GRUB_CONFIG" 2>/dev/null; update-grub 2>/dev/null; echo "[+] Done" ;;
            5) manage_boot_services ;;
            6) rebuild_initramfs ;;
            7) less "$BOOT_LOG" 2>/dev/null || echo "No boot log found" ;;
            8) if [ -d /sys/firmware/efi ]; then echo "Current: UEFI"; else echo "Current: Legacy BIOS"; fi ;;
            9) create_boot_snapshot ;;
            10) restore_boot_snapshot ;;
            11) verify_boot_integrity ;;
            0) break ;;
            *) echo "Invalid choice" ;;
        esac
    done
}

main
