#!/bin/bash
# Vajra OS GPG/PGP Email Encryption Setup
set -e
echo "=== Vajra OS Email Encryption Setup (GPG/PGP) ==="
echo "  1. Install GnuPG"
echo "  2. Generate new GPG key pair"
echo "  3. Import public key"
echo "  4. Export your public key"
echo "  5. Encrypt file"
echo "  6. Decrypt file"
echo "  7. List keys"
echo "  8. Configure Thunderbird Enigmail"
echo "  9. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y gnupg 2>/dev/null; echo "[+] GnuPG installed" ;;
    2) gpg --full-generate-key; echo "[+] Key pair generated" ;;
    3) read -p "Key file: " kf; gpg --import "$kf"; echo "[+] Key imported" ;;
    4) read -p "Email: " email; gpg --armor --export "$email" > my-public-key.asc; echo "[+] Public key exported" ;;
    5) read -p "File to encrypt: " f; read -p "Recipient email: " r; gpg --encrypt --recipient "$r" "$f"; echo "[+] Encrypted" ;;
    6) read -p "File to decrypt: " f; gpg --decrypt "$f" > "${f%.gpg}"; echo "[+] Decrypted" ;;
    7) gpg --list-keys ;;
    8) apt-get install -y thunderbird enigmail 2>/dev/null; echo "[+] Thunderbird + Enigmail installed" ;;
    9) exit 0 ;;
esac