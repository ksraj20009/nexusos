#!/bin/bash
# ============================================================================
# Vajra OS APT Repository Setup
# ============================================================================
# This script sets up a complete APT repository using reprepro.
# It generates a GPG key, configures reprepro, and creates the repo structure.
#
# This is the foundation of Vajra OS as a real distribution — not a themed
# distro, but a system with its own package repository that users add to
# their sources.list.
#
# Usage: sudo bash repo-setup.sh
# ============================================================================
set -e

REPO_ROOT="/srv/repo/vajra"
REPO_CONF="$REPO_ROOT/conf"
GPG_DIR="/etc/vajra/gpg"
KEYRING_PACKAGE_DIR="/var/lib/vajra/keyring-package"

echo "============================================"
echo "  Vajra OS APT Repository Setup"
echo "============================================"

# --- Check prerequisites ---
if [ "$(id -u)" -ne 0 ]; then
    echo "[-] Run as root: sudo bash repo-setup.sh"
    exit 1
fi

if ! command -v reprepro &>/dev/null; then
    echo "[*] Installing reprepro..."
    apt-get update -qq
    apt-get install -y reprepro gnupg rng-tools apache2 2>/dev/null
fi

# --- Create directory structure ---
echo "[1/6] Creating repository structure..."
mkdir -p "$REPO_CONF"
mkdir -p "$GPG_DIR"
mkdir -p "$KEYRING_PACKAGE_DIR"
mkdir -p "$REPO_ROOT/pool"
mkdir -p /var/www/html/vajra-repo

# --- Generate GPG key for package signing ---
echo "[2/6] Generating GPG signing key..."
if [ ! -f "$GPG_DIR/vajra-signing.key" ]; then
    cat > /tmp/vajra-gpg-batch << 'GPGEOF'
%echo Generating Vajra OS package signing key
Key-Type: RSA
Key-Length: 4096
Key-Usage: sign
Name-Real: Vajra OS Package Signing
Name-Email: packages@vajra-os.org
Expire-Date: 0
%no-protection
%commit
%echo Done
GPGEOF
    gpg --batch --gen-key /tmp/vajra-gpg-batch
    rm /tmp/vajra-gpg-batch
    
    # Export the key
    GPG_KEY_ID=$(gpg --list-keys --with-colons "packages@vajra-os.org" | grep "pub" | cut -d: -f5)
    gpg --export --armor "packages@vajra-os.org" > "$GPG_DIR/vajra-signing-key.asc"
    gpg --export-secret-keys --armor "packages@vajra-os.org" > "$GPG_DIR/vajra-signing.key"
    
    # Export for keyring package (public key that users install)
    gpg --export --armor "packages@vajra-os.org" > "$KEYRING_PACKAGE_DIR/vajra-archive-keyring.gpg"
    gpg --dearmor < "$KEYRING_PACKAGE_DIR/vajra-archive-keyring.gpg" > "$KEYRING_PACKAGE_DIR/vajra-archive-keyring.gpg.dearmored"
    mv "$KEYRING_PACKAGE_DIR/vajra-archive-keyring.gpg.dearmored" "$KEYRING_PACKAGE_DIR/vajra-archive-keyring.gpg"
    
    echo "[+] GPG key generated: $GPG_KEY_ID"
    echo "[+] Key saved to $GPG_DIR/"
    echo "[+] Public key for keyring package: $KEYRING_PACKAGE_DIR/"
else
    echo "[+] GPG key already exists at $GPG_DIR/"
fi

# --- Configure reprepro ---
echo "[3/6] Configuring reprepro..."

cat > "$REPO_CONF/distributions" << 'DISTEOF'
Origin: Vajra OS
Label: Vajra OS Package Repository
Suite: vajra
Codename: vajra
Version: 1.0
Architectures: amd64 arm64 i386 source
Components: main contrib non-free
Description: Vajra OS (वज्र OS) — India's Privacy-First AI-Powered Operating System
SignWith: packages@vajra-os.org
DebOverride: override.vajra
UDebOverride: override.vajra.udeb
DscOverride: override.vajra.src
DISTEOF

cat > "$REPO_CONF/incoming" << 'INCOMINGEOF'
Name: vajra-incoming
IncomingDir: incoming
Allow: vajra
MultipleDistributions: Yes
Permit: older_version unused_files
Cleanup: on_deny on_error
INCOMINGEOF

# Create override files
touch "$REPO_CONF/override.vajra"
touch "$REPO_CONF/override.vajra.udeb"
touch "$REPO_CONF/override.vajra.src"

# --- Configure Apache to serve the repo ---
echo "[4/6] Configuring Apache..."

cat > /etc/apache2/conf-available/vajra-repo.conf << 'APACHEEOF'
Alias /vajra-repo /srv/repo/vajra

<Directory /srv/repo/vajra>
    Options Indexes FollowSymLinks
    AllowOverride None
    Require all granted
</Directory>
APACHEEOF

a2enconf vajra-repo 2>/dev/null || true
systemctl reload apache2 2>/dev/null || true

# --- Symlink to web root ---
ln -sf "$REPO_ROOT" /var/www/html/vajra-repo 2>/dev/null || true

# --- Verify ---
echo "[5/6] Verifying repository..."
if reprepro -b "$REPO_ROOT" list vajra 2>/dev/null; then
    echo "[+] Repository initialized successfully"
else
    echo "[*] First run — repository is empty (this is normal)"
    echo "[+] Repository structure created at $REPO_ROOT"
fi

# --- Summary ---
echo ""
echo "[6/6] Setup complete!"
echo "============================================"
echo "  Repository:  $REPO_ROOT"
echo "  Web URL:     http://localhost/vajra-repo"
echo "  GPG key:     $GPG_DIR/vajra-signing-key.asc"
echo "  Distro:      vajra (main contrib non-free)"
echo "  Archs:       amd64 arm64 i386"
echo ""
echo "  Next steps:"
echo "    1. Build packages: ./build-all-packages.sh"
echo "    2. Add to repo:    reprepro -b $REPO_ROOT includedeb vajra *.deb"
echo "    3. Users add:      deb [signed-by=/usr/share/keyrings/vajra-archive-keyring.gpg] http://repo.vajra-os.org vajra main"
echo "============================================"
