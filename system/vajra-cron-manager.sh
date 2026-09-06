#!/bin/bash
# Vajra OS Cron/Scheduled Tasks Manager
set -e
echo "=== Vajra OS Cron Manager ==="
echo "  1. View crontab"
echo "  2. Add scheduled task"
echo "  3. Remove task"
echo "  4. Common schedules"
echo "  5. Exit"
read -p "Choice: " choice
case "$choice" in
    1) crontab -l 2>/dev/null || echo "No crontab" ;;
    2) read -p "Schedule (cron format): " sched; read -p "Command: " cmd
       (crontab -l 2>/dev/null; echo "$sched $cmd") | crontab -
       echo "[+] Task added" ;;
    3) crontab -l 2>/dev/null | grep -v "$1" | crontab -; echo "[+] Task removed" ;;
    4) echo "  Daily at 2AM:    0 2 * * *"
       echo "  Hourly:          0 * * * *"
       echo "  Every 5 min:     */5 * * * *"
       echo "  Weekly (Sun 3AM): 0 3 * * 0"
       echo "  Monthly (1st):    0 0 1 * *" ;;
    5) exit 0 ;;
esac