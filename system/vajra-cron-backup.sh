#!/bin/bash
# Vajra OS Cron Backup Scheduler (free, built-in rsync + cron)
set -e
echo "=== Vajra OS Cron Backup Scheduler ==="
BACKUP_DIR="/mnt/backup/vajra"
mkdir -p "$BACKUP_DIR"
echo "  1. Daily home backup (2 AM)"
echo "  2. Weekly full backup (Sunday 3 AM)"
echo "  3. Every 6 hours"
echo "  4. View scheduled backups"
echo "  5. Remove backup cron"
echo "  6. Exit"
read -p "Choice: " choice
case "$choice" in
    1) echo "0 2 * * * root rsync -aAXv $HOME/ $BACKUP_DIR/daily/" | tee /etc/cron.d/vajra-backup-daily
       echo "[+] Daily backup scheduled at 2 AM" ;;
    2) echo "0 3 * * 0 root rsync -aAXv --exclude={\"/dev/*\",\"/proc/*\",\"/sys/*\"} / $BACKUP_DIR/weekly/" | tee /etc/cron.d/vajra-backup-weekly
       echo "[+] Weekly full backup scheduled (Sunday 3 AM)" ;;
    3) echo "0 */6 * * * root rsync -aAXv $HOME/ $BACKUP_DIR/hourly/" | tee /etc/cron.d/vajra-backup-hourly
       echo "[+] Backup every 6 hours" ;;
    4) cat /etc/cron.d/vajra-backup-* 2>/dev/null || echo "No scheduled backups" ;;
    5) rm -f /etc/cron.d/vajra-backup-*; echo "[+] Backup crons removed" ;;
    6) exit 0 ;;
esac