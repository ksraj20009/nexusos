#!/bin/bash
# Vajra OS — App Store & Privacy Apps Suite
set -e
echo "◆ Vajra OS App Store Suite"

# Flatpak App Store
cat > /usr/local/bin/vajra-app-store << 'AS'
#!/bin/bash
case "$1" in
    setup) sudo apt-get install -y flatpak 2>/dev/null || true; flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true; echo "✓ Flatpak + Flathub configured" ;;
    install) [ -z "$2" ] && echo "Usage: vajra-app-store install <app-id>" && exit 1; flatpak install -y flathub "$2" ;;
    search) [ -z "$2" ] && echo "Usage: vajra-app-store search <name>" && exit 1; flatpak search "$2" ;;
    list) flatpak list ;;
    update) flatpak update -y ;;
    remove) [ -z "$2" ] && echo "Usage: vajra-app-store remove <app-id>" && exit 1; flatpak uninstall -y "$2" ;;
    essentials)
        flatpak install -y flathub org.libreoffice.LibreOffice 2>/dev/null || true
        flatpak install -y flathub org.gimp.GIMP 2>/dev/null || true
        flatpak install -y flathub org.inkscape.Inkscape 2>/dev/null || true
        flatpak install -y flathub com.spotify.Client 2>/dev/null || true
        flatpak install -y flathub org.videolan.VLC 2>/dev/null || true
        flatpak install -y flathub com.obsproject.Studio 2>/dev/null || true
        flatpak install -y flathub org.keepassxc.KeePassXC 2>/dev/null || true
        flatpak install -y flathub com.transmissionbt.Transmission 2>/dev/null || true
        flatpak install -y flathub org.signal.Signal 2>/dev/null || true
        flatpak install -y flathub im.riot.Riot 2>/dev/null || true
        echo "✓ Essential apps installed"
        ;;
    *) echo "Usage: vajra-app-store [setup|install <id>|search <name>|list|update|remove <id>|essentials]" ;;
esac
AS
chmod +x /usr/local/bin/vajra-app-store

# Vaultwarden (self-hosted password manager)
cat > /usr/local/bin/vajra-vault << 'VV'
#!/bin/bash
case "$1" in
    install) docker run -d --name vajra-vault -v /var/lib/vajra/vault:/data -p 8222:80 --restart unless-stopped vaultwarden/server:latest 2>/dev/null || echo "Install Docker first: sudo apt install docker.io"; echo "✓ Vaultwarden at http://localhost:8222" ;;
    start) docker start vajra-vault 2>/dev/null && echo "✓ Vault started" ;;
    stop) docker stop vajra-vault 2>/dev/null && echo "✓ Vault stopped" ;;
    backup) mkdir -p /var/lib/vajra/vault-backup; docker exec vajra-vault sqlite3 /data/db.sqlite3 ".backup '/var/lib/vajra/vault-backup/backup-$(date +%Y%m%d).sqlite3'" 2>/dev/null; echo "✓ Vault backed up" ;;
    *) echo "Usage: vajra-vault [install|start|stop|backup]" ;;
esac
VV
chmod +x /usr/local/bin/vajra-vault

# Hardened Firefox Config
mkdir -p /etc/firefox/syspref.js.d
cat > /etc/firefox/syspref.js.d/vajra-hardened.js << 'FF'
pref("browser.privatebrowsing.autostart", true);
pref("privacy.resistFingerprinting", true);
pref("privacy.trackingprotection.enabled", true);
pref("privacy.trackingprotection.fingerprinting.enabled", true);
pref("privacy.trackingprotection.cryptomining.enabled", true);
pref("network.dns.disablePrefetch", true);
pref("network.prefetch-next", false);
pref("media.peerconnection.enabled", false);
pref("geolocation.enabled", false);
pref("dom.webnotifications.enabled", false);
pref("dom.push.enabled", false);
pref("browser.send_pings", false);
pref("network.cookie.lifetimePolicy", 2);
pref("privacy.sanitize.sanitizeOnShutdown", true);
pref("privacy.clearOnShutdown.cookies", true);
pref("privacy.clearOnShutdown.cache", true);
pref("privacy.clearOnShutdown.history", true);
pref("datareporting.policy.dataSubmissionEnabled", false);
pref("toolkit.telemetry.enabled", false);
pref("app.shield.optoutstudies.enabled", false);
pref("browser.discovery.enabled", false);
pref("security.ssl.require_safe_negotiation", true);
pref("security.tls.version.min", 3);
pref("security.OCSP.require", true);
FF

# Browser Extensions Guide
cat > /usr/local/bin/vajra-browser-extensions << 'BE'
#!/bin/bash
echo "◆ Vajra Browser Extensions (install manually)"
echo "  1. uBlock Origin — Ad/tracker blocker"
echo "  2. Privacy Badger — Tracker blocker"
echo "  3. Decentraleyes — CDN tracking bypass"
echo "  4. Cookie AutoDelete — Auto-delete cookies"
echo "  5. Containerise — Isolate websites"
echo "  6. NoScript — JavaScript control"
echo "  7. Bitwarden — Password manager (syncs with Vajra Vault)"
echo "  8. tor-socks-proxy — Route Firefox through Tor"
BE
chmod +x /usr/local/bin/vajra-browser-extensions

echo "◆ App Store Suite installed!"
echo "  vajra-app-store [setup|install|search|list|update|essentials]"
echo "  vajra-vault [install|start|stop|backup]"
echo "  vajra-browser-extensions"
echo "  Firefox hardened config at /etc/firefox/syspref.js.d/vajra-hardened.js"
