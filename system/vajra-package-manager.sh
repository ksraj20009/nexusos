#!/bin/bash
# Vajra OS Package Manager
set -e
echo "=== Vajra OS Package Manager ==="
echo "  1. Search package"
echo "  2. Install package"
echo "  3. Remove package"
echo "  4. Update package"
echo "  5. List installed"
echo "  6. Package info"
echo "  7. Install .deb file"
echo "  8. Exit"
read -p "Choice: " choice
case "$choice" in
    1) read -p "Search: " q; apt-cache search "$q" | head -20 ;;
    2) read -p "Package: " p; apt-get install -y "$p" && echo "[+] Installed $p" ;;
    3) read -p "Package: " p; apt-get remove -y "$p" && echo "[+] Removed $p" ;;
    4) read -p "Package: " p; apt-get install --only-upgrade -y "$p" && echo "[+] Updated $p" ;;
    5) dpkg -l | grep "^ii" | wc -l; echo "Use 'dpkg -l' for full list" ;;
    6) read -p "Package: " p; apt-cache show "$p" | head -20 ;;
    7) read -p ".deb file: " f; dpkg -i "$f" && apt-get install -f -y && echo "[+] Installed $f" ;;
    8) exit 0 ;;
esac