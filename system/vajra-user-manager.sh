#!/bin/bash
# Vajra OS User Manager
set -e
echo "=== Vajra OS User Manager ==="
echo "  1. Add user"
echo "  2. Remove user"
echo "  3. Change password"
echo "  4. Add to sudo"
echo "  5. Remove from sudo"
echo "  6. List users"
echo "  7. User info"
echo "  8. Exit"
read -p "Choice: " choice
case "$choice" in
    1) read -p "Username: " u; read -p "Full name: " n; adduser --gecos "$n" "$u" && echo "[+] User $u added" ;;
    2) read -p "Username: " u; deluser --remove-home "$u" && echo "[+] User $u removed" ;;
    3) read -p "Username: " u; passwd "$u" ;;
    4) read -p "Username: " u; usermod -aG sudo "$u" && echo "[+] $u added to sudo" ;;
    5) read -p "Username: " u; deluser "$u" sudo && echo "[+] $u removed from sudo" ;;
    6) cut -d: -f1,3 /etc/passwd | grep -E "^[a-z]" | head -20 ;;
    7) read -p "Username: " u; id "$u"; groups "$u" ;;
    8) exit 0 ;;
esac