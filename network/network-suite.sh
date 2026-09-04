#!/bin/bash
# Vajra OS — Network Suite
# WireGuard VPN, Firewall, Bandwidth Monitor, Tor Circuit Viewer, Connection Log
set -e
echo "◆ Vajra OS Network Suite"

# WireGuard VPN
cat > /usr/local/bin/vajra-vpn << 'VPN'
#!/bin/bash
case "$1" in
    install) apt-get install -y wireguard wireguard-tools 2>/dev/null || true; echo "✓ WireGuard installed" ;;
    connect) WG_CONF=${2:-"/etc/wireguard/vajra.conf"}; [ ! -f "$WG_CONF" ] && echo "⚠ Config not found: $WG_CONF" && exit 1; wg-quick up "$WG_CONF"; echo "✓ VPN connected" ;;
    disconnect) wg-quick down vajra 2>/dev/null || wg-quick down all 2>/dev/null; echo "✓ VPN disconnected" ;;
    status) wg show 2>/dev/null || echo "VPN not running" ;;
    *) echo "Usage: vajra-vpn [install|connect [config]|disconnect|status]" ;;
esac
VPN
chmod +x /usr/local/bin/vajra-vpn

# Firewall Manager
cat > /usr/local/bin/vajra-firewall << 'FW'
#!/bin/bash
case "$1" in
    status) ufw status verbose 2>/dev/null || firewall-cmd --list-all 2>/dev/null || iptables -L -n -v | head -20 ;;
    on) ufw enable 2>/dev/null || systemctl start firewalld 2>/dev/null || true; echo "✓ Firewall enabled" ;;
    off) ufw disable 2>/dev/null || systemctl stop firewalld 2>/dev/null || true; echo "⚠ Firewall disabled" ;;
    allow) [ -z "$2" ] && echo "Usage: vajra-firewall allow <port>" && exit 1; ufw allow "$2" 2>/dev/null || firewall-cmd --add-port="$2"/tcp --permanent 2>/dev/null; echo "✓ Allowed: $2" ;;
    block) [ -z "$2" ] && echo "Usage: vajra-firewall block <port>" && exit 1; ufw deny "$2" 2>/dev/null || firewall-cmd --remove-port="$2"/tcp --permanent 2>/dev/null; echo "✓ Blocked: $2" ;;
    *) echo "Usage: vajra-firewall [status|on|off|allow <port>|block <port>]" ;;
esac
FW
chmod +x /usr/local/bin/vajra-firewall

# Bandwidth Monitor
cat > /usr/local/bin/vajra-bandwidth << 'BW'
#!/bin/bash
echo "◆ Vajra Bandwidth Monitor"
echo "========================="
for iface in /sys/class/net/*/statistics/*; do
    if [[ "$iface" == */rx_bytes ]]; then
        dev=$(echo "$iface" | cut -d/ -f5)
        rx=$(cat "$iface")
        tx=$(cat "${iface/rx_bytes/tx_bytes}")
        rx_mb=$(echo "scale=2; $rx/1048576" | bc 2>/dev/null || echo "0")
        tx_mb=$(echo "scale=2; $tx/1048576" | bc 2>/dev/null || echo "0")
        echo "  $dev: ↓ ${rx_mb}MB | ↑ ${tx_mb}MB"
    fi
done
if command -v vnstat &>/dev/null; then echo ""; vnstat --oneline 2>/dev/null | head -1; fi
BW
chmod +x /usr/local/bin/vajra-bandwidth

# Tor Circuit Viewer
cat > /usr/local/bin/vajra-tor-circuit << 'TC'
#!/bin/bash
echo "◆ Vajra Tor Circuit"
echo "==================="
if command -v nyx &>/dev/null; then nyx; else echo "Install nyx: sudo apt install nyx"; (echo "authenticate \"\""; echo "getinfo circuit-status"; sleep 1; echo "quit") | nc 127.0.0.1 9051 2>/dev/null || echo "Tor control port not accessible"; fi
TC
chmod +x /usr/local/bin/vajra-tor-circuit

# Connection Log
cat > /usr/local/bin/vajra-connections << 'CL'
#!/bin/bash
echo "◆ Vajra Connection Log"
echo "======================="
echo "Active connections:"
ss -tunp 2>/dev/null | grep -v "^Netid" | head -30 || netstat -tunp 2>/dev/null | head -30
echo ""
echo "Listening ports:"
ss -tlnp 2>/dev/null | grep LISTEN || netstat -tlnp 2>/dev/null | grep LISTEN
CL
chmod +x /usr/local/bin/vajra-connections

echo "◆ Network Suite installed!"
echo "  vajra-vpn [connect|disconnect|status]"
echo "  vajra-firewall [status|on|off|allow|block]"
echo "  vajra-bandwidth"
echo "  vajra-tor-circuit"
echo "  vajra-connections"
