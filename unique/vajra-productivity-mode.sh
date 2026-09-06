#!/bin/bash
# Vajra OS Productivity Mode - Focus, no distractions
set -e
echo "=== Vajra OS Productivity Mode ==="
echo "  1. Focus mode (block distractions)"
echo "  2. Pomodoro timer"
echo "  3. Distraction-free writing"
echo "  4. Exit"
read -p "Choice: " choice
case "$choice" in
    1) echo "[*] Enabling Focus Mode..."
       for site in facebook.com twitter.com instagram.com youtube.com reddit.com; do
           echo "127.0.0.1 $site" >> /etc/hosts
       done
       gsettings set org.gnome.desktop.notifications show-banners false 2>/dev/null || true
       echo "[+] Focus mode ON - social media blocked, notifications off" ;;
    2) echo "Pomodoro: 25 min work + 5 min break"
       echo "Starting 25-minute focus session..."
       sleep 1500
       notify-send "Vajra Pomodoro" "Break time! 5 minutes."
       sleep 300
       notify-send "Vajra Pomodoro" "Back to work! 25 minutes." ;;
    3) echo "Launching distraction-free editor..."
       apt-get install -y focuswriter 2>/dev/null
       focuswriter & ;;
    4) exit 0 ;;
esac