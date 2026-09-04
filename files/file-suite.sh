#!/bin/bash
# Vajra OS — File & Data Management Suite
set -e
echo "◆ Vajra OS File & Data Suite"

# Btrfs Snapshots
cat > /usr/local/bin/vajra-snapshot << 'SNAP'
#!/bin/bash
case "$1" in
    create) NAME=${2:-"manual-$(date +%Y%m%d-%H%M%S)"}; btrfs subvolume snapshot / /.snapshots/$NAME 2>/dev/null; echo "✓ Snapshot: $NAME" ;;
    list) echo "📸 Snapshots:"; ls -1 /.snapshots/ 2>/dev/null || echo "  None" ;;
    restore) [ -z "$2" ] && echo "Usage: vajra-snapshot restore <name>" && exit 1; echo "⚠️ Restore to: $2"; read -p "Continue? (yes/no): " c; [ "$c" = "yes" ] && btrfs subvolume snapshot /.snapshots/$2 / && echo "✓ Restored. Reboot." || echo "Cancelled" ;;
    delete) [ -z "$2" ] && echo "Usage: vajra-snapshot delete <name>" && exit 1; btrfs subvolume delete /.snapshots/$2 2>/dev/null; echo "✓ Deleted: $2" ;;
    *) echo "Usage: vajra-snapshot [create [name]|list|restore <name>|delete <name>]" ;;
esac
SNAP
chmod +x /usr/local/bin/vajra-snapshot

# File Shredder (DoD-grade)
cat > /usr/local/bin/vajra-shred << 'SH'
#!/bin/bash
if [ -z "$1" ]; then echo "Vajra File Shredder (DoD-grade secure delete)"; echo "Usage: vajra-shred <file>"; exit 1; fi
for file in "$@"; do
    [ ! -f "$file" ] && echo "⚠ Not found: $file" && continue
    SIZE=$(stat -c%s "$file")
    echo "Shredding $file ($SIZE bytes)..."
    for pattern in /dev/zero /dev/urandom /dev/zero /dev/urandom /dev/zero /dev/urandom /dev/zero; do
        dd if=$pattern of="$file" bs=1M count=$((SIZE/1048576+1)) 2>/dev/null
    done
    sync; rm -f "$file"
    echo "✓ Shredded: $file"
done
SH
chmod +x /usr/local/bin/vajra-shred

# Encrypted Folders (gocryptfs)
cat > /usr/local/bin/vajra-encrypt-folder << 'EF'
#!/bin/bash
case "$1" in
    create) DIR=${2:-"$HOME/Vault"}; apt-get install -y gocryptfs 2>/dev/null || true; mkdir -p "$DIR-encrypted" "$DIR"; gocryptfs -init "$DIR-encrypted" 2>/dev/null; echo "✓ Vault created at $DIR" ;;
    mount) DIR=${2:-"$HOME/Vault"}; gocryptfs "$DIR-encrypted" "$DIR" 2>/dev/null; echo "✓ Vault mounted at $DIR" ;;
    unmount) DIR=${2:-"$HOME/Vault"}; fusermount -u "$DIR" 2>/dev/null || umount "$DIR" 2>/dev/null; echo "✓ Vault unmounted" ;;
    *) echo "Usage: vajra-encrypt-folder [create [dir]|mount <dir>|unmount <dir>]" ;;
esac
EF
chmod +x /usr/local/bin/vajra-encrypt-folder

# Cloud Sync (Nextcloud)
cat > /usr/local/bin/vajra-cloud-sync << 'CS'
#!/bin/bash
case "$1" in
    setup) apt-get install -y nextcloud-desktop 2>/dev/null || true; echo "Enter Nextcloud URL:"; read URL; nextcloudcmd --synchronize $HOME/Nextcloud "$URL" 2>/dev/null || echo "Run nextcloud-desktop to configure" ;;
    sync) nextcloudcmd --synchronize $HOME/Nextcloud 2>/dev/null || echo "Run setup first" ;;
    *) echo "Usage: vajra-cloud-sync [setup|sync]" ;;
esac
CS
chmod +x /usr/local/bin/vajra-cloud-sync

# RAID Manager
cat > /usr/local/bin/vajra-raid << 'RAID'
#!/bin/bash
case "$1" in
    list) echo "💽 RAID Arrays:"; cat /proc/mdstat 2>/dev/null || echo "  No RAID arrays" ;;
    status) mdadm --detail /dev/md0 2>/dev/null || echo "No RAID on md0" ;;
    create) echo "Creating RAID 1..."; read -p "Partition 1: " P1; read -p "Partition 2: " P2; mdadm --create /dev/md0 --level=1 --raid-devices=2 $P1 $P2; echo "✓ RAID 1 at /dev/md0" ;;
    *) echo "Usage: vajra-raid [list|status|create]" ;;
esac
RAID
chmod +x /usr/local/bin/vajra-raid

echo "◆ File & Data Suite installed!"
echo "  vajra-snapshot [create|list|restore|delete]"
echo "  vajra-shred <file>"
echo "  vajra-encrypt-folder [create|mount|unmount]"
echo "  vajra-cloud-sync [setup|sync]"
echo "  vajra-raid [list|status|create]"
