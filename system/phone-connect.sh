#!/bin/bash
# Vajra OS — Phone Connect
# Problem: People can't easily connect their Android/iPhone to Linux.
case "${1:-help}" in
    android)
        echo "  Connecting Android phone..."
        sudo apt-get install -y kdeconnect 2>/dev/null
        echo "  1. Install KDE Connect on Android (Play Store)"
        echo "  2. Phone and PC on same WiFi"
        echo "  3. Pair in KDE Connect app"
        echo "  Features: Share files, notifications, clipboard, remote control"
        ;;
    iphone)
        echo "  Connecting iPhone..."
        sudo apt-get install -y ifuse libimobiledevice-tools 2>/dev/null
        echo "  1. Plug iPhone via USB"
        echo "  2. Trust computer on iPhone"
        echo "  3. Mount: ifuse ~/iphone"
        ;;
    share) echo "  Share files: scp file.jpg phone-ip:/sdcard/Pictures/ or use KDE Connect" ;;
    help|*) echo "  Commands: android, iphone, share" ;;
esac
