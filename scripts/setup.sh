#!/bin/bash
# Vajra OS Installer Launcher
set -e
echo "◆ Vajra OS Installer"
if [[ $EUID -ne 0 ]]; then exec sudo "$0" "$@"; fi
if command -v calamares &>/dev/null; then
    calamares
else
    echo "Installing Calamares..."
    apt-get update && apt-get install -y calamares calamares-settings-debian
    calamares
fi
