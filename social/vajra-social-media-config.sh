#!/bin/bash
# Vajra OS Social Media Configuration
set -e
echo "=== Vajra OS Social Media Config ==="
echo "  1. Open Twitter/X"
echo "  2. Open Facebook"
echo "  3. Open Instagram"
echo "  4. Open LinkedIn"
echo "  5. Install browser extensions for privacy (free)"
echo "  6. Block social media (productivity mode)"
echo "  7. Exit"
read -p "Choice: " choice
case "$choice" in
    1) xdg-open https://twitter.com 2>/dev/null ;;
    2) xdg-open https://facebook.com 2>/dev/null ;;
    3) xdg-open https://instagram.com 2>/dev/null ;;
    4) xdg-open https://linkedin.com 2>/dev/null ;;
    5) echo "  Install: uBlock Origin, Privacy Badger"
       echo "  These block trackers on social media" ;;
    6) for site in twitter.com facebook.com instagram.com; do
           echo "127.0.0.1 $site" >> /etc/hosts
       done
       echo "[+] Social media blocked. Remove from /etc/hosts to unblock." ;;
    7) exit 0 ;;
esac