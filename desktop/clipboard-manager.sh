#!/bin/bash
# Vajra OS — Clipboard Manager
# Track clipboard history like Windows Win+V
set -e

echo "◆ Vajra OS — Clipboard Manager Setup"

CB_DIR="/opt/vajra/clipboard"
mkdir -p "$CB_DIR"

cat > "$CB_DIR/clipboard-manager.sh" << 'CB'
#!/bin/bash
HISTORY_FILE="$HOME/.local/share/vajra/clipboard-history"
mkdir -p "$(dirname "$HISTORY_FILE")"
MAX_ENTRIES=50

case "${1:-history}" in
    history)
        echo "◆ Clipboard History:"
        if [ -f "$HISTORY_FILE" ]; then
            NL=1
            while IFS= read -r line; do
                PREVIEW="${line:0:60}"
                [ ${#line} -gt 60 ] && PREVIEW="$PREVIEW..."
                echo "  $NL: $PREVIEW"
                NL=$((NL+1))
            done < "$HISTORY_FILE"
        else
            echo "  (empty)"
        fi
        ;;
    copy)
        N="${2:-1}"
        LINE=$(sed -n "${N}p" "$HISTORY_FILE" 2>/dev/null)
        if [ -n "$LINE" ]; then
            echo -n "$LINE" | xclip -selection clipboard 2>/dev/null || echo -n "$LINE" | wl-copy 2>/dev/null || true
            echo "  ✓ Copied item $N to clipboard"
        else
            echo "  ✗ Invalid item number"
        fi
        ;;
    clear)
        > "$HISTORY_FILE"
        echo "  ✓ Clipboard history cleared"
        ;;
    daemon)
        LAST=""
        while true; do
            CURRENT=$(xclip -selection clipboard -o 2>/dev/null || wl-paste 2>/dev/null || echo "")
            if [ -n "$CURRENT" ] && [ "$CURRENT" != "$LAST" ]; then
                if ! grep -qF "$CURRENT" "$HISTORY_FILE" 2>/dev/null; then
                    echo "$CURRENT" >> "$HISTORY_FILE"
                    TAIL=$((MAX_ENTRIES + 1))
                    sed -i "1,${TAIL}!d" "$HISTORY_FILE"
                fi
                LAST="$CURRENT"
            fi
            sleep 2
        done
        ;;
    *) echo "Usage: vajra-clip {history|copy <n>|clear|daemon}" ;;
esac
CB
chmod +x "$CB_DIR/clipboard-manager.sh"
ln -sf "$CB_DIR/clipboard-manager.sh" /usr/local/bin/vajra-clip 2>/dev/null || true

cat > /etc/systemd/system/vajra-clipboard.service << 'SVC'
[Unit]
Description=Vajra OS Clipboard Manager
After=graphical.target
[Service]
Type=simple
ExecStart=/opt/vajra/clipboard/clipboard-manager.sh daemon
Restart=always
RestartSec=5
Environment=DISPLAY=:0
[Install]
WantedBy=graphical.target
SVC
systemctl enable vajra-clipboard 2>/dev/null || true

echo "  ✓ Clipboard manager installed (daemon running)"
echo "  ◆ Usage: vajra-clip {history|copy <n>|clear}"
echo "◆ Done"
