#!/bin/bash
# Vajra OS Display Calibrator
set -e
echo "=== Vajra OS Display Calibrator ==="
echo "  1. Install calibration tools"
echo "  2. Quick color adjustment"
echo "  3. Set gamma"
echo "  4. Set brightness (software)"
echo "  5. Reset to defaults"
echo "  6. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y xcalib dispwin argyllcms 2>/dev/null; echo "[+] Calibration tools installed" ;;
    2) echo "Adjusting gamma to 1.0..."
       xgamma -gamma 1.0 2>/dev/null || echo "Use: xgamma -gamma 0.8 (darker) or 1.2 (brighter)" ;;
    3) read -p "Gamma value (0.5-2.0, default 1.0): " g; xgamma -gamma "${g:-1.0}" 2>/dev/null; echo "[+] Gamma set to ${g:-1.0}" ;;
    4) read -p "Brightness (10-100): " b; xrandr --output "$(xrandr | grep ' connected' | head -1 | cut -d' ' -f1)" --brightness "0.$b" 2>/dev/null; echo "[+] Brightness set to ${b}%" ;;
    5) xgamma -gamma 1.0 2>/dev/null; xrandr --output "$(xrandr | grep ' connected' | head -1 | cut -d' ' -f1)" --brightness 1.0 2>/dev/null; echo "[+] Reset to defaults" ;;
    6) exit 0 ;;
esac