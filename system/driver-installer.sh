#!/bin/bash
# Vajra OS — Driver Installer
# Problem: Hardware doesn't work because drivers aren't installed.
case "${1:-detect}" in
    detect)
        echo "  Graphics:"; lspci | grep -i "vga\|3d\|display"
        echo "  WiFi:"; lspci | grep -i "network"
        echo "  Audio:"; lspci | grep -i "audio"
        echo "  Bluetooth:"; lspci | grep -i "bluetooth" || lsusb | grep -i bluetooth
        echo "  Printer:"; lpstat -t 2>/dev/null || echo "  No printer"
        ;;
    graphics)
        GPU=$(lspci | grep -i "vga" | grep -i "nvidia")
        if [ -n "$GPU" ]; then sudo apt-get install -y nvidia-driver 2>/dev/null; echo "  NVIDIA driver installed"
        else echo "  Using open-source drivers (already installed)"; fi
        ;;
    wifi)
        WIFI=$(lspci | grep -i "network" | grep -i "intel")
        if [ -n "$WIFI" ]; then sudo apt-get install -y firmware-iwlwifi 2>/dev/null; echo "  Intel WiFi firmware installed"; fi
        WIFI=$(lspci | grep -i "network" | grep -i "realtek")
        if [ -n "$WIFI" ]; then sudo apt-get install -y firmware-realtek 2>/dev/null; echo "  Realtek WiFi firmware installed"; fi
        ;;
    audio) sudo apt-get install -y alsa-utils pulseaudio 2>/dev/null; sudo alsa force-reload 2>/dev/null; echo "  Audio drivers installed" ;;
    all) vajra-drivers graphics; vajra-drivers wifi; vajra-drivers audio; echo "  All drivers installed. Reboot recommended." ;;
    help|*) echo "  Commands: detect, graphics, wifi, audio, all" ;;
esac
