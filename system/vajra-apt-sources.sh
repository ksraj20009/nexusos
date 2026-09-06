#!/bin/bash
# =============================================================
# Vajra OS APT Sources Configuration
# Sets up package repositories for Vajra OS
# =============================================================

set -e

VAJRA_CODENAME="vajra"
VAJRA_REPO_URL="deb https://repo.vajra-os.in/vajra ${VAJRA_CODENAME} main"

echo "=== Vajra OS APT Sources Setup ==="
echo ""

# --- Backup existing sources ---
if [ -f /etc/apt/sources.list ]; then
    cp /etc/apt/sources.list /etc/apt/sources.list.vajra-backup
    echo "[+] Backed up existing sources.list"
fi

# --- Create Vajra sources.list ---
echo "[*] Writing Vajra OS APT sources..."

cat > /etc/apt/sources.list << SRCLIST
# =============================================================
# Vajra OS — APT Package Sources
# Vajra (वज्र) — Thunderbolt Strong. Unbreakable.
# =============================================================

# --- Vajra OS Main Repository ---
# Primary package source for Vajra OS
# ${VAJRA_REPO_URL}
# deb https://repo.vajra-os.in/vajra vajra main contrib non-free

# --- Debian Base (Vajra is built on solid foundations) ---
# Base system packages
deb http://deb.debian.org/debian bookworm main contrib non-free
deb http://deb.debian.org/debian bookworm-updates main contrib non-free
deb http://deb.debian.org/debian-security bookworm-security main contrib non-free

# --- Backports (newer packages) ---
deb http://deb.debian.org/debian bookworm-backports main contrib non-free

# --- Vajra Security Updates ---
# Security patches specific to Vajra OS
# deb https://repo.vajra-os.in/vajra vajra-security main

# --- Vajra App Store ---
# Curated applications for Vajra OS
# deb https://repo.vajra-os.in/vajra vajra-apps main

SRCLIST

echo "[+] sources.list configured"

# --- Create APT preferences for Vajra ---
echo "[*] Setting up APT preferences..."

mkdir -p /etc/apt/preferences.d
cat > /etc/apt/preferences.d/vajra-pref << 'PREF'
# Vajra OS APT Preferences
# Prefer Vajra packages over base Debian packages

Package: *
Pin: release o=Vajra OS
Pin-Priority: 700

Package: *
Pin: release o=Debian
Pin-Priority: 500
PREF

echo "[+] APT preferences set"

# --- Add Vajra repository key (placeholder) ---
echo "[*] Adding Vajra repository key..."
echo "  (In production, this would add the Vajra GPG key)"
echo "  wget -qO - https://repo.vajra-os.in/vajra.gpg.key | sudo apt-key add -"

# --- Create Vajra apt.conf.d ---
cat > /etc/apt/apt.conf.d/99vajra << 'APTCONF'
// Vajra OS APT Configuration

// Install recommended packages by default
APT::Install-Recommends "true";

// Install suggested packages
APT::Install-Suggests "false";

// Automatically remove unused dependencies
APT::AutoRemove::RecommendsImportant "true";
APT::AutoRemove::SuggestsImportant "false";

// Allow downgrades
APT::Get::AllowDowngrades "true";

// Color output
APT::Color "true";

// Show package info before install
APT::Get::Show-User-Simulation "true";

// Verify packages
APT::Get::AllowUnauthenticated "false";
APT::Get::Assume-Yes "false";
APTCONF

echo "[+] apt.conf.d/99vajra configured"

# --- Create Vajra package list ---
echo "[*] Creating Vajra base package list..."

mkdir -p /var/lib/vajra/packages
cat > /var/lib/vajra/packages/installed-base.txt << 'PKGLIST'
# Vajra OS Base Packages
# Installed during initial setup
vajra-core
vajra-desktop
vajra-ai-buddhi
vajra-branding
vajra-themes
vajra-icons
vajra-wallpapers
vajra-settings
vajra-security
vajra-locale-en-IN
vajra-locale-hi-IN
vajra-apps-core
vajra-apps-extra
vajra-cybersecurity
vajra-accessibility
vajra-gaming
vajra-developer-tools
PKGLIST

echo "[+] Base package list created"

# --- Update package lists ---
echo ""
echo "[*] Updating package lists..."
apt-get update 2>/dev/null || echo "[!] Could not update (network may be unavailable)"

echo ""
echo "=== APT Sources Setup Complete ==="
echo ""
echo "Vajra OS repositories configured:"
echo "  - Vajra main repo:   (placeholder — configure your own domain)"
echo "  - Debian base:       bookworm main contrib non-free"
echo "  - Debian updates:    bookworm-updates"
echo "  - Debian security:   bookworm-security"
echo "  - Debian backports:  bookworm-backports"
echo ""
echo "To install Vajra packages:"
echo "  sudo apt install vajra-core vajra-desktop vajra-ai-buddhi"
echo ""
echo "To update:"
echo "  sudo apt update && sudo apt upgrade"