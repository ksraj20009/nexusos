#!/bin/bash
# Vajra OS Log Viewer
set -e
echo "=== Vajra OS Log Viewer ==="
echo "  1. System log"
echo "  2. Auth log"
echo "  3. Kernel log"
echo "  4. Boot log"
echo "  5. Vajra app log"
echo "  6. Search logs"
echo "  7. Clear old logs"
echo "  8. Exit"
read -p "Choice: " choice
case "$choice" in
    1) journalctl -e --no-pager | tail -50 ;;
    2) journalctl -u auth -e --no-pager | tail -50 2>/dev/null || grep "Accepted\|Failed" /var/log/auth.log 2>/dev/null | tail -30 ;;
    3) dmesg | tail -50 ;;
    4) journalctl -b --no-pager | tail -50 ;;
    5) cat /var/log/vajra/vajra.log 2>/dev/null || echo "No Vajra logs" ;;
    6) read -p "Search term: " q; journalctl --no-pager | grep "$q" | tail -30 ;;
    7) journalctl --vacuum-time=7d 2>/dev/null; echo "[+] Logs older than 7 days cleared" ;;
    8) exit 0 ;;
esac