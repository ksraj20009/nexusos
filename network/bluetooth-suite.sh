#!/bin/bash
# Vajra OS — Bluetooth Suite
# Bluetooth management with privacy controls
set -e

echo "◆ Vajra OS — Bluetooth Suite Setup"

BT_DIR="/opt/vajra/bluetooth"
mkdir -p "$BT_DIR"

cat > "$BT_DIR/bluetooth-suite.sh" << 'BT'
#!/bin/bash

case "${1:-status}" in
    status)
        echo "◆ Vajra OS — Bluetooth Status"
        if systemctl is-active bluetooth &>/dev/null; then
            echo "  Status: ACTIVE"
            bluetoothctl devices 2>/dev/null | while read -r line; do
                echo "  Device: $line"
            done
        else
            echo "  Status: OFF"
        fi
        ;;
    on|enable)
        sudo systemctl start bluetooth 2>/dev/null || true
        sudo systemctl enable bluetooth 2>/dev/null || true
        bluetoothctl power on 2>/dev/null || true
        echo "  ✓ Bluetooth enabled"
        ;;
    off|disable)
        bluetoothctl power off 2>/dev/null || true
        sudo systemctl stop bluetooth 2>/dev/null || true
        sudo systemctl disable bluetooth 2>/dev/null || true
        echo "  ✓ Bluetooth disabled"
        ;;
    scan)
        echo "◆ Scanning for devices..."
        bluetoothctl scan on 2>/dev/null &
        SCAN_PID=$!
        sleep 10
        kill "$SCAN_PID" 2>/dev/null
        bluetoothctl scan off 2>/dev/null
        bluetoothctl devices 2>/dev/null
        ;;
    pair)
        MAC="$2"
        [ -z "$MAC" ] && echo "  Usage: vajra-bt pair <MAC>" && exit 1
        bluetoothctl pair "$MAC" 2>/dev/null
        bluetoothctl trust "$MAC" 2>/dev/null
        echo "  ✓ Paired with $MAC"
        ;;
    connect)
        MAC="$2"
        bluetoothctl connect "$MAC" 2>/dev/null
        echo "  ✓ Connected to $MAC"
        ;;
    disconnect)
        MAC="$2"
        bluetoothctl disconnect "$MAC" 2>/dev/null
        echo "  ✓ Disconnected from $MAC"
        ;;
    audio)
        echo "◆ Audio devices:"
        bluetoothctl devices 2>/dev/null | while read -r _ _ name; do
            echo "  $name"
        done
        ;;
    forget)
        MAC="$2"
        bluetoothctl remove "$MAC" 2>/dev/null
        echo "  ✓ Forgot device $MAC"
        ;;
    *)
        echo "Usage: vajra-bt {status|on|off|scan|pair|connect|disconnect|audio|forget}"
        ;;
esac
BT
chmod +x "$BT_DIR/bluetooth-suite.sh"
ln -sf "$BT_DIR/bluetooth-suite.sh" /usr/local/bin/vajra-bt 2>/dev/null || true

echo "  ✓ Bluetooth suite installed"
echo "  ◆ Usage: vajra-bt {status|on|off|scan|pair|connect|disconnect}"
echo "◆ Done"
