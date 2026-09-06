#!/bin/bash
# Vajra OS Image Editor Setup
set -e
echo "=== Vajra OS Image Editor ==="
echo "  1. Install GIMP (advanced, free)"
echo "  2. Install Krita (painting, free)"
echo "  3. Install Pinta (simple, free)"
echo "  4. Install Darktable (RAW, free)"
echo "  5. Open image editor"
echo "  6. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y gimp 2>/dev/null; echo "[+] GIMP installed"; gimp & ;;
    2) apt-get install -y krita 2>/dev/null; echo "[+] Krita installed"; krita & ;;
    3) apt-get install -y pinta 2>/dev/null; echo "[+] Pinta installed"; pinta & ;;
    4) apt-get install -y darktable 2>/dev/null; echo "[+] Darktable installed"; darktable & ;;
    5) gimp 2>/dev/null || krita 2>/dev/null || echo "No editor installed" ;;
    6) exit 0 ;;
esac