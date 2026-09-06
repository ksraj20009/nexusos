#!/bin/bash
# Vajra OS Rupee Symbol Input Setup
# Configures the Indian Rupee symbol input method

set -e

echo "=== Vajra OS Rupee Symbol Input Setup ==="

# Method 1: IBus Unicode input
echo "[*] Configuring IBus for Rupee symbol input..."
apt-get install -y ibus ibus-uniemoji 2>/dev/null || true

# Method 2: XCompose configuration
echo "[*] Setting up XCompose for Rupee symbol..."
mkdir -p /etc/skel
cat > /etc/skel/.XCompose << 'COMPOSE'
# Vajra OS XCompose - Rupee Symbol
include "/usr/share/X11/locale/en_US.UTF-8/Compose"
<Multi_key> <r> <s> : "₹" U20B9  # Indian Rupee Sign
<Multi_key> <R> <S> : "₹" U20B9  # Indian Rupee Sign
COMPOSE

# Copy to existing users
for home in /home/*; do
    if [ -d "$home" ]; then
        cp /etc/skel/.XCompose "$home/.XCompose" 2>/dev/null || true
        chown "$(basename $home):$(basename $home)" "$home/.XCompose" 2>/dev/null || true
    fi
done

echo "[+] XCompose configured"

# Method 3: Keyboard layout with Rupee on AltGr+4
echo "[*] Configuring keyboard layout with Rupee on AltGr+4..."
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'in+eng'), ('xkb', 'us')]" 2>/dev/null || true

echo ""
echo "=== Rupee Symbol Input Methods ==="
echo ""
echo "  Method 1: AltGr + 4 (with Indian keyboard layout)"
echo "  Method 2: Ctrl+Shift+U, then type 20B9, then Enter"
echo "  Method 3: Compose key + r + s (if compose is configured)"
echo "  Method 4: Copy from character map: ₹"
echo ""
echo "  The Rupee symbol: ₹"
echo ""
echo "  To switch to Indian keyboard: Super+Space"
echo "  Or select 'IN' from the keyboard indicator in the panel"
echo ""
echo "=== Rupee Symbol Setup Complete ==="