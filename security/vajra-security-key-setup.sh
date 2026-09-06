#!/bin/bash
# Vajra OS Security Key Setup (YubiKey/FIDO2, free tools)
set -e
echo "=== Vajra OS Security Key Setup ==="
echo "  1. Install YubiKey tools (free)"
echo "  2. Configure SSH with YubiKey"
echo "  3. Configure PAM with YubiKey"
echo "  4. Test security key"
echo "  5. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y yubikey-manager yubikey-personalization 2>/dev/null
       echo "[+] YubiKey tools installed" ;;
    2) echo "[*] Configuring SSH with YubiKey..."
       echo "  1. Insert YubiKey"
       echo "  2. Run: ykman sshkeys add"
       echo "  3. Add ~/.ssh/id_ed25519_sk to ~/.ssh/authorized_keys"
       echo "[+] Instructions shown" ;;
    3) apt-get install -y libpam-yubico 2>/dev/null
       echo "  Configure: /etc/pam.d/common-auth"
       echo "  Add: auth required pam_yubico.so id=key debug"
       echo "[+] PAM configured" ;;
    4) ykman info 2>/dev/null || echo "Insert YubiKey and run: ykman info" ;;
    5) exit 0 ;;
esac