#!/bin/bash
# Vajra OS Intrusion Detection Setup
# fail2ban + AIDE file integrity monitoring
set -e
echo "=== Vajra OS Intrusion Detection Setup ==="
echo "[*] Installing fail2ban..."
apt-get install -y fail2ban 2>/dev/null || true
echo "[*] Configuring fail2ban..."
cat > /etc/fail2ban/jail.local << 'JAIL'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
JAIL
systemctl enable fail2ban 2>/dev/null || true
systemctl restart fail2ban 2>/dev/null || true
echo "[+] fail2ban configured (SSH protection)"
echo "[*] Installing AIDE (file integrity)..."
apt-get install -y aide 2>/dev/null || true
echo "[*] Initializing AIDE database..."
aideinit 2>/dev/null || echo "  (Run 'sudo aideinit' manually after setup)"
echo "[+] AIDE installed"
echo ""
echo "=== Intrusion Detection Complete ==="
echo "fail2ban: protects SSH from brute force"
echo "AIDE: monitors file changes"
echo "Check fail2ban: sudo fail2ban-client status"
echo "Check AIDE: sudo aide --check"