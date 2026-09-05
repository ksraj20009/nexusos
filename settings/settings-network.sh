#!/bin/bash
# Vajra OS — Network Settings
set -e
echo "◆ Vajra OS — Network Settings Setup"
SD_DIR="/opt/vajra/settings"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/settings-network.sh" << 'NET'
#!/bin/bash
case "${1:-status}" in
    status)
        echo "  Vajra OS - Network Settings"
        echo "  Interfaces:"
        ip -br addr 2>/dev/null | while read -r name state ipaddr; do echo "    $name: $state $ipaddr"; done
        echo "  WiFi:"
        nmcli -t -f NAME,TYPE,DEVICE con show 2>/dev/null | grep wifi | head -5
        echo "  WiFi State: $(nmcli radio wifi 2>/dev/null)"
        echo "  DNS: $(grep nameserver /etc/resolv.conf 2>/dev/null | awk '{print $2}' | head -3)"
        echo "  Proxy: ${http_proxy:-none}"
        echo "  VPN: $(ip link show wg0 &>/dev/null && echo 'connected' || ip link show tun0 &>/dev/null && echo 'connected' || echo 'none')"
        echo "  Tor: $(systemctl is-active tor 2>/dev/null || echo 'off')"
        ;;
    wifi) nmcli device wifi list 2>/dev/null | head -15 ;;
    wifi-connect)
        SSID="$2"; PASS="$3"
        [ -z "$SSID" ] && echo "  Usage: vajra-settings network wifi-connect <SSID> [password]" && exit 1
        if [ -n "$PASS" ]; then nmcli device wifi connect "$SSID" password "$PASS" 2>/dev/null
        else nmcli device wifi connect "$SSID" 2>/dev/null; fi
        echo "  ✓ Connected to $SSID"
        ;;
    wifi-on) nmcli radio wifi on 2>/dev/null; echo "  ✓ WiFi enabled" ;;
    wifi-off) nmcli radio wifi off 2>/dev/null; echo "  ✓ WiFi disabled" ;;
    wifi-forget) nmcli connection delete "$2" 2>/dev/null; echo "  ✓ Forgot $2" ;;
    hotspot) SSID="${2:-Vajra-Hotspot}"; PASS="${3:-vajra123}"; nmcli device wifi hotspot ssid "$SSID" password "$PASS" 2>/dev/null; echo "  ✓ Hotspot started: $SSID" ;;
    dns)
        DNS="$2"
        [ -z "$DNS" ] && echo "  Current DNS:" && grep nameserver /etc/resolv.conf && exit 0
        echo "nameserver $DNS" | sudo tee /etc/resolv.conf; echo "  ✓ DNS set to $DNS"
        ;;
    proxy)
        PROXY="$2"
        [ -z "$PROXY" ] && echo "  Current: $http_proxy" && exit 0
        export http_proxy="$PROXY"; export https_proxy="$PROXY"; echo "  ✓ Proxy set to $PROXY"
        ;;
    vpn)
        echo "  VPN status:"
        ip link show wg0 2>/dev/null && echo "  WireGuard: UP" || echo "  WireGuard: DOWN"
        ip link show tun0 2>/dev/null && echo "  OpenVPN: UP" || echo "  OpenVPN: DOWN"
        ;;
    vpn-connect)
        CONFIG="$2"
        [ -z "$CONFIG" ] && echo "  Usage: vajra-settings network vpn-connect <config.ovpn>" && exit 1
        sudo openvpn --config "$CONFIG" & echo "  ✓ VPN connecting..."
        ;;
    tor)
        case "${2:-status}" in
            on|enable) sudo systemctl start tor 2>/dev/null; echo "  ✓ Tor started" ;;
            off|disable) sudo systemctl stop tor 2>/dev/null; echo "  ✓ Tor stopped" ;;
            status) systemctl is-active tor 2>/dev/null ;;
        esac
        ;;
    eth) ip addr show eth0 2>/dev/null || ip addr show enp0s3 2>/dev/null || echo "  No ethernet" ;;
    ip) ip addr show 2>/dev/null | grep "inet " | awk '{print "    "$2" on "$NF}' ;;
    *) echo "Usage: vajra-settings network {status|wifi|wifi-connect|wifi-on|wifi-off|hotspot|dns|proxy|vpn|tor|ip}" ;;
esac
NET
chmod +x "$SD_DIR/settings-network.sh"
ln -sf "$SD_DIR/settings-network.sh" /usr/local/bin/vajra-settings-network 2>/dev/null || true
echo "  ✓ Network settings installed"
echo "◆ Done"
