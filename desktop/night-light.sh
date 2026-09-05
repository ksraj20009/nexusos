#!/bin/bash
# Vajra OS — Night Light
# Blue light filter for eye protection
set -e

echo "◆ Vajra OS — Night Light Setup"

NL_DIR="/opt/vajra/nightlight"
mkdir -p "$NL_DIR"

cat > "$NL_DIR/night-light.sh" << 'NL'
#!/bin/bash
STATE_FILE="/tmp/vajra-nightlight"
NIGHT_TEMP=3500
DAY_TEMP=6500

case "${1:-auto}" in
    on)
        if command -v redshift &>/dev/null; then
            redshift -O "$NIGHT_TEMP" & echo "$NIGHT_TEMP" > /tmp/vajra-nl-temp
        else
            gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true 2>/dev/null
            gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature "$NIGHT_TEMP" 2>/dev/null
        fi
        echo "on" > "$STATE_FILE"
        echo "  ✓ Night light ON (temp: ${NIGHT_TEMP}K)"
        ;;
    off)
        killall redshift 2>/dev/null; redshift -x 2>/dev/null
        gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled false 2>/dev/null
        echo "off" > "$STATE_FILE"
        echo "  ✓ Night light OFF"
        ;;
    auto)
        HOUR=$(date +%H)
        if [ "$HOUR" -ge 20 ] || [ "$HOUR" -lt 6 ]; then $0 on; else $0 off; fi
        ;;
    temp)
        TEMP="${2:-4000}"
        killall redshift 2>/dev/null; redshift -O "$TEMP" &
        echo "$TEMP" > /tmp/vajra-nl-temp
        echo "  ✓ Temperature set to ${TEMP}K"
        ;;
    status)
        if [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "on" ]; then
            echo "  Night Light: ON"
        else
            echo "  Night Light: OFF"
        fi
        ;;
    *) echo "Usage: vajra-nightlight {on|off|auto|temp <K>|status}" ;;
esac
NL
chmod +x "$NL_DIR/night-light.sh"
ln -sf "$NL_DIR/night-light.sh" /usr/local/bin/vajra-nightlight 2>/dev/null || true
sudo apt-get install -y redshift 2>/dev/null || true
echo "0 20 * * * root /usr/local/bin/vajra-nightlight on" | sudo tee /etc/cron.d/vajra-nightlight 2>/dev/null || true
echo "0 6 * * * root /usr/local/bin/vajra-nightlight off" | sudo tee -a /etc/cron.d/vajra-nightlight 2>/dev/null || true

echo "  ✓ Night light installed (auto: ON 8PM, OFF 6AM)"
echo "  ◆ Usage: vajra-nightlight {on|off|auto|temp <K>|status}"
echo "◆ Done"
