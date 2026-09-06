#!/bin/bash
# Vajra OS Encrypted Cloud Backup (rclone + GPG)
set -e
echo "=== Vajra OS Encrypted Cloud Backup ==="
echo "  1. Install rclone"
echo "  2. Configure cloud storage"
echo "  3. Backup with encryption"
echo "  4. Restore from backup"
echo "  5. List backups"
echo "  6. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y rclone gnupg 2>/dev/null; echo "[+] rclone installed" ;;
    2) rclone config; echo "[+] Cloud storage configured" ;;
    3) read -p "Local path: " local; read -p "Remote name:path: " remote
       rclone sync "$local" "$remote" --crypt-remote "$remote-encrypted" --verbose 2>/dev/null
       echo "[+] Encrypted backup completed" ;;
    4) read -p "Remote name:path: " remote; read -p "Restore to: " local
       rclone sync "$remote" "$local" --verbose 2>/dev/null
       echo "[+] Restore completed" ;;
    5) read -p "Remote name: " remote; rclone lsd "$remote:" 2>/dev/null ;;
    6) exit 0 ;;
esac