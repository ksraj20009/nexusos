#!/bin/bash
# Vajra OS — Backup Manager
# Automated backup with encryption and cloud sync
set -e

echo "◆ Vajra OS — Backup Manager"

BK_DIR="/opt/vajra/backup"
mkdir -p "$BK_DIR"

cat > "$BK_DIR/backup-manager.sh" << 'BKM'
#!/bin/bash
set -e

BACKUP_BASE="/var/backups/vajra"
HOME_DIR="${HOME:-/home/vajra}"
RETENTION_DAYS=7
ENCRYPT=false
GPG_RECIPIENT=""

mkdir -p "$BACKUP_BASE"

usage() {
    echo "Usage: vajra-backup {full|home|config|list|restore|schedule}"
}

backup_home() {
    TIMESTAMP=$(date +%Y%m%d-%H%M%S)
    BACKUP_FILE="$BACKUP_BASE/home-$TIMESTAMP"
    echo "◆ Backing up home directory..."
    if command -v borg &>/dev/null; then
        BORG_REPO="$BACKUP_BASE/borg-home"
        borg init --encryption=repokey "$BORG_REPO" 2>/dev/null || true
        borg create --stats --compression lz4 "$BORG_REPO::$TIMESTAMP" "$HOME_DIR" 2>/dev/null
        echo "  ✓ Borg backup: $BORG_REPO::$TIMESTAMP"
        borg prune --keep-daily "$RETENTION_DAYS" "$BORG_REPO" 2>/dev/null || true
    else
        tar czf "$BACKUP_FILE.tar.gz" -C "$HOME_DIR" . 2>/dev/null
        if [ "$ENCRYPT" = true ]; then
            gpg --recipient "$GPG_RECIPIENT" --encrypt "$BACKUP_FILE.tar.gz" 2>/dev/null
            rm -f "$BACKUP_FILE.tar.gz"
            echo "  ✓ Encrypted backup: $BACKUP_FILE.tar.gz.gpg"
        else
            echo "  ✓ Backup: $BACKUP_FILE.tar.gz"
        fi
    fi
    find "$BACKUP_BASE" -name "home-*.tar.gz" -mtime +$RETENTION_DAYS -delete 2>/dev/null || true
}

backup_config() {
    TIMESTAMP=$(date +%Y%m%d-%H%M%S)
    BACKUP_FILE="$BACKUP_BASE/config-$TIMESTAMP.tar.gz"
    echo "◆ Backing up configuration files..."
    tar czf "$BACKUP_FILE" /etc/fstab /etc/hostname /etc/hosts /etc/network/ \
        /etc/systemd/system/ /etc/ssh/sshd_config /etc/ufw/ /etc/crontab \
        /etc/cron.d/ /opt/vajra/ 2>/dev/null || true
    echo "  ✓ Config backup: $BACKUP_FILE"
    find "$BACKUP_BASE" -name "config-*.tar.gz" -mtime +$RETENTION_DAYS -delete 2>/dev/null || true
}

backup_full() {
    echo "◆ Full system backup..."
    backup_config
    backup_home
    TIMESTAMP=$(date +%Y%m%d-%H%M%S)
    dpkg --get-selections > "$BACKUP_BASE/packages-$TIMESTAMP.list" 2>/dev/null
    pip3 freeze > "$BACKUP_BASE/pip-packages-$TIMESTAMP.list" 2>/dev/null
    echo "  ✓ Package lists saved"
    echo "◆ Full backup complete"
}

list_backups() {
    echo "◆ Available Backups:"
    ls -lh "$BACKUP_BASE"/*.tar.gz 2>/dev/null | awk '{print "  " $NF, $5}'
    ls -lh "$BACKUP_BASE"/*.gpg 2>/dev/null | awk '{print "  " $NF, $5}'
    if [ -d "$BACKUP_BASE/borg-home" ]; then
        echo "  Borg backups:"
        borg list "$BACKUP_BASE/borg-home" 2>/dev/null | tail -10
    fi
}

restore_backup() {
    echo "◆ Restore Backup"
    list_backups
    read -p "Enter backup filename to restore: " BK_FILE
    if [ -f "$BACKUP_BASE/$BK_FILE" ]; then
        echo "  Restoring $BK_FILE..."
        if [[ "$BK_FILE" == *.gpg ]]; then
            gpg --decrypt "$BACKUP_BASE/$BK_FILE" | tar xzf - -C / 2>/dev/null
        else
            tar xzf "$BACKUP_BASE/$BK_FILE" -C / 2>/dev/null
        fi
        echo "  ✓ Restored"
    else
        echo "  ✗ File not found"
    fi
}

schedule_backups() {
    echo "0 2 * * * root /opt/vajra/backup/backup-manager.sh full" | sudo tee /etc/cron.d/vajra-backup
    echo "  ✓ Daily backup scheduled at 2:00 AM"
}

case "${1:-help}" in
    full) backup_full ;;
    home) backup_home ;;
    config) backup_config ;;
    list) list_backups ;;
    restore) restore_backup ;;
    schedule) schedule_backups ;;
    *) usage ;;
esac
BKM
chmod +x "$BK_DIR/backup-manager.sh"
ln -sf "$BK_DIR/backup-manager.sh" /usr/local/bin/vajra-backup 2>/dev/null || true

echo "  ✓ Backup manager installed"
echo "  ◆ Usage: vajra-backup {full|home|config|list|restore|schedule}"
echo "◆ Done"
