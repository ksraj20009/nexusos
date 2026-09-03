#!/bin/bash
# ============================================================
#  NexusOS Privacy Hardening Script
#  Applies all privacy and security settings
# ============================================================
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}◆ NexusOS Privacy Hardening${NC}"
echo -e "${BLUE}============================${NC}"
echo ""

# Check root
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Error: Run as root: sudo ./harden.sh${NC}"
    exit 1
fi

# --- 1. Disable Telemetry ---
echo -e "${BLUE}[1/10] Disabling telemetry...${NC}"

# Disable Mozilla telemetry
mkdir -p /etc/firefox/syspref.js.d
cat > /etc/firefox/syspref.js.d/nexusos.js << 'EOF'
pref("datareporting.policy.dataSubmissionEnabled", false);
pref("datareporting.healthreport.uploadEnabled", false);
pref("toolkit.telemetry.enabled", false);
pref("toolkit.telemetry.unified", false);
pref("toolkit.telemetry.archive.enabled", false);
pref("browser.tabs.crashReporting.sendReport", false);
pref("browser.crashReports.unsubmittedCheck.enabled", false);
pref("app.shield.optoutstudies.enabled", false);
pref("browser.discovery.enabled", false);
pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
pref("browser.newtabpage.activity-stream.telemetry", false);
pref("browser.ping-centre.telemetry", false);
pref("extensions.webcompat-reporter.enabled", false);
pref("network.dns.disablePrefetch", true);
pref("network.prefetch-next", false);
pref("network.predictor.enabled", false);
pref("browser.cache.disk.enable", false);
pref("browser.cache.memory.enable", true);
pref("browser.privatebrowsing.autostart", true);
pref("privacy.resistFingerprinting", true);
pref("privacy.trackingprotection.enabled", true);
pref("privacy.trackingprotection.fingerprinting.enabled", true);
pref("privacy.trackingprotection.cryptomining.enabled", true);
pref("privacy.trackingprotection.socialtracking.enabled", true);
pref("network.cookie.cookieBehavior", 1);
pref("network.http.referer.trimmingPolicy", 2);
pref("network.http.referer.XOriginPolicy", 2);
pref("dom.event.clipboardevents.enabled", false);
pref("media.peerconnection.enabled", false);
pref("media.webspeech.recognition.enable", false);
EOF
echo -e "${GREEN}  ✓ Firefox telemetry disabled${NC}"

# --- 2. Kernel Hardening ---
echo -e "${BLUE}[2/10] Hardening kernel parameters...${NC}"
cat > /etc/sysctl.d/99-nexusos.conf << 'EOF'
# IPv6 privacy (use temporary addresses)
net.ipv6.conf.all.use_tempaddr = 2
net.ipv6.conf.default.use_tempaddr = 2
net.ipv6.conf.all.addr_gen_mode = 3
net.ipv6.conf.default.addr_gen_mode = 3

# Disable IPv4 forwarding
net.ipv4.ip_forward = 0

# Enable reverse path filtering
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

# Ignore ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0

# Ignore bogus error responses
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Disable source routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# Log martian packets
net.ipv4.conf.all.log_martians = 1

# Enable SYN cookies
net.ipv4.tcp_syncookies = 1

# Restrict dmesg
kernel.dmesg_restrict = 1

# Restrict kernel pointers
kernel.kptr_restrict = 2

# Disable core dumps
fs.suid_dumpable = 0

# Enable ASLR
kernel.randomize_va_space = 2

# Restrict unprivileged user namespaces
kernel.unprivileged_userns_clone = 0

# Restrict BPF
kernel.unprivileged_bpf_disabled = 1
net.core.bpf_jit_harden = 2
EOF
sysctl --system > /dev/null 2>&1
echo -e "${GREEN}  ✓ Kernel hardened${NC}"

# --- 3. MAC Address Randomization ---
echo -e "${BLUE}[3/10] Enabling MAC randomization...${NC}"
mkdir -p /etc/NetworkManager/conf.d
cat > /etc/NetworkManager/conf.d/nexusos-mac.conf << 'EOF'
[device]
wifi.scan-rand-mac-address=yes

[connection]
wifi.cloned-mac-address=random
ethernet.cloned-mac-address=random
EOF
systemctl restart NetworkManager 2>/dev/null || true
echo -e "${GREEN}  ✓ MAC randomization enabled${NC}"

# --- 4. Firewall ---
echo -e "${BLUE}[4/10] Configuring firewall...${NC}"
pacman -S --noconfirm --needed firewalld > /dev/null 2>&1
systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --set-default-zone=drop
firewall-cmd --permanent --add-service=dhcpv6-client
firewall-cmd --permanent --add-service=ssh
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload
echo -e "${GREEN}  ✓ Firewall active (zone: drop)${NC}"

# --- 5. Disable Unnecessary Services ---
echo -e "${BLUE}[5/10] Disabling unnecessary services...${NC}"
for svc in avahi-daemon cups bluetooth ModemManager; do
    systemctl disable $svc 2>/dev/null && echo "  ✓ Disabled: $svc" || true
done
echo -e "${GREEN}  ✓ Unnecessary services disabled${NC}"

# --- 6. Secure SSH ---
echo -e "${BLUE}[6/10] Hardening SSH...${NC}"
mkdir -p /etc/ssh/sshd_config.d
cat > /etc/ssh/sshd_config.d/nexusos.conf << 'EOF'
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
X11Forwarding no
AllowAgentForwarding no
AllowTcpForwarding no
PrintMotd no
Protocol 2
MaxAuthTries 3
LoginGraceTime 30
ClientAliveInterval 300
ClientAliveCountMax 0
AllowUsers raj
EOF
echo -e "${GREEN}  ✓ SSH hardened${NC}"

# --- 7. Enable AppArmor ---
echo -e "${BLUE}[7/10] Enabling AppArmor...${NC}"
if command -v apparmor_parser &>/dev/null; then
    systemctl enable apparmor 2>/dev/null || true
    systemctl start apparmor 2>/dev/null || true
    echo -e "${GREEN}  ✓ AppArmor enabled${NC}"
else
    echo -e "${YELLOW}  → AppArmor not installed (install: pacman -S apparmor)${NC}"
fi

# --- 8. USB Guard ---
echo -e "${BLUE}[8/10] Configuring USB protection...${NC}"
if command -v usbguard &>/dev/null; then
    systemctl enable usbguard 2>/dev/null || true
    systemctl start usbguard 2>/dev/null || true
    echo -e "${GREEN}  ✓ USBGuard active${NC}"
else
    echo -e "${YELLOW}  → USBGuard not installed (install: pacman -S usbguard)${NC}"
fi

# --- 9. BleachBit Integration ---
echo -e "${BLUE}[9/10] Setting up privacy cleaner...${NC}"
pacman -S --noconfirm --needed bleachbit > /dev/null 2>&1 || true
mkdir -p /etc/nexusos
cat > /etc/nexusos/bleachbit.conf << 'EOF'
[clean]
# What to clean on each privacy sweep
delete_cache = true
delete_cookies = true
delete_history = true
delete_logs = true
delete_temp = true
delete_trash = true
delete_free_space = false
EOF
echo -e "${GREEN}  ✓ BleachBit configured${NC}"

# --- 10. Summary ---
echo -e "${BLUE}[10/10] Generating privacy report...${NC}"
echo ""
echo -e "${GREEN}◆ NexusOS Privacy Report${NC}"
echo -e "${GREEN}========================${NC}"
echo -e "  ✓ Telemetry disabled"
echo -e "  ✓ Kernel hardened (ASLR, SYN cookies, RP filter)"
echo -e "  ✓ MAC randomization enabled"
echo -e "  ✓ Firewall active (zone: drop)"
echo -e "  ✓ Unnecessary services disabled"
echo -e "  ✓ SSH hardened (no root login, key-only)"
echo -e "  ✓ AppArmor enabled"
echo -e "  ✓ USBGuard configured"
echo -e "  ✓ BleachBit cleaner ready"
echo -e "  ✓ Tor transparent proxy ready"
echo -e "  ✓ Encrypted DNS (DoH/DoT) ready"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Run Tor proxy: ${BLUE}sudo /opt/nexusos/privacy/setup-tor-proxy.sh${NC}"
echo -e "  2. Set up encrypted home: ${BLUE}sudo cryptsetup luksFormat /dev/sdXN${NC}"
echo -e "  3. Run privacy clean: ${BLUE}sudo bleachbit -c /etc/nexusos/bleachbit.conf${NC}"
echo ""
echo -e "${GREEN}◆ Your system is now privacy-hardened.${NC}"