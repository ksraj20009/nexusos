#!/bin/bash
# Vajra OS Log Rotation Setup
set -e
echo "=== Vajra OS Log Rotation ==="
echo "[*] Configuring log rotation..."
cat > /etc/logrotate.d/vajra << 'LOGROTATE'
/var/log/vajra/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0640 root root
}
LOGROTATE
echo "[+] Log rotation configured:"
echo "    - Daily rotation"
echo "    - Keep 7 days"
echo "    - Compress old logs"
echo "[*] Testing configuration..."
logrotate -d /etc/logrotate.d/vajra 2>&1 | head -10
echo "[+] Log rotation setup complete"