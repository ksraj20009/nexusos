#!/bin/bash
# Vajra OS — System Restore
# Create and restore system restore points
set -e

echo "◆ Vajra OS — System Restore Setup"

SR_DIR="/opt/vajra/restore"
mkdir -p "$SR_DIR"

cat > "$SR_DIR/system-restore.sh" << 'SR'
#!/bin/bash
RESTORE_DIR="/var/backups/vajra/restore-points"
mkdir -p "$RESTORE_DIR"

case "${1:-list}" in
    create)
        NAME="${2:-restore-$(date +%Y%m%d-%H%M%S)}"
        POINT_DIR="$RESTORE_DIR/$NAME"
        mkdir -p "$POINT_DIR"
        echo "◆ Creating restore point: $NAME"
        tar czf "$POINT_DIR/config.tar.gz" /etc/fstab /etc/hostname /etc/hosts \
            /etc/network/ /etc/systemd/system/ /etc/ssh/sshd_config /etc/ufw/ \
            /etc/crontab /etc/cron.d/ /opt/vajra/ 2>/dev/null || true
        dpkg --get-selections > "$POINT_DIR/packages.list" 2>/dev/null
        pip3 freeze > "$POINT_DIR/pip-packages.list" 2>/dev/null
        if command -v gsettings &>/dev/null; then
            gsettings list-recursively > "$POINT_DIR/gnome-settings.conf" 2>/dev/null
        fi
        tar czf "$POINT_DIR/user-config.tar.gz" -C "$HOME" .config .local/bin .bashrc .profile 2>/dev/null || true
        echo "  ✓ Restore point created: $NAME"
        ;;
    list)
        echo "◆ Available Restore Points:"
        if [ -d "$RESTORE_DIR" ] && ls "$RESTORE_DIR" | grep -q .; then
            for d in "$RESTORE_DIR"/*/; do
                [ -d "$d" ] || continue
                NAME=$(basename "$d")
                SIZE=$(du -sh "$d" 2>/dev/null | awk '{print $1}')
                echo "  ● $NAME  ($SIZE)"
            done
        else
            echo "  No restore points found. Create one: vajra-restore create"
        fi
        ;;
    restore)
        NAME="$2"; POINT_DIR="$RESTORE_DIR/$NAME"
        [ ! -d "$POINT_DIR" ] && echo "  ✗ Not found: $NAME" && exit 1
        echo "◆ Restoring from: $NAME"
        read -p "  Continue? (y/n): " confirm
        [ "$confirm" != "y" ] && echo "  Cancelled" && exit 0
        [ -f "$POINT_DIR/config.tar.gz" ] && tar xzf "$POINT_DIR/config.tar.gz" -C / 2>/dev/null && echo "  ✓ System config restored"
        [ -f "$POINT_DIR/user-config.tar.gz" ] && tar xzf "$POINT_DIR/user-config.tar.gz" -C "$HOME" 2>/dev/null && echo "  ✓ User config restored"
        echo "  ✓ Restore complete! Reboot recommended."
        ;;
    delete)
        rm -rf "$RESTORE_DIR/$2"
        echo "  ✓ Deleted: $2"
        ;;
    *) echo "Usage: vajra-restore {create [name]|list|restore <name>|delete <name>}" ;;
esac
SR
chmod +x "$SR_DIR/system-restore.sh"
ln -sf "$SR_DIR/system-restore.sh" /usr/local/bin/vajra-restore 2>/dev/null || true

echo "  ✓ System restore installed"
echo "  ◆ Usage: vajra-restore {create|list|restore|delete}"
echo "◆ Done"
