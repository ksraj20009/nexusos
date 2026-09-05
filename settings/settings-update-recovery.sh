#!/bin/bash
# Vajra OS — Update & Recovery Settings
set -e
echo "◆ Vajra OS — Update & Recovery Settings Setup"
SD_DIR="/opt/vajra/settings"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/settings-update-recovery.sh" << 'UR'
#!/bin/bash
case "${1:-status}" in
    status)
        echo "  Vajra OS - Update & Recovery"
        echo "  System: Vajra OS 1.0"
        echo "  Kernel: $(uname -r)"
        echo "  Uptime: $(uptime -p 2>/dev/null || echo 'unknown')"
        echo "  Updates Available: $(apt list --upgradable 2>/dev/null | grep -c upgradable)"
        echo "  Auto-update: $(crontab -l 2>/dev/null | grep -q vajra-update && echo 'scheduled' || echo 'manual')"
        echo "  Restore points: $(ls /var/backups/vajra/restore-points/ 2>/dev/null | wc -l)"
        echo "  Last backup: $(ls -t /var/backups/vajra/*.tar.gz 2>/dev/null | head -1 || echo 'none')"
        df -h / | awk 'NR==2 {print "  Disk Used: "$3" / "$2" ("$5")"}'
        ;;
    check) vajra-update check ;;
    update) vajra-update apply ;;
    auto-update) case "${2:-on}" in on) vajra-update schedule 4; echo "  ✓ Auto-update at 4 AM daily" ;; off) sudo rm -f /etc/cron.d/vajra-update; echo "  ✓ Auto-update disabled" ;; esac ;;
    history) vajra-update history ;;
    rollback) vajra-update rollback ;;
    restore-point) vajra-restore create "${2:-manual-$(date +%s)}" ;;
    restore) vajra-restore list ;;
    backup) vajra-backup "${2:-home}" ;;
    backup-list) vajra-backup list ;;
    reset)
        echo "  WARNING: This will erase all user data and settings."
        read -p "  Type 'RESET' to confirm: " confirm
        [ "$confirm" != "RESET" ] && echo "  Cancelled" && exit 0
        vajra-restore create "pre-reset"
        rm -rf /home/*/.config 2>/dev/null; rm -rf /home/*/.local 2>/dev/null
        echo "  ✓ Reset complete. Rebooting..."; sudo reboot
        ;;
    reset-soft)
        read -p "  Continue soft reset (settings only)? (y/n): " confirm
        [ "$confirm" != "y" ] && echo "  Cancelled" && exit 0
        vajra-restore create "pre-soft-reset"
        gsettings reset org.gnome.desktop.interface gtk-theme 2>/dev/null
        gsettings reset org.gnome.desktop.interface icon-theme 2>/dev/null
        gsettings reset org.gnome.desktop.interface font-name 2>/dev/null
        gsettings reset org.gnome.desktop.background picture-uri 2>/dev/null
        echo "  ✓ Settings reset to defaults"
        ;;
    clean)
        echo "  Cleaning system..."
        sudo apt-get clean 2>/dev/null; sudo apt-get autoremove -y 2>/dev/null
        rm -rf /tmp/vajra-* 2>/dev/null; rm -rf ~/.cache/thumbnails 2>/dev/null
        echo "  ✓ System cleaned"; df -h /
        ;;
    *) echo "Usage: vajra-settings recovery {status|check|update|auto-update|history|rollback|restore-point|restore|backup|reset|reset-soft|clean}" ;;
esac
UR
chmod +x "$SD_DIR/settings-update-recovery.sh"
ln -sf "$SD_DIR/settings-update-recovery.sh" /usr/local/bin/vajra-settings-recovery 2>/dev/null || true
echo "  ✓ Update & recovery settings installed"
echo "◆ Done"
