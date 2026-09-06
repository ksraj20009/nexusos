#!/bin/bash
# Vajra OS Uninstall Script
set -e
echo "=== Vajra OS Uninstall ==="
echo "WARNING: This will remove all Vajra OS components."
read -p "Continue? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Cancelled."
    exit 0
fi
echo "[*] Removing Vajra directories..."
rm -rf /opt/vajra
rm -rf /etc/vajra
rm -rf /var/log/vajra
echo "[+] Vajra OS components removed."
echo "Note: System packages (gnome, firefox, etc.) are NOT removed."
echo "Note: Your data and home directory are NOT affected."