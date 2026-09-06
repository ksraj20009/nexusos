#!/bin/bash
# Vajra OS Bandwidth Monitor
set -e
echo "=== Vajra OS Bandwidth Monitor ==="
echo ""
echo "  Current network interfaces:"
ip -s link show | grep -E "^[0-9]+:|RX:|TX:"
echo ""
echo "  Real-time bandwidth (Ctrl+C to stop):"
echo ""
if command -v ifstat &>/dev/null; then
    ifstat -i 1
elif command -v vnstat &>/dev/null; then
    vnstat -l
else
    echo "  Installing ifstat..."
    apt-get install -y ifstat 2>/dev/null && ifstat -i 1 || echo "Please install ifstat: sudo apt install ifstat"
fi