#!/bin/bash
# Vajra OS FTP Client Setup
set -e
echo "=== Vajra OS FTP Client ==="
echo "  1. Install FileZilla (free)"
echo "  2. Quick FTP connect"
echo "  3. Install lftp (CLI, free)"
echo "  4. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y filezilla 2>/dev/null; echo "[+] FileZilla installed"; filezilla & ;;
    2) read -p "FTP server: " server; read -p "Username: " user; read -rsp "Password: " pass; echo ""
       lftp "$server" -u "$user","$pass" 2>/dev/null || echo "Install lftp: sudo apt install lftp" ;;
    3) apt-get install -y lftp 2>/dev/null; echo "[+] lftp installed" ;;
    4) exit 0 ;;
esac