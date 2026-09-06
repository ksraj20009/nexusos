#!/bin/bash
# Vajra OS Audio Equalizer
set -e
echo "=== Vajra OS Audio Equalizer ==="
echo "[*] Installing PulseAudio equalizer (free)..."
apt-get install -y pulseaudio-equalizer 2>/dev/null || true
echo "  1. Enable equalizer"
echo "  2. Set preset (Bass/Mid/Treble/Vocal/Cinema)"
echo "  3. Disable equalizer"
echo "  4. Exit"
read -p "Choice: " choice
case "$choice" in
    1) qpaeq 2>/dev/null & echo "[+] Equalizer opened" ;;
    2) echo "Presets available in qpaeq GUI"
       echo "  Bass Boost: low freq +10dB"
       echo "  Vocal: mid freq +5dB"
       echo "  Cinema: surround simulation"
       qpaeq & ;;
    3) pulseaudio-equalizer disable 2>/dev/null; echo "[+] Equalizer disabled" ;;
    4) exit 0 ;;
esac