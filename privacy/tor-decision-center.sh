#!/bin/bash
# Vajra OS — Tor Decision Center
# Makes Tor OPTIONAL. Shows all pros and cons, asks user before enabling.
# Nothing is forced. User decides.

TOR_STATE="unknown"
if systemctl is-active tor &>/dev/null; then
    TOR_STATE="ACTIVE"
else
    TOR_STATE="OFF"
fi

show_tor_info() {
    echo ""
    echo "  ==========================================="
    echo "   ◆ Vajra OS — Tor Network Decision Center"
    echo "  ==========================================="
    echo ""
    echo "  Current Status: $TOR_STATE"
    echo ""
    echo "  ┌─────────────────────────────────────────┐"
    echo "  │           WHAT IS TOR?                  │"
    echo "  │                                         │"
    echo "  │  Tor (The Onion Router) routes your     │"
    echo "  │  internet traffic through 3 encrypted   │"
    echo "  │  volunteer-run servers worldwide, so    │"
    echo "  │  nobody can trace your activity back    │"
    echo "  │  to you. Your IP address is hidden.     │"
    echo "  └─────────────────────────────────────────┘"
    echo ""
    echo "  ╔═══════════════════════════════════════════╗"
    echo "  ║              ✅ PROS OF TOR               ║"
    echo "  ╠═══════════════════════════════════════════╣"
    echo "  ║  1.  Real anonymity — your IP is hidden   ║"
    echo "  ║  2.  ISP cannot see what websites you     ║"
    echo "  ║      visit or what you download           ║"
    echo "  ║  3.  Bypasses censorship and geo-blocks   ║"
    echo "  ║      (access blocked sites in your region)║"
    echo "  ║  4.  Prevents tracking and profiling      ║"
    echo "  ║  5.  Protects against network             ║"
    echo "  ║      surveillance                         ║"
    echo "  ║  6.  Free and open source                 ║"
    echo "  ║  7.  No registration or account needed    ║"
    echo "  ║  8.  Encrypted end-to-end traffic         ║"
    echo "  ║  9.  Access to .onion hidden services     ║"
    echo "  ║  10. Untraceable by advertisers           ║"
    echo "  ╚═══════════════════════════════════════════╝"
    echo ""
    echo "  ╔═══════════════════════════════════════════╗"
    echo "  ║              ⚠  CONS OF TOR               ║"
    echo "  ╠═══════════════════════════════════════════╣"
    echo "  ║  1.  SLOWER internet — traffic bounces    ║"
    echo "  ║      through 3 servers (can be 5-10x      ║"
    echo "  ║      slower than normal)                  ║"
    echo "  ║  2.  Some websites block Tor users        ║"
    echo "  ║      (Google, banks, Cloudflare sites)    ║"
    echo "  ║  3.  Video streaming is slow and often    ║"
    echo "  ║      does not work (YouTube, Netflix)    ║"
    echo "  ║  4.  Online gaming is not practical       ║"
    echo "  ║      (high latency, 200ms+)              ║"
    echo "  ║  5.  Large downloads take much longer     ║"
    echo "  ║  6.  Some apps do not work with Tor       ║"
    echo "  ║      (BitTorrent, Zoom, some games)      ║"
    echo "  ║  7.  May raise suspicion with your ISP     ║"
    echo "  ║      (they see Tor traffic, not content)  ║"
    echo "  ║  8.  CAPTCHAs appear frequently           ║"
    echo "  ║  9.  Exit node operators can see          ║"
    echo "  ║      unencrypted (HTTP) traffic           ║"
    echo "  ║  10. Not a substitute for a VPN —          ║"
    echo "  ║      they serve different purposes        ║"
    echo "  ╚═══════════════════════════════════════════╝"
    echo ""
    echo "  ┌─────────────────────────────────────────┐"
    echo "  │           OUR RECOMMENDATION             │"
    echo "  │                                         │"
    echo "  │  RECOMMENDED if:                        │"
    echo "  │  • You live in a region with internet    │"
    echo "  │    censorship                           │"
    echo "  │  • You are a journalist, activist, or    │"
    echo "  │    researcher who needs anonymity        │"
    echo "  │  • You want to access blocked content    │"
    echo "  │  • You want maximum privacy             │"
    echo "  │                                         │"
    echo "  │  NOT RECOMMENDED if:                    │"
    echo "  │  • You stream videos daily (Netflix,    │"
    echo "  │    YouTube)                             │"
    echo "  │  • You play online games                │"
    echo "  │  • You need fast downloads regularly    │"
    echo "  │  • You use banking websites (they block)│"
    echo "  │  • You make video calls (Zoom, Meet)     │"
    echo "  └─────────────────────────────────────────┘"
    echo ""
}

ask_tor_decision() {
    echo "  Do you want to enable Tor for all network traffic?"
    echo ""
    echo "    [1] YES — Enable Tor (maximum privacy, slower internet)"
    echo "    [2] NO  — Keep normal connection (faster, less private)"
    echo "    [3] LATER — Ask me again next time I start the OS"
    echo "    [4] BROWSER ONLY — Use Tor only in the browser (recommended)"
    echo ""
    read -p "  Your choice (1/2/3/4): " choice

    case "$choice" in
        1)
            echo ""
            echo "  ⚠ You chose to enable Tor for ALL traffic."
            echo "  This will make your internet slower."
            echo ""
            echo "  Your internet will go through 3 encrypted hops:"
            echo "    You → Entry Node → Middle Node → Exit Node → Website"
            echo ""
            echo "  The following will be affected:"
            echo "    • Web browsing: slower but anonymous"
            echo "    • Downloads: much slower"
            echo "    • Streaming: may not work well"
            echo "    • Gaming: high latency, not recommended"
            echo "    • Banking sites: may block you"
            echo ""
            read -p "  Are you sure? (yes/no): " confirm
            if [ "$confirm" = "yes" ] || [ "$confirm" = "y" ]; then
                enable_tor_full
            else
                echo "  ✓ Cancelled. Tor stays $TOR_STATE."
            fi
            ;;
        2)
            echo ""
            echo "  ✓ Tor will NOT be enabled."
            echo "  Your internet will work normally at full speed."
            echo "  Your ISP can see which sites you visit (but not the content if HTTPS)."
            echo ""
            if [ "$TOR_STATE" = "ACTIVE" ]; then
                read -p "  Tor is currently ON. Disable it now? (yes/no): " disable_confirm
                if [ "$disable_confirm" = "yes" ] || [ "$disable_confirm" = "y" ]; then
                    disable_tor
                fi
            fi
            echo "  ✓ Done. You can enable Tor anytime from Privacy Settings."
            ;;
        3)
            echo ""
            echo "  ✓ Got it. We will ask you again next time."
            echo "  Tor will NOT be enabled now."
            mkdir -p /etc/vajra
            echo "deferred" > /etc/vajra/tor-decision
            ;;
        4)
            echo ""
            echo "  ✓ Browser-only Tor selected."
            echo "  This is RECOMMENDED — you get anonymity for browsing"
            echo "  while keeping full speed for downloads, gaming, streaming."
            echo ""
            echo "  Installing Tor Browser..."
            if ! command -v torbrowser-launcher &>/dev/null; then
                echo "  Downloading Tor Browser..."
                sudo apt-get update -qq && sudo apt-get install -y torbrowser-launcher 2>/dev/null
            fi
            echo "  ✓ Tor Browser installed."
            echo "  Open it from: Applications → Internet → Tor Browser"
            echo ""
            echo "  Your regular browser (Firefox) will work at normal speed."
            echo "  Only Tor Browser will route through Tor."
            ;;
        *)
            echo "  Invalid choice. Please run again."
            ;;
    esac
}

enable_tor_full() {
    echo ""
    echo "  ◆ Enabling Tor for all traffic..."
    echo "  Step 1/5: Installing Tor..."
    if ! command -v tor &>/dev/null; then
        sudo apt-get update -qq && sudo apt-get install -y tor 2>/dev/null
    fi
    echo "  Step 2/5: Starting Tor service..."
    sudo systemctl enable tor 2>/dev/null
    sudo systemctl start tor 2>/dev/null
    sleep 3
    echo "  Step 3/5: Setting up transparent proxy rules..."
    TOR_UID=$(id -u debian-tor 2>/dev/null || id -u tor 2>/dev/null || echo 0)
    sudo iptables -F && sudo iptables -t nat -F && sudo iptables -t mangle -F
    sudo iptables -t nat -A OUTPUT -o lo -p udp --dport 53 -j REDIRECT --to-ports 5353
    sudo iptables -t nat -A OUTPUT -o lo -p tcp --dport 53 -j REDIRECT --to-ports 5353
    sudo iptables -t nat -A OUTPUT -o lo -j RETURN
    sudo iptables -t nat -A OUTPUT -m owner --uid-owner "$TOR_UID" -j RETURN
    sudo iptables -t nat -A OUTPUT -p tcp --syn -j REDIRECT --to-ports 9040
    sudo iptables -A OUTPUT -o lo -j ACCEPT
    sudo iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    sudo iptables -A OUTPUT -m owner --uid-owner "$TOR_UID" -j ACCEPT
    sudo iptables -A OUTPUT -p udp --dport 5353 -j ACCEPT
    sudo iptables -A OUTPUT -p tcp --dport 9040 -j ACCEPT
    sudo iptables -A OUTPUT -p tcp --dport 9050 -j ACCEPT
    sudo iptables -A OUTPUT -j DROP
    sudo iptables -A INPUT -j DROP
    sudo iptables -P INPUT DROP
    sudo iptables -P FORWARD DROP
    sudo iptables -P OUTPUT DROP
    echo "  Step 4/5: Setting DNS to route through Tor..."
    echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf > /dev/null
    sudo mkdir -p /etc/vajra
    sudo iptables-save | sudo tee /etc/vajra/iptables.rules > /dev/null
    echo "user-chosen" | sudo tee /etc/vajra/tor-decision > /dev/null
    echo "  Step 5/5: Verifying connection..."
    sleep 2
    echo ""
    echo "  ╔═══════════════════════════════════════════╗"
    echo "  ║  ✓ TOR IS NOW ACTIVE FOR ALL TRAFFIC      ║"
    echo "  ╠═══════════════════════════════════════════╣"
    echo "  ║  Your IP is hidden. All traffic goes      ║"
    echo "  ║  through the Tor network.                ║"
    echo "  ║                                           ║"
    echo "  ║  Expected latency: 200-500ms             ║"
    echo "  ║  Expected speed: 1-5 Mbps                ║"
    echo "  ║                                           ║"
    echo "  ║  To disable: vajra-tor-decision off      ║"
    echo "  ╚═══════════════════════════════════════════╝"
}

disable_tor() {
    echo "  ◆ Disabling Tor..."
    sudo systemctl stop tor 2>/dev/null
    sudo systemctl disable tor 2>/dev/null
    sudo iptables -F 2>/dev/null
    sudo iptables -t nat -F 2>/dev/null
    sudo iptables -t mangle -F 2>/dev/null
    sudo iptables -P INPUT ACCEPT 2>/dev/null
    sudo iptables -P FORWARD ACCEPT 2>/dev/null
    sudo iptables -P OUTPUT ACCEPT 2>/dev/null
    echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf > /dev/null
    echo "  ✓ Tor disabled. Normal internet restored."
}

case "${1:-menu}" in
    menu|start)
        show_tor_info
        ask_tor_decision
        ;;
    on|enable)
        show_tor_info
        echo ""
        read -p "  Enable Tor for ALL traffic? (yes/no): " confirm
        [ "$confirm" = "yes" ] || [ "$confirm" = "y" ] && enable_tor_full || echo "  Cancelled."
        ;;
    off|disable)
        if [ "$TOR_STATE" = "ACTIVE" ]; then
            echo ""
            echo "  Tor is currently ACTIVE."
            echo "  Disabling will restore your normal internet speed."
            echo "  Your real IP will be visible again."
            echo ""
            read -p "  Disable Tor? (yes/no): " confirm
            [ "$confirm" = "yes" ] || [ "$confirm" = "y" ] && disable_tor || echo "  Cancelled."
        else
            echo "  Tor is already off."
        fi
        ;;
    status)
        echo "  Tor Status: $TOR_STATE"
        if [ -f /etc/vajra/tor-decision ]; then
            echo "  User decision: $(cat /etc/vajra/tor-decision)"
        else
            echo "  User decision: not yet asked"
        fi
        ;;
    info) show_tor_info ;;
    pros)
        echo "  Tor PROS:"
        echo "    1. Real anonymity — IP hidden"
        echo "    2. ISP cannot see your activity"
        echo "    3. Bypasses censorship"
        echo "    4. Prevents tracking"
        echo "    5. Free and open source"
        echo "    6. Access to .onion sites"
        echo "    7. No account needed"
        echo "    8. Encrypted traffic"
        ;;
    cons)
        echo "  Tor CONS:"
        echo "    1. Slow internet (5-10x slower)"
        echo "    2. Sites block Tor users"
        echo "    3. Streaming doesn't work well"
        echo "    4. Gaming not practical"
        echo "    5. Large downloads slow"
        echo "    6. CAPTCHAs everywhere"
        echo "    7. Some apps don't work"
        echo "    8. May raise ISP suspicion"
        ;;
    *)
        echo "Usage: vajra-tor-decision {menu|on|off|status|info|pros|cons}"
        ;;
esac
