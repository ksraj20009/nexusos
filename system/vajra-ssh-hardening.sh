#!/bin/bash
# Vajra OS SSH Hardening (free, built-in)
set -e
echo "=== Vajra OS SSH Hardening ==="
SSH_CONFIG="/etc/ssh/sshd_config"
echo "[*] Backing up SSH config..."
cp "$SSH_CONFIG" "${SSH_CONFIG}.bak.vajra"
echo "[*] Applying hardening..."
sed -i 's/#PermitRootLogin.*/PermitRootLogin no/' "$SSH_CONFIG"
sed -i 's/#PasswordAuthentication.*/PasswordAuthentication no/' "$SSH_CONFIG" 2>/dev/null || echo "PasswordAuthentication no" >> "$SSH_CONFIG"
sed -i 's/#MaxAuthTries.*/MaxAuthTries 3/' "$SSH_CONFIG"
sed -i 's/#LoginGraceTime.*/LoginGraceTime 30/' "$SSH_CONFIG"
echo "[+] SSH hardened:"
echo "    - Root login: disabled"
echo "    - Password auth: disabled (use keys only)"
echo "    - Max auth tries: 3"
echo "    - Login grace time: 30s"
echo "[*] Restarting SSH..."
systemctl restart sshd 2>/dev/null || systemctl restart ssh 2>/dev/null
echo "[+] SSH service restarted"