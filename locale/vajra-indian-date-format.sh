#!/bin/bash
# Vajra OS Indian Date Format Setup
# Configures dd/mm/yyyy date format as default

set -e

echo "=== Vajra OS Indian Date Format Setup ==="

# Set locale to en_IN (English India)
echo "[*] Setting locale to en_IN (English - India)..."

# Generate locale
if [ -f /etc/locale.gen ]; then
    sed -i 's/# en_IN.UTF-8 UTF-8/en_IN.UTF-8 UTF-8/' /etc/locale.gen
    locale-gen 2>/dev/null || true
fi

# Set system locale
update-locale LANG=en_IN.UTF-8 LC_TIME=en_IN.UTF-8 2>/dev/null || true

# GNOME settings - dd/mm/yyyy format
gsettings set org.gnome.desktop.interface clock-format '12h' 2>/dev/null || true
gsettings set org.gnome.desktop.interface clock-show-date true 2>/dev/null || true

# Set date format in locale
export LC_TIME=en_IN.UTF-8

# Configure date display format
cat > /etc/vajra/date-format.conf << 'CONF'
# Vajra OS Date Format Configuration
# Indian Standard: dd/mm/yyyy (DD/MM/YYYY)
# Time: 12-hour format with AM/PM
# First day of week: Sunday

DATE_FORMAT="%d/%m/%Y"
DATE_FORMAT_LONG="%A, %d %B %Y"
TIME_FORMAT="%I:%M %p"
DATETIME_FORMAT="%d/%m/%Y %I:%M %p"
FIRST_DAY_OF_WEEK=0
CONF

echo "[+] Date format set to dd/mm/yyyy"
echo "[+] Time format set to 12-hour (AM/PM)"
echo "[+] First day of week: Sunday"

echo ""
echo "  Current date in Indian format:"
date +"%d/%m/%Y" 2>/dev/null || echo "  (locale not yet active - will apply on next login)"
echo "  Current time:"
date +"%I:%M %p" 2>/dev/null || echo "  (locale not yet active)"

echo ""
echo "=== Indian Date Format Setup Complete ==="
echo "Changes will take effect on next login."