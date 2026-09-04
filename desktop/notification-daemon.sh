#!/bin/bash
# Vajra OS — Notification Daemon
# Custom notification system with Sanskrit-inspired styling
set -e

echo "◆ Vajra OS — Notification Daemon Setup"

ND_DIR="/opt/vajra/notifications"
mkdir -p "$ND_DIR"

cat > "$ND_DIR/notification-daemon.sh" << 'ND'
#!/bin/bash

LOG="/var/log/vajra-notifications.log"
HISTORY_DIR="$HOME/.local/share/vajra/notifications"
mkdir -p "$HISTORY_DIR"
HISTORY_FILE="$HISTORY_DIR/history.json"
[ ! -f "$HISTORY_FILE" ] && echo '[]' > "$HISTORY_FILE"

send_notification() {
    local title="$1"
    local body="$2"
    local urgency="${3:-normal}"
    local ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    if command -v notify-send &>/dev/null; then
        notify-send -u "$urgency" "◆ $title" "$body"
    fi
    if command -v paplay &>/dev/null; then
        paplay /usr/share/sounds/freedesktop/stereo/message.oga 2>/dev/null || true
    fi
    echo "[$(date '+%H:%M:%S')] $title: $body" >> "$LOG"
    python3 -c "
import json
with open('$HISTORY_FILE', 'r') as f:
    hist = json.load(f)
hist.insert(0, {'title': '$title', 'body': '$body', 'urgency': '$urgency', 'ts': '$ts'})
hist = hist[:100]
with open('$HISTORY_FILE', 'w') as f:
    json.dump(hist, f, indent=2)
" 2>/dev/null || true
}

case "${1:-show}" in
    show|send)
        TITLE="${2:-Vajra OS}"
        BODY="${3:-Notification}"
        URGENCY="${4:-normal}"
        send_notification "$TITLE" "$BODY" "$URGENCY"
        ;;
    history)
        echo "◆ Notification History:"
        python3 -c "
import json
with open('$HISTORY_FILE', 'r') as f:
    hist = json.load(f)
for n in hist[:20]:
    print(f\"  [{n['ts']}] {n['title']}: {n['body']}\")
" 2>/dev/null || echo "  No history"
        ;;
    clear)
        echo '[]' > "$HISTORY_FILE"
        echo "  ✓ Notification history cleared"
        ;;
    system)
        TEMP=$(cat /sys/class/thermal/thermal_zone*/temp 2>/dev/null | head -1)
        if [ -n "$TEMP" ]; then
            TEMP=$((TEMP / 1000))
            if [ "$TEMP" -gt 80 ]; then
                send_notification "Temperature Alert" "CPU temperature: ${TEMP}C" "critical"
            fi
        fi
        DISK=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
        if [ "$DISK" -gt 90 ]; then
            send_notification "Disk Space Low" "Root partition ${DISK}% full" "critical"
        fi
        MEM=$(free | awk '/Mem:/ {printf "%.0f", $3/$2*100}')
        if [ "$MEM" -gt 90 ]; then
            send_notification "Memory Warning" "Memory usage: ${MEM}%" "critical"
        fi
        ;;
    *)
        echo "Usage: vajra-notify {show|history|clear|system}"
        ;;
esac
ND
chmod +x "$ND_DIR/notification-daemon.sh"
ln -sf "$ND_DIR/notification-daemon.sh" /usr/local/bin/vajra-notify 2>/dev/null || true

cat > /etc/systemd/system/vajra-sys-check.service << 'SVC'
[Unit]
Description=Vajra OS System Check Notifications

[Service]
Type=oneshot
ExecStart=/opt/vajra/notifications/notification-daemon.sh system
SVC

cat > /etc/systemd/system/vajra-sys-check.timer << 'TMR'
[Unit]
Description=Vajra OS Periodic System Check

[Timer]
OnBootSec=5min
OnUnitActiveSec=15min

[Install]
WantedBy=timers.target
TMR
systemctl enable vajra-sys-check.timer 2>/dev/null || true

echo "  ✓ Notification daemon installed"
echo "  ◆ Usage: vajra-notify {show|history|clear|system}"
echo "◆ Done"
