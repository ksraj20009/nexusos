#!/bin/bash
# Vajra OS Password Manager Setup (KeePassXC/Bitwarden)
set -e
echo "=== Vajra OS Password Manager Setup ==="
echo "  1. Install KeePassXC (local)"
echo "  2. Install Bitwarden CLI (cloud)"
echo "  3. Create new password database"
echo "  4. Generate strong password"
echo "  5. Open KeePassXC"
echo "  6. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y keepassxc 2>/dev/null; echo "[+] KeePassXC installed" ;;
    2) snap install bw 2>/dev/null || pip install bitwarden 2>/dev/null; echo "[+] Bitwarden installed" ;;
    3) read -p "Database path: " db; keepassxc-cli db-create "$db" 2>/dev/null; echo "[+] Database created at $db" ;;
    4) python3 -c "import secrets,string; print(''.join(secrets.choice(string.ascii_letters+string.digits+'!@#$%^&*') for _ in range(20)))" ;;
    5) keepassxc 2>/dev/null & ;;
    6) exit 0 ;;
esac