#!/bin/bash
# Vajra OS Browser Privacy Setup
# Pre-configures Firefox with privacy extensions
set -e
echo "=== Vajra OS Browser Privacy Setup ==="
echo "[*] Installing Firefox..."
apt-get install -y firefox-esr 2>/dev/null || true
echo "[*] Configuring Firefox privacy settings..."
mkdir -p /etc/firefox/pref
cat > /etc/firefox/pref/vajra-privacy.js << 'PREF'
// Vajra OS Firefox Privacy Configuration
pref("privacy.trackingprotection.enabled", true);
pref("privacy.donottrackheader.enabled", true);
pref("network.dns.disablePrefetch", true);
pref("network.prefetch-next", false);
pref("browser.send_pings", false);
pref("browser.safebrowsing.malware.enabled", true);
pref("browser.safebrowsing.phishing.enabled", true);
pref("privacy.sanitize.sanitizeOnShutdown", true);
pref("privacy.clearOnShutdown.cookies", true);
pref("privacy.clearOnShutdown.history", true);
pref("privacy.clearOnShutdown.cache", true);
pref("media.peerconnection.enabled", false);
pref("geo.enabled", false);
pref("webgl.disabled", true);
PREF
echo "[+] Firefox privacy settings configured"
echo "[*] Recommended extensions (install manually from Firefox Add-ons):"
echo "  - uBlock Origin (ad blocker)"
echo "  - Privacy Badger (tracker blocker)"
echo "  - HTTPS Everywhere (force HTTPS)"
echo "  - Decentraleyes (local CDN emulation)"
echo "  - Cookie AutoDelete (auto-clear cookies)"
echo "  - NoScript (JavaScript control)"
echo ""
echo "=== Browser Privacy Setup Complete ==="