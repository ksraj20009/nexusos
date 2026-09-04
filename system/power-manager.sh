#!/bin/bash
# Vajra OS — Power Manager
# Battery, charging, and power profile management
set -e

echo "◆ Vajra OS — Power Manager Setup"

PW_DIR="/opt/vajra/power"
mkdir -p "$PW_DIR"

cat > "$PW_DIR/power-manager.sh" << 'PW'
#!/bin/bash

BAT_PATH="/sys/class/power_supply/BAT0"
[ ! -d "$BAT_PATH" ] && BAT_PATH="/sys/class/power_supply/BAT1"

get_battery() {
    if [ -d "$BAT_PATH" ]; then
        cat "$BAT_PATH/capacity" 2>/dev/null || echo "?"
    else
        echo "none"
    fi
}

get_status() {
    if [ -d "$BAT_PATH" ]; then
        cat "$BAT_PATH/status" 2>/dev/null || echo "Unknown"
    else
        echo "No battery"
    fi
}

case "${1:-status}" in
    status)
        echo "◆ Vajra OS — Power Status"
        BAT=$(get_battery)
        STAT=$(get_status)
        echo "  Battery:  $BAT% ($STAT)"
        if [ -f "$BAT_PATH/current_now" ] && [ -f "$BAT_PATH/voltage_now" ]; then
            CUR=$(cat "$BAT_PATH/current_now" 2>/dev/null)
            VOLT=$(cat "$BAT_PATH/voltage_now" 2>/dev/null)
            POWER=$((CUR * VOLT / 1000000000000))
            echo "  Power:    ${POWER}W"
        fi
        GOV=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "unknown")
        echo "  CPU Gov:  $GOV"
        ;;
    battery|power-save)
        echo "◆ Switching to power-saving mode..."
        for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
            echo powersave | sudo tee "$cpu" > /dev/null 2>&1 || true
        done
        sudo sysctl vm.swappiness=60 2>/dev/null || true
        brightnessctl set 40% 2>/dev/null || true
        sudo systemctl stop bluetooth 2>/dev/null || true
        echo "  ✓ Power saving mode active"
        ;;
    performance|perf)
        echo "◆ Switching to performance mode..."
        for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
            echo performance | sudo tee "$cpu" > /dev/null 2>&1 || true
        done
        sudo sysctl vm.swappiness=10 2>/dev/null || true
        brightnessctl set 80% 2>/dev/null || true
        echo "  ✓ Performance mode active"
        ;;
    balanced|normal)
        echo "◆ Switching to balanced mode..."
        for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
            echo ondemand | sudo tee "$cpu" > /dev/null 2>&1 || true
        done
        sudo sysctl vm.swappiness=30 2>/dev/null || true
        brightnessctl set 60% 2>/dev/null || true
        echo "  ✓ Balanced mode active"
        ;;
    threshold)
        LIMIT="${2:-80}"
        echo "◆ Setting charge limit to $LIMIT%..."
        if [ -f "$BAT_PATH/charge_control_end_threshold" ]; then
            echo "$LIMIT" | sudo tee "$BAT_PATH/charge_control_end_threshold" > /dev/null
            echo "  ✓ Charge limit set to $LIMIT%"
        else
            echo "  ⚠ Charge threshold not supported"
        fi
        ;;
    notify)
        while true; do
            BAT=$(get_battery)
            STAT=$(get_status)
            if [ "$BAT" != "none" ]; then
                if [ "$BAT" -le 15 ] && [ "$STAT" = "Discharging" ]; then
                    notify-send "Vajra OS" "Battery low: ${BAT}% — plug in!" -u critical 2>/dev/null
                elif [ "$BAT" -ge 90 ] && [ "$STAT" = "Charging" ]; then
                    notify-send "Vajra OS" "Battery ${BAT}% — unplug to preserve lifespan" 2>/dev/null
                fi
            fi
            sleep 300
        done
        ;;
    *)
        echo "Usage: vajra-power {status|battery|performance|balanced|threshold|notify}"
        ;;
esac
PW
chmod +x "$PW_DIR/power-manager.sh"
ln -sf "$PW_DIR/power-manager.sh" /usr/local/bin/vajra-power 2>/dev/null || true

cat > /etc/systemd/system/vajra-power-notify.service << 'SVC'
[Unit]
Description=Vajra OS Power Notification Daemon
After=graphical.target

[Service]
Type=simple
ExecStart=/opt/vajra/power/power-manager.sh notify
Restart=always
RestartSec=30

[Install]
WantedBy=graphical.target
SVC
systemctl enable vajra-power-notify 2>/dev/null || true

echo "  ✓ Power manager installed"
echo "  ◆ Usage: vajra-power {status|battery|performance|balanced|threshold}"
echo "◆ Done"
