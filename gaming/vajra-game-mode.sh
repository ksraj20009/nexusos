#!/bin/bash
# Vajra OS Game Mode - optimize system for gaming
set -e
echo "=== Vajra OS Game Mode ==="
echo "[*] Enabling game mode..."
echo "  - Setting CPU governor to performance"
echo "  - Disabling screensaver"
echo "  - Killing heavy background processes"
for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
    echo performance > "$cpu" 2>/dev/null || true
done
xset s off 2>/dev/null || true
xset -dpms 2>/dev/null || true
pkill -f update-notifier 2>/dev/null || true
pkill -f packagekit 2>/dev/null || true
echo "[+] Game mode enabled"
echo "[*] To disable: reboot or restore CPU governor to powersave"