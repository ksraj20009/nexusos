#!/bin/bash
# Vajra OS Video Call Setup
set -e
echo "=== Vajra OS Video Call Setup ==="
echo "  1. Install Zoom (free tier)"
echo "  2. Install Jitsi Meet (free, open source)"
echo "  3. Install Skype (free)"
echo "  4. Open Google Meet (free, browser)"
echo "  5. Test webcam"
echo "  6. Test microphone"
echo "  7. Exit"
read -p "Choice: " choice
case "$choice" in
    1) snap install zoom-client 2>/dev/null; echo "[+] Zoom installed"; zoom-client & ;;
    2) snap install jitsi-meet 2>/dev/null; echo "[+] Jitsi installed"; jitsi-meet & ;;
    3) snap install skype 2>/dev/null; echo "[+] Skype installed"; skype & ;;
    4) xdg-open https://meet.google.com 2>/dev/null; echo "[+] Google Meet opened" ;;
    5) cheese 2>/dev/null & echo "[+] Webcam test (Cheese) started" ;;
    6) arecord -d 3 -f cd /tmp/vajra_mic_test.wav 2>/dev/null && aplay /tmp/vajra_mic_test.wav; echo "[+] Mic test done" ;;
    7) exit 0 ;;
esac