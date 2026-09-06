#!/bin/bash
# Vajra OS Multi-Monitor Setup (free, xrandr built-in)
set -e
echo "=== Vajra OS Multi-Monitor Setup ==="
echo "Connected displays:"
xrandr --query | grep " connected" 2>/dev/null || echo "No displays detected"
echo ""
echo "  1. Mirror displays"
echo "  2. Extend desktop"
echo "  3. External only"
echo "  4. Internal only"
echo "  5. Auto-arrange"
echo "  6. Set primary"
echo "  7. Exit"
read -p "Choice: " choice
DISP1=$(xrandr | grep ' connected' | head -1 | awk '{print $1}')
DISP2=$(xrandr | grep ' connected' | sed -n 2p | awk '{print $1}')
case "$choice" in
    1) [ -n "$DISP2" ] && xrandr --output "$DISP1" --auto --output "$DISP2" --auto --same-as "$DISP1" 2>/dev/null; echo "[+] Displays mirrored" ;;
    2) [ -n "$DISP2" ] && xrandr --output "$DISP1" --auto --output "$DISP2" --auto --right-of "$DISP1" 2>/dev/null; echo "[+] Desktop extended" ;;
    3) [ -n "$DISP2" ] && xrandr --output "$DISP1" --off --output "$DISP2" --auto 2>/dev/null; echo "[+] External only" ;;
    4) xrandr --output "$DISP1" --auto 2>/dev/null; [ -n "$DISP2" ] && xrandr --output "$DISP2" --off 2>/dev/null; echo "[+] Internal only" ;;
    5) xrandr --auto 2>/dev/null; echo "[+] Auto-arranged" ;;
    6) read -p "Display name: " d; xrandr --output "$d" --primary 2>/dev/null; echo "[+] $d set as primary" ;;
    7) exit 0 ;;
esac