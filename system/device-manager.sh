#!/bin/bash
# Vajra OS — Device Manager
# View and manage hardware devices (like Windows Device Manager)
set -e

echo "◆ Vajra OS — Device Manager Setup"

DM_DIR="/opt/vajra/devices"
mkdir -p "$DM_DIR"

cat > "$DM_DIR/device-manager.sh" << 'DM'
#!/bin/bash
case "${1:-list}" in
    list)
        echo "╔═══════════════════════════════════════════════╗"
        echo "║  ◆ Vajra OS — Device Manager                 ║"
        echo "╠═══════════════════════════════════════════════╣"
        echo "  CPU:"; lscpu | grep -E "Model name|CPU\(s\)|MHz|Cache" 2>/dev/null
        echo ""; echo "  Memory:"; free -h | awk '/Mem:/ {print "    Total:", $2, " Used:", $3, " Free:", $4}'
        echo ""; echo "  Storage:"; lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT 2>/dev/null | head -15
        echo ""; echo "  Network:"; ip -br link 2>/dev/null
        echo ""; echo "  USB:"; lsusb 2>/dev/null | head -10
        echo ""; echo "  PCI:"; lspci 2>/dev/null | head -10
        echo ""; echo "  Graphics:"; lspci 2>/dev/null | grep -i vga
        ;;
    usb) echo "◆ USB Devices:"; lsusb -v 2>/dev/null | grep -E "Device|idVendor|iProduct" | head -20 ;;
    pci) echo "◆ PCI Devices:"; lspci -v 2>/dev/null | head -30 ;;
    drivers) echo "◆ Loaded Modules:"; lsmod | head -20; echo "  Total: $(lsmod | wc -l)" ;;
    health)
        echo "◆ Hardware Health:"
        echo "  Temperatures:"
        for zone in /sys/class/thermal/thermal_zone*; do
            [ -f "$zone/temp" ] || continue
            TEMP=$(cat "$zone/temp" 2>/dev/null); TYPE=$(cat "$zone/type" 2>/dev/null)
            echo "    $TYPE: $((TEMP/1000))C"
        done
        echo "  SMART (disk health):"
        if command -v smartctl &>/dev/null; then
            for disk in /dev/sd[a-z]; do [ -b "$disk" ] && smartctl -H "$disk" 2>/dev/null | grep -i result; done
        else echo "    Install smartmontools: sudo apt install smartmontools"; fi
        ;;
    benchmark)
        echo "◆ Quick Benchmark:"
        echo "  CPU: Computing pi..."; START=$(date +%s%N); echo "scale=2000; 4*a(1)" | bc -l > /dev/null 2>&1; END=$(date +%s%N); echo "  CPU: $(( (END-START)/1000000 ))ms"
        echo "  Disk:"; dd if=/dev/zero of=/tmp/vajra-dt bs=1M count=100 oflag=direct 2>&1 | tail -1; rm -f /tmp/vajra-dt
        ;;
    *) echo "Usage: vajra-device {list|usb|pci|drivers|health|benchmark}" ;;
esac
DM
chmod +x "$DM_DIR/device-manager.sh"
ln -sf "$DM_DIR/device-manager.sh" /usr/local/bin/vajra-device 2>/dev/null || true

echo "  ✓ Device manager installed"
echo "  ◆ Usage: vajra-device {list|usb|pci|drivers|health|benchmark}"
echo "◆ Done"
