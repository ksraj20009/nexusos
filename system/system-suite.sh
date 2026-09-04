#!/bin/bash
# Vajra OS — System Management Suite
set -e
echo "◆ Vajra OS System Management Suite"

# System Restore Points
cat > /usr/local/bin/vajra-restore << 'SR'
#!/bin/bash
case "$1" in
    create)
        LABEL=${2:-"restore-$(date +%Y%m%d-%H%M%S)"}
        if command -v btrfs &>/dev/null; then
            btrfs subvolume snapshot -r / /.snapshots/$LABEL 2>/dev/null || true
            echo "✓ Restore point created: $LABEL"
        else
            mkdir -p /var/vajra-restore
            tar czf /var/vajra-restore/$LABEL.tar.gz --exclude=/proc --exclude=/sys --exclude=/dev / 2>/dev/null || true
            echo "✓ Restore point (tar): /var/vajra-restore/$LABEL.tar.gz"
        fi
        ;;
    list)
        echo "📸 Restore Points:"
        ls -1 /.snapshots/ 2>/dev/null || ls -1 /var/vajra-restore/ 2>/dev/null || echo "  No restore points"
        ;;
    restore)
        [ -z "$2" ] && echo "Usage: vajra-restore restore <name>" && exit 1
        echo "⚠️ This will restore system to: $2"
        read -p "Continue? (yes/no): " confirm
        [ "$confirm" = "yes" ] && btrfs subvolume snapshot /.snapshots/$2 / 2>/dev/null && echo "✓ Restored. Reboot now." || echo "Cancelled"
        ;;
    *)
        echo "Vajra System Restore"
        echo "Usage: vajra-restore [create [name]|list|restore <name>]"
        ;;
esac
SR
chmod +x /usr/local/bin/vajra-restore

# Disk Usage Analyzer
cat > /usr/local/bin/vajra-disk-analyzer << 'DA'
#!/bin/bash
echo "◆ Vajra Disk Usage Analyzer"
echo "============================"
echo ""
echo "Disk overview:"
df -h / /home /tmp /var 2>/dev/null | head -10
echo ""
echo "Top 20 largest directories:"
du -hx / 2>/dev/null | sort -rh | head -20
echo ""
echo "Top 20 largest files:"
find / -type f -xdev -exec du -h {} + 2>/dev/null | sort -rh | head -20
echo ""
echo "◆ AI Suggestion:"
LARGE_CACHE=$(du -sh /var/cache/ 2>/dev/null | cut -f1)
LARGE_LOG=$(du -sh /var/log/ 2>/dev/null | cut -f1)
LARGE_TMP=$(du -sh /tmp/ 2>/dev/null | cut -f1)
echo "  Cache: $LARGE_CACHE — Run 'sudo apt clean' to free"
echo "  Logs: $LARGE_LOG — Run 'sudo journalctl --vacuum-time=7d' to trim"
echo "  Temp: $LARGE_TMP — Run 'sudo rm -rf /tmp/*' to free"
DA
chmod +x /usr/local/bin/vajra-disk-analyzer

# Driver Manager
cat > /usr/local/bin/vajra-drivers << 'DR'
#!/bin/bash
echo "◆ Vajra Driver Manager"
echo "======================"
echo ""
echo "Detected hardware:"
lspci -nn | grep -iE "vga|network|audio|usb" 2>/dev/null
echo ""
echo "Loaded kernel modules:"
lsmod | grep -iE "nvidia|amdgpu|radeon|i915|iwl|ath|rtl|rtw|brcm|ath10k|ath11k|mt76" 2>/dev/null
echo ""
echo "Missing firmware:"
dmesg 2>/dev/null | grep -i "firmware" | grep -i "not found\|failed\|error" | head -10
echo ""
echo "Graphics drivers:"
if lspci | grep -q "NVIDIA"; then
    echo "  NVIDIA GPU detected — Install: sudo apt install nvidia-driver"
elif lspci | grep -q "AMD"; then
    echo "  AMD GPU detected — Driver: amdgpu (pre-installed)"
elif lspci | grep -q "Intel"; then
    echo "  Intel GPU detected — Driver: i915 (pre-installed)"
fi
echo ""
echo "Network drivers:"
lspci | grep -i "network\|ethernet\|wireless" | while read line; do
    echo "  $line"
done
DR
chmod +x /usr/local/bin/vajra-drivers

# Recovery Mode
cat > /usr/local/bin/vajra-recovery << 'RM'
#!/bin/bash
echo "◆ Vajra Recovery Mode"
echo "===================="
echo "Choose recovery option:"
echo "  1. Fix broken packages"
echo "  2. Reinstall GRUB bootloader"
echo "  3. Reset GNOME settings"
echo "  4. Clear lost root password"
echo "  5. Repair filesystem"
echo "  6. Restore from snapshot"
read -p "Option (1-6): " opt
case $opt in
    1) sudo dpkg --configure -a && sudo apt --fix-broken install && echo "✓ Packages fixed" ;;
    2) sudo grub-install /dev/sda 2>/dev/null && sudo update-grub && echo "✓ GRUB reinstalled" ;;
    3) sudo -u vajra rm -rf ~/.config/dconf ~/.local/share/gnome-shell/extensions 2>/dev/null && echo "✓ GNOME settings reset" ;;
    4) sudo passwd root && echo "✓ Root password reset" ;;
    5) sudo fsck -Af -y 2>/dev/null && echo "✓ Filesystem checked" ;;
    6) vajra-restore list && read -p "Snapshot name: " snap && vajra-restore restore "$snap" ;;
    *) echo "Invalid option" ;;
esac
RM
chmod +x /usr/local/bin/vajra-recovery

# Service Manager
cat > /usr/local/bin/vajra-services << 'SV'
#!/bin/bash
case "$1" in
    list) echo "◆ Vajra Services"; systemctl list-units --type=service --state=running --no-pager | head -30 ;;
    failed) systemctl --failed --no-pager ;;
    start) [ -z "$2" ] && echo "Usage: vajra-services start <name>" && exit 1; sudo systemctl start "$2" && echo "✓ Started $2" ;;
    stop) [ -z "$2" ] && echo "Usage: vajra-services stop <name>" && exit 1; sudo systemctl stop "$2" && echo "✓ Stopped $2" ;;
    restart) [ -z "$2" ] && echo "Usage: vajra-services restart <name>" && exit 1; sudo systemctl restart "$2" && echo "✓ Restarted $2" ;;
    enable) [ -z "$2" ] && echo "Usage: vajra-services enable <name>" && exit 1; sudo systemctl enable "$2" && echo "✓ Enabled $2" ;;
    disable) [ -z "$2" ] && echo "Usage: vajra-services disable <name>" && exit 1; sudo systemctl disable "$2" && echo "✓ Disabled $2" ;;
    *) echo "Usage: vajra-services [list|failed|start|stop|restart|enable|disable <name>]" ;;
esac
SV
chmod +x /usr/local/bin/vajra-services

echo "◆ System Management Suite installed!"
echo "  vajra-restore [create|list|restore]"
echo "  vajra-disk-analyzer"
echo "  vajra-drivers"
echo "  vajra-recovery"
echo "  vajra-services [list|start|stop|restart]"
