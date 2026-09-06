#!/bin/bash
# Vajra OS Email Client Setup (Thunderbird pre-configured)
set -e
echo "=== Vajra OS Email Client ==="
echo "  1. Install Thunderbird"
echo "  2. Launch Thunderbird"
echo "  3. Configure Gmail (IMAP)"
echo "  4. Configure Yahoo Mail"
echo "  5. Configure Outlook"
echo "  6. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y thunderbird 2>/dev/null; echo "[+] Thunderbird installed" ;;
    2) thunderbird & ;;
    3) echo "Gmail IMAP: Server=imap.gmail.com:993 SSL, SMTP=smtp.gmail.com:465 SSL"
       echo "Use App Password from Google Account > Security > App Passwords"
       thunderbird & ;;
    4) echo "Yahoo IMAP: Server=imap.mail.yahoo.com:993 SSL, SMTP=smtp.mail.yahoo.com:465 SSL"
       thunderbird & ;;
    5) echo "Outlook IMAP: Server=outlook.office365.com:993 SSL, SMTP=smtp.office365.com:587 TLS"
       thunderbird & ;;
    6) exit 0 ;;
esac