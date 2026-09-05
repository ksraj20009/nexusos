#!/bin/bash
# Vajra OS — Event Viewer
# View system logs like Windows Event Viewer
set -e

echo "◆ Vajra OS — Event Viewer Setup"

EV_DIR="/opt/vajra/events"
mkdir -p "$EV_DIR"

cat > "$EV_DIR/event-viewer.sh" << 'EV'
#!/bin/bash
case "${1:-recent}" in
    recent)
        echo "◆ Recent System Events:"
        journalctl --no-pager -n 20 --since "1 hour ago" 2>/dev/null | awk '{print "  " $0}' || echo "  journalctl not available"
        ;;
    errors)
        echo "◆ Error Events (last 24h):"
        journalctl --no-pager -p err --since "24 hours ago" 2>/dev/null | awk '{print "  X " $0}' | head -30 || echo "  No errors"
        ;;
    warnings)
        echo "◆ Warning Events (last 24h):"
        journalctl --no-pager -p warning --since "24 hours ago" 2>/dev/null | head -30 || echo "  No warnings"
        ;;
    boot) echo "◆ Boot Events:"; journalctl --no-pager -b 2>/dev/null | head -30 ;;
    kernel) echo "◆ Kernel Events:"; dmesg --time-format reltime 2>/dev/null | tail -30 ;;
    auth)
        echo "◆ Authentication Events:"
        journalctl --no-pager -u sshd --since "24 hours ago" 2>/dev/null | head -20 || \
        grep -E "Accepted|Failed|session" /var/log/auth.log 2>/dev/null | tail -20
        ;;
    vajra)
        echo "◆ Vajra OS Events:"
        for log in /var/log/vajra-*.log; do
            [ -f "$log" ] || continue
            echo "  -- $(basename $log) --"
            tail -10 "$log" 2>/dev/null | awk '{print "    " $0}'
        done
        ;;
    search)
        QUERY="$2"; [ -z "$QUERY" ] && echo "  Usage: vajra-events search <query>" && exit 1
        echo "◆ Events matching '$QUERY':"
        journalctl --no-pager 2>/dev/null | grep -i "$QUERY" | tail -20
        ;;
    live) echo "◆ Live Event Stream (Ctrl+C to stop):"; journalctl -f 2>/dev/null ;;
    *) echo "Usage: vajra-events {recent|errors|warnings|boot|kernel|auth|vajra|search <q>|live}" ;;
esac
EV
chmod +x "$EV_DIR/event-viewer.sh"
ln -sf "$EV_DIR/event-viewer.sh" /usr/local/bin/vajra-events 2>/dev/null || true

echo "  ✓ Event viewer installed"
echo "  ◆ Usage: vajra-events {recent|errors|warnings|kernel|auth|vajra|live}"
echo "◆ Done"
