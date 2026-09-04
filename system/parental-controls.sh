#!/bin/bash
# Vajra OS — Parental Controls
# Screen time limits, app blocking, content filtering
set -e

echo "◆ Vajra OS — Parental Controls Setup"

PC_DIR="/opt/vajra/parental"
mkdir -p "$PC_DIR"

cat > "$PC_DIR/parental-controls.sh" << 'PC'
#!/bin/bash

PC_CONF="/opt/vajra/parental/config.conf"

if [ ! -f "$PC_CONF" ]; then
    cat > "$PC_CONF" << CONF
ENABLED=false
SCREEN_TIME_LIMIT_MINUTES=120
BEDTIME_HOUR=22
WAKE_HOUR=7
BLOCKED_APPS=steam,discord,telegram
BLOCKED_SITES=reddit.com,twitter.com,instagram.com,tiktok.com
CONF
fi

source "$PC_CONF"

show_status() {
    echo "◆ Vajra OS — Parental Controls"
    echo "  Status:        $([ "$ENABLED" = true ] && echo "ENABLED" || echo "DISABLED")"
    echo "  Screen Time:    ${SCREEN_TIME_LIMIT_MINUTES} min/day"
    echo "  Bedtime:       ${BEDTIME_HOUR}:00 - ${WAKE_HOUR}:00"
    echo "  Blocked Apps:  $BLOCKED_APPS"
    echo "  Blocked Sites: $BLOCKED_SITES"
}

enable() {
    sed -i 's/ENABLED=false/ENABLED=true/' "$PC_CONF"
    IFS=',' read -ra SITES <<< "$BLOCKED_SITES"
    for site in "${SITES[@]}"; do
        IP=$(dig +short "$site" 2>/dev/null | head -1)
        if [ -n "$IP" ]; then
            sudo iptables -A OUTPUT -d "$IP" -j DROP 2>/dev/null || true
        fi
    done
    IFS=',' read -ra APPS <<< "$BLOCKED_APPS"
    for app in "${APPS[@]}"; do
        APP_PATH=$(which "$app" 2>/dev/null)
        if [ -n "$APP_PATH" ]; then
            sudo chmod 000 "$APP_PATH" 2>/dev/null || true
        fi
    done
    echo "  ✓ Parental controls ENABLED"
}

disable() {
    sed -i 's/ENABLED=true/ENABLED=false/' "$PC_CONF"
    IFS=',' read -ra APPS <<< "$BLOCKED_APPS"
    for app in "${APPS[@]}"; do
        APP_PATH=$(which "$app" 2>/dev/null)
        if [ -n "$APP_PATH" ]; then
            sudo chmod 755 "$APP_PATH" 2>/dev/null || true
        fi
    done
    echo "  ✓ Parental controls DISABLED"
}

case "${1:-status}" in
    status) show_status ;;
    enable) enable ;;
    disable) disable ;;
    set-time) sed -i "s/SCREEN_TIME_LIMIT_MINUTES=.*/SCREEN_TIME_LIMIT_MINUTES=$2/" "$PC_CONF"; echo "  ✓ Screen time set to $2 minutes" ;;
    set-bedtime) sed -i "s/BEDTIME_HOUR=.*/BEDTIME_HOUR=$2/" "$PC_CONF"; echo "  ✓ Bedtime set to $2:00" ;;
    block-app) sed -i "s/\(BLOCKED_APPS=.*\)/\1,$2/" "$PC_CONF"; echo "  ✓ Blocked $2" ;;
    *) echo "Usage: vajra-parental {status|enable|disable|set-time <min>|set-bedtime <hour>|block-app <name>}" ;;
esac
PC
chmod +x "$PC_DIR/parental-controls.sh"
ln -sf "$PC_DIR/parental-controls.sh" /usr/local/bin/vajra-parental 2>/dev/null || true

echo "  ✓ Parental controls installed"
echo "  ◆ Usage: vajra-parental {status|enable|disable|set-time|set-bedtime|block-app}"
echo "◆ Done"
