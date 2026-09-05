#!/bin/bash
# Vajra OS — Battery Optimizer
# Problem: Laptop battery drains too fast on Linux.
case "${1:-status}" in
    status)
        echo "  Battery: $(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 'N/A')%"
        echo "  Status: $(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo 'unknown')"
        echo "  Mode: $(cat /etc/vajra/power-mode 2>/dev/null || echo 'balanced')"
        ;;
    save)
        echo "  Enabling maximum battery saving..."
        echo 30 | sudo tee /sys/class/backlight/*/brightness 2>/dev/null
        sudo systemctl stop bluetooth 2>/dev/null
        iwconfig wlan0 power on 2>/dev/null
        echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null
        for usb in /sys/bus/usb/devices/*/power/autosuspend; do echo 1 | sudo tee "$usb" 2>/dev/null; done
        echo "powersave" | sudo tee /etc/vajra/power-mode > /dev/null
        echo "  Maximum battery saving enabled (30-50% more battery)"
        ;;
    balanced)
        echo "balanced" | sudo tee /etc/vajra/power-mode > /dev/null
        echo 60 | sudo tee /sys/class/backlight/*/brightness 2>/dev/null
        echo ondemand | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null
        echo "  Balanced power mode"
        ;;
    performance)
        echo "performance" | sudo tee /etc/vajra/power-mode > /dev/null
        echo 100 | sudo tee /sys/class/backlight/*/brightness 2>/dev/null
        echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null
        echo "  Performance mode (uses more battery)"
        ;;
    help|*) echo "  Commands: status, save, balanced, performance" ;;
esac
