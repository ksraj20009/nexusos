#!/bin/bash
# ============================================================
#  NexusOS Transparent Tor Proxy Setup
#  Configures iptables to route ALL traffic through Tor
# ============================================================
set -e

echo "◆ NexusOS Tor Transparent Proxy Setup"
echo "======================================"

# Check root
if [[ $EUID -ne 0 ]]; then
    echo "Error: Run as root: sudo ./setup-tor-proxy.sh"
    exit 1
fi

# --- 1. Install Tor ---
echo "[1/5] Installing Tor..."
pacman -S --noconfirm tor
systemctl enable tor

# --- 2. Copy config ---
echo "[2/5] Configuring Tor..."
cp /opt/nexusos/privacy/torrc /etc/tor/torrc
chown tor:tor /etc/tor/torrc
chmod 644 /etc/tor/torrc

# --- 3. Start Tor ---
echo "[3/5] Starting Tor..."
systemctl start tor
sleep 3

# Wait for Tor to bootstrap
echo "  Waiting for Tor to bootstrap..."
for i in $(seq 1 30); do
    if systemctl is-active --quiet tor; then
        echo "  ✓ Tor is running"
        break
    fi
    sleep 1
done

# --- 4. Configure iptables for transparent proxy ---
echo "[4/5] Configuring firewall rules..."

# Get the UID of the tor user
TOR_UID=$(id -u tor)

# Flush existing rules
iptables -F
iptables -t nat -F
iptables -t mangle -F

# --- NAT table ---
# Redirect DNS to Tor's DNS port
iptables -t nat -A OUTPUT -o lo -p udp --dport 53 -j REDIRECT --to-ports 5353
iptables -t nat -A OUTPUT -o lo -p tcp --dport 53 -j REDIRECT --to-ports 5353

# Allow loopback
iptables -t nat -A OUTPUT -o lo -j RETURN

# Skip Tor's own traffic
iptables -t nat -A OUTPUT -m owner --uid-owner $TOR_UID -j RETURN

# Redirect TCP traffic to Tor's transparent port
iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040

# --- Filter table ---
# Accept loopback
iptables -A OUTPUT -o lo -j ACCEPT

# Accept established connections
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow Tor's own traffic
iptables -A OUTPUT -m owner --uid-owner $TOR_UID -j ACCEPT

# Allow DNS to Tor's DNS port
iptables -A OUTPUT -p udp --dport 5353 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5353 -j ACCEPT

# Allow redirected traffic to Tor's transparent port
iptables -A OUTPUT -p tcp --dport 9040 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 9050 -j ACCEPT

# Drop everything else
iptables -A OUTPUT -j DROP

# --- Input chain — drop all incoming ---
iptables -A INPUT -j DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

# --- 5. DNS configuration ---
echo "[5/5] Configuring DNS..."
# Use Tor's DNS resolver
echo "nameserver 127.0.0.1" > /etc/resolv.conf

# --- Save rules ---
echo "Saving firewall rules..."
iptables-save > /etc/nexusos/iptables.rules

echo ""
echo "◆ Tor Transparent Proxy Active!"
echo "  All traffic is now routed through Tor."
echo "  DNS is resolved via Tor (port 5353)"
echo "  TCP is redirected to Tor (port 9040)"
echo "  Direct connections are blocked"
echo ""
echo "  Check status: curl --socks5 127.0.0.1:9050 https://check.torproject.org"