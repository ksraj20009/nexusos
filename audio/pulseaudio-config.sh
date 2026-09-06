#!/bin/bash
# Vajra OS PulseAudio Configuration (free, built-in)
set -e
echo "=== Vajra OS Audio Configuration ==="
echo "[*] Audio devices:"
pactl list short sinks 2>/dev/null || echo "PulseAudio not running"
echo ""
echo "  1. List audio devices"
echo "  2. Set default output"
echo "  3. Set volume"
echo "  4. Mute/unmute"
echo "  5. Test audio"
echo "  6. Restart audio"
echo "  7. Exit"
read -p "Choice: " choice
case "$choice" in
    1) pactl list short sinks; pactl list short sources ;;
    2) read -p "Sink number: " s; pactl set-default-sink "$s" && echo "[+] Default output set" ;;
    3) read -p "Volume (0-150): " v; pactl set-sink-volume @DEFAULT_SINK@ "${v}%" && echo "[+] Volume set to ${v}%" ;;
    4) pactl set-sink-mute @DEFAULT_SINK@ toggle && echo "[+] Muted/unmuted" ;;
    5) speaker-test -t sine -f 440 -l 2 2>/dev/null && echo "[+] Audio test done" ;;
    6) systemctl --user restart pulseaudio 2>/dev/null; pulseaudio -k 2>/dev/null; sleep 2; pulseaudio --start 2>/dev/null; echo "[+] Audio restarted" ;;
    7) exit 0 ;;
esac