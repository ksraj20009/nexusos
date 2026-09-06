#!/bin/bash
# Vajra OS Secure Boot Configuration
set -e
echo "=== Vajra OS Secure Boot Setup ==="
echo ""
echo "Current Secure Boot status:"
if ls /sys/firmware/efi/efivars/SecureBoot-* 2>/dev/null; then
    sb_state=$(od -An -tx1 /sys/firmware/efi/efivars/SecureBoot-* 2>/dev/null | tr -d ' ')
    if [ "$sb_state" = "0000000001" ] || [ "$sb_state" = "0100000001" ]; then
        echo "  Status: ENABLED"
    else
        echo "  Status: DISABLED"
    fi
else
    echo "  Status: Not available (BIOS mode or no EFI)"
fi
echo ""
echo "  1. Check Secure Boot status"
echo "  2. Install MOK tools (for custom keys)"
echo "  3. Enroll MOK key"
echo "  4. Verify kernel signature"
echo "  5. Exit"
read -p "Choice: " choice
case "$choice" in
    1) mokutil --sb-state 2>/dev/null || echo "mokutil not installed" ;;
    2) apt-get install -y mokutil shim-tools 2>/dev/null; echo "[+] MOK tools installed" ;;
    3) echo "To enroll a MOK key, reboot and follow the MOK Manager prompt" ;;
    4) modinfo -F signer "$(uname -r)" 2>/dev/null || echo "Cannot verify" ;;
    5) exit 0 ;;
esac