#!/bin/bash
# Vajra OS — Offline Mode Manager
# Problem: People in areas with no internet still need to use their computer.
case "${1:-status}" in
    status)
        echo "  Vajra OS - Offline Mode"
        echo "  Internet: $(ping -c 1 -W 2 8.8.8.8 &>/dev/null && echo AVAILABLE || echo OFFLINE)"
        echo "  Mode: $(cat /etc/vajra/mode 2>/dev/null || echo 'online')"
        echo "  Cached docs: $(ls /opt/vajra/offline-docs/ 2>/dev/null | wc -l)"
        ;;
    enable) mkdir -p /opt/vajra/offline-docs; echo "offline" > /etc/vajra/mode; echo "  Offline mode enabled" ;;
    disable) echo "online" > /etc/vajra/mode; echo "  Online mode restored" ;;
    cache-docs) mkdir -p /opt/vajra/offline-docs; man bash > /opt/vajra/offline-docs/bash-guide.txt 2>/dev/null; echo "  Docs cached" ;;
    cache-wikipedia) echo "  Install Kiwix: sudo apt-get install kiwix"; echo "  Download .zim files from kiwix.org" ;;
    cache-maps) echo "  Install gnome-maps, download from OpenStreetMap" ;;
    help|*) echo "  Commands: status, enable, disable, cache-docs, cache-wikipedia, cache-maps" ;;
esac
