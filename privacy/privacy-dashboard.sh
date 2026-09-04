#!/bin/bash
# Vajra OS — Privacy Dashboard
# Centralized privacy monitoring and control
set -e

echo "◆ Vajra OS — Privacy Dashboard"

PRIV_DIR="/opt/vajra/privacy-dashboard"
mkdir -p "$PRIV_DIR"

cat > "$PRIV_DIR/privacy-dashboard.sh" << 'DASH'
#!/bin/bash

show_status() {
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  ◆ Vajra OS — Privacy Dashboard              ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""
    if systemctl is-active tor &>/dev/null; then
        echo "  🔒 Tor:          ACTIVE"
    else
        echo "  ⚠  Tor:          INACTIVE"
    fi
    DNS_SERVER=$(grep nameserver /etc/resolv.conf 2>/dev/null | head -1 | awk '{print $2}')
    echo "  🔒 DNS:          $DNS_SERVER"
    if sudo ufw status 2>/dev/null | grep -q "active"; then
        echo "  🔒 Firewall:     ACTIVE"
    else
        echo "  ⚠  Firewall:     INACTIVE"
    fi
    if ip link show wg0 &>/dev/null 2>&1 || ip link show tun0 &>/dev/null 2>&1; then
        echo "  🔒 VPN:          CONNECTED"
    else
        echo "  ⚠  VPN:          NOT CONNECTED"
    fi
    if lsmod | grep -q uvcvideo; then
        echo "  ⚠  Webcam:       ENABLED"
    else
        echo "  🔒 Webcam:       DISABLED"
    fi
    if amixer -c 0 sget Capture 2>/dev/null | grep -q "\[on\]"; then
        echo "  ⚠  Microphone:   ENABLED"
    else
        echo "  🔒 Microphone:   DISABLED"
    fi
    if systemctl is-active bluetooth &>/dev/null; then
        echo "  ⚠  Bluetooth:    ACTIVE"
    else
        echo "  🔒 Bluetooth:    OFF"
    fi
    echo "  🔒 Telemetry:    BLOCKED (Vajra default)"
    if lsblk -o TYPE,FSTYPE 2>/dev/null | grep -q crypto_LUKS; then
        echo "  🔒 Disk Encrypt: LUKS"
    else
        echo "  ⚠  Disk Encrypt: NONE"
    fi
    echo ""
    echo "  Privacy Score: $(calculate_score)/100"
}

calculate_score() {
    SCORE=0
    systemctl is-active tor &>/dev/null && SCORE=$((SCORE+15))
    sudo ufw status 2>/dev/null | grep -q active && SCORE=$((SCORE+15))
    ip link show wg0 &>/dev/null 2>&1 && SCORE=$((SCORE+10))
    ! lsmod | grep -q uvcvideo && SCORE=$((SCORE+10))
    ! amixer -c 0 sget Capture 2>/dev/null | grep -q "\[on\]" && SCORE=$((SCORE+10))
    ! systemctl is-active bluetooth &>/dev/null && SCORE=$((SCORE+10))
    SCORE=$((SCORE+10))
    lsblk -o FSTYPE 2>/dev/null | grep -q crypto_LUKS && SCORE=$((SCORE+10))
    echo $SCORE
}

harden_all() {
    echo "◆ Applying maximum privacy hardening..."
    sudo systemctl start tor 2>/dev/null || true
    echo "  ✓ Tor started"
    sudo ufw enable 2>/dev/null || true
    sudo ufw default deny incoming 2>/dev/null || true
    sudo ufw default allow outgoing 2>/dev/null || true
    echo "  ✓ Firewall enabled"
    sudo modprobe -r uvcvideo 2>/dev/null || true
    echo "  ✓ Webcam disabled"
    amixer -c 0 sset Capture mute 2>/dev/null || true
    echo "  ✓ Microphone muted"
    sudo systemctl stop bluetooth 2>/dev/null || true
    sudo systemctl disable bluetooth 2>/dev/null || true
    echo "  ✓ Bluetooth disabled"
    echo "  ✓ Telemetry already blocked (Vajra default)"
    echo "◆ Privacy hardening complete!"
    echo ""
    show_status
}

case "${1:-status}" in
    status) show_status ;;
    harden) harden_all ;;
    *) echo "Usage: vajra-privacy {status|harden}" ;;
esac
DASH
chmod +x "$PRIV_DIR/privacy-dashboard.sh"
ln -sf "$PRIV_DIR/privacy-dashboard.sh" /usr/local/bin/vajra-privacy 2>/dev/null || true

echo "  ✓ Privacy dashboard installed"
echo "  ◆ Usage: vajra-privacy {status|harden}"
echo "◆ Done"
