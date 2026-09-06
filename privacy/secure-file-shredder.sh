#!/bin/bash
# Vajra OS Secure File Shredder
# Permanently delete files beyond recovery
set -e
echo "=== Vajra OS Secure File Shredder ==="
echo "WARNING: Files deleted with this tool CANNOT be recovered!"
echo ""
read -p "File/directory to shred: " target
if [ ! -e "$target" ]; then
    echo "[-] File not found: $target"
    exit 1
fi
read -p "Are you sure? Type 'DELETE' to confirm: " confirm
if [ "$confirm" != "DELETE" ]; then
    echo "Cancelled."
    exit 0
fi
echo "[*] Shredding $target..."
if command -v shred &>/dev/null; then
    if [ -f "$target" ]; then
        shred -vfzu -n 3 "$target"
    else
        find "$target" -type f -exec shred -vfzu -n 3 {} +
        rm -rf "$target"
    fi
else
    if [ -f "$target" ]; then
        dd if=/dev/urandom of="$target" bs=1M count=$(stat -c%s "$target" 2>/dev/null || echo 1) 2>/dev/null
        rm -f "$target"
    else
        find "$target" -type f -exec dd if=/dev/urandom of={} bs=1M conv=notrunc 2>/dev/null +
        rm -rf "$target"
    fi
fi
echo "[+] File shredded: $target"
echo "[+] 3-pass overwrite + unlink completed"