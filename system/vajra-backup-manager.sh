#!/bin/bash
# Vajra OS Backup Manager
set -e
echo "=== Vajra OS Backup Manager ==="
echo "  1. Full system backup (rsync)"
echo "  2. Home directory backup"
echo "  3. Restore from backup"
echo "  4. Scheduled backup (cron)"
echo "  5. List backups"
echo "  6. Exit"
read -p "Choice: " choice
BACKUP_DIR="/mnt/backup/vajra"
case "$choice" in
    1) read -p "Backup destination: " dest
       mkdir -p "$dest"
       rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} / "$dest/" 2>/dev/null
       echo "[+] Full backup completed to $dest" ;;
    2) mkdir -p "$BACKUP_DIR"
       rsync -aAXv "$HOME/" "$BACKUP_DIR/home-$(date +%Y%m%d)/" 2>/dev/null
       echo "[+] Home backup completed" ;;
    3) read -p "Backup source: " src
       rsync -aAXv "$src/" "$HOME/" 2>/dev/null
       echo "[+] Restore completed" ;;
    4) echo "0 2 * * * root rsync -aAXv $HOME/ $BACKUP_DIR/home-backup/" | sudo tee /etc/cron.d/vajra-backup
       echo "[+] Daily 2AM backup scheduled" ;;
    5) ls -la "$BACKUP_DIR" 2>/dev/null || echo "No backups found" ;;
    6) exit 0 ;;
esac