#!/bin/bash
# Vajra OS — Smart Update Manager
# Handles system updates with rollback support
set -e

echo "◆ Vajra OS — Smart Update Manager"

UPDATE_DIR="/opt/vajra/updates"
mkdir -p "$UPDATE_DIR"

cat > "$UPDATE_DIR/update-manager.sh" << 'MGR'
#!/bin/bash
set -e

LOG="/var/log/vajra-update.log"
SNAPSHOT_BEFORE=true

log() {
    echo "[$(date '+%H:%M:%S')] $1" | tee -a "$LOG"
}

case "${1:-check}" in
    check)
        echo "◆ Checking for updates..."
        sudo apt-get update -qq 2>/dev/null
        COUNT=$(apt list --upgradable 2>/dev/null | grep -c upgradable)
        if [ "$COUNT" -gt 0 ]; then
            echo "  ⚠ $COUNT updates available:"
            apt list --upgradable 2>/dev/null | grep upgradable | head -20
        else
            echo "  ✓ System is up to date"
        fi
        ;;
    apply|update)
        log "Starting update process"
        if [ "$SNAPSHOT_BEFORE" = true ] && findmnt -t btrfs / -o FSTYPE | grep -q btrfs; then
            SNAP_NAME="pre-update-$(date +%Y%m%d-%H%M%S)"
            log "Creating Btrfs snapshot: $SNAP_NAME"
            sudo btrfs subvolume snapshot / "/.snapshots/$SNAP_NAME" 2>/dev/null || \
                log "Snapshot skipped"
        fi
        log "Updating package lists"
        sudo apt-get update -qq
        log "Upgrading packages"
        sudo apt-get upgrade -y
        log "Removing unused packages"
        sudo apt-get autoremove -y
        log "Cleaning cache"
        sudo apt-get clean
        log "Update complete"
        echo "◆ Updates applied successfully"
        ;;
    rollback)
        echo "◆ Available snapshots:"
        if [ -d /.snapshots ]; then
            ls -1 /.snapshots/ 2>/dev/null | tail -5
            read -p "Enter snapshot name to rollback to: " SNAP
            if [ -d "/.snapshots/$SNAP" ]; then
                echo "  Rolling back to $SNAP..."
                sudo btrfs subvolume snapshot / "/.snapshots/failed-$(date +%Y%m%d-%H%M%S)" 2>/dev/null
                sudo btrfs subvolume snapshot "/.snapshots/$SNAP" /
                echo "  ✓ Rollback staged. Reboot to complete."
            else
                echo "  ✗ Snapshot not found"
            fi
        else
            echo "  No snapshots available"
        fi
        ;;
    history)
        echo "◆ Update History:"
        [ -f "$LOG" ] && tail -30 "$LOG" || echo "  No update history found"
        ;;
    schedule)
        HOUR="${2:-4}"
        echo "0 $HOUR * * * root /opt/vajra/updates/update-manager.sh apply" | sudo tee /etc/cron.d/vajra-update
        echo "  ✓ Auto-update scheduled for ${HOUR}:00 daily"
        ;;
    *)
        echo "Usage: vajra-update {check|apply|rollback|history|schedule [hour]}"
        ;;
esac
MGR
chmod +x "$UPDATE_DIR/update-manager.sh"
ln -sf "$UPDATE_DIR/update-manager.sh" /usr/local/bin/vajra-update 2>/dev/null || true

echo "  ✓ Update manager installed"
echo "  ◆ Usage: vajra-update {check|apply|rollback|history|schedule}"
echo "◆ Done"
