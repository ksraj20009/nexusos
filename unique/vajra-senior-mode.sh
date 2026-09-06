#!/bin/bash
# Vajra OS Senior Mode - Large text, simple interface, voice control
set -e
echo "=== Vajra OS Senior Mode ==="
echo "[*] Enabling Senior Mode..."
gsettings set org.gnome.desktop.interface text-scaling-factor 1.5 2>/dev/null || true
gsettings set org.gnome.desktop.interface gtk-theme 'HighContrast' 2>/dev/null || true
gsettings set org.gnome.desktop.a11y.applications screen-reader-enabled true 2>/dev/null || true
gsettings set org.gnome.desktop.peripherals.keyboard repeat-interval 50 2>/dev/null || true
mkdir -p /etc/vajra
python3 -c "import json; json.dump({'voice_enabled': True, 'voice_wake_word': 'buddhi', 'proactive_enabled': True}, open('/etc/vajra/ai-config.json','w'), indent=2)" 2>/dev/null || true
echo "[+] Senior Mode enabled"
echo "    Large text: 1.5x"
echo "    High contrast: ON"
echo "    Screen reader: ON"
echo "    Voice control: ON (say 'Buddhi')"
echo "    Slow key repeat: ON"