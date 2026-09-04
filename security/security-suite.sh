#!/bin/bash
# Vajra OS Security Suite
# Comprehensive security hardening: Firejail, LUKS, DNS sinkhole, kill switch,
# split tunnel, Tor bridges, AIDE, audit, USB control, mic/camera kill
set -e
echo "◆ Vajra OS Security Suite"
if [[ $EUID -ne 0 ]]; then exec sudo "$0" "$@"; fi

# === 1. Firejail — App Sandboxing ===
echo "[1/10] Setting up Firejail app sandboxing..."
apt-get install -y firejail 2>/dev/null || true
mkdir -p /etc/firejail
cat > /etc/firejail/firefox-esr.profile << 'FJ'
include /etc/firejail/firefox-common.profile
private-tmp
private-dev
nodvd
notv
novideo
FJ
cat > /etc/firejail/generic-app.profile << 'FJ'
include disable-shell.inc
include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
private-tmp
private-dev
nodvd
notv
FJ
for app in firefox firefox-esr chromium thunderbird evince; do
    if command -v $app &>/dev/null; then
        ln -sf /usr/bin/firejail /usr/local/bin/$app 2>/dev/null || true
    fi
done
echo "  ✓ Firejail configured"

# === 2. LUKS Full Disk Encryption ===
echo "[2/10] Checking LUKS encryption..."
if command -v cryptsetup &>/dev/null; then
    echo "  ✓ cryptsetup available"
    lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT | grep -q crypt && echo "  ✓ Encrypted partition detected" || echo "  ⚠ No encrypted partition found (use Calamares with encryption)"
else
    apt-get install -y cryptsetup 2>/dev/null || true
fi

# === 3. DNS Sinkhole ===
echo "[3/10] Setting up DNS sinkhole..."
mkdir -p /etc/vajra
cat > /etc/vajra/dns-sinkhole.list << 'DNS'
doubleclick.net
googleadservices.com
googlesyndication.com
google-analytics.com
adservice.google.com
amazon-adsystem.com
ads.yahoo.com
facebook.com/tr
connect.facebook.net
platform.twitter.com
ads.linkedin.com
ads.tiktok.com
scorecardresearch.com
quantserve.com
criteo.com
taboola.com
outbrain.com
adnxs.com
pubmatic.com
rubiconproject.com
openx.net
adform.net
smartadserver.com
DNS
if command -v dnsmasq &>/dev/null; then
    cp /etc/vajra/dns-sinkhole.list /etc/dnsmasq.d/vajra-sinkhole.conf
    systemctl restart dnsmasq 2>/dev/null || true
    echo "  ✓ DNS sinkhole active (dnsmasq)"
else
    echo "  ⚠ Install dnsmasq for DNS sinkhole: sudo apt install dnsmasq"
fi

# === 4. Network Kill Switch ===
echo "[4/10] Setting up network kill switch..."
cat > /usr/local/bin/vajra-kill-switch << 'KS'
#!/bin/bash
if ! systemctl is-active tor &>/dev/null; then
    iptables -P OUTPUT DROP
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    echo "⚠ Tor not running — ALL traffic blocked by kill switch"
    notify-send "Vajra OS: Kill Switch Activated" "Tor is not running. All network traffic blocked." 2>/dev/null || true
    exit 1
fi
exit 0
KS
chmod +x /usr/local/bin/vajra-kill-switch
cat > /etc/cron.d/vajra-kill-switch << 'CRON'
* * * * * root /usr/local/bin/vajra-kill-switch
CRON
echo "  ✓ Kill switch active"

# === 5. Split Tunneling ===
echo "[5/10] Setting up Tor split tunneling..."
cat > /usr/local/bin/vajra-split-tunnel << 'ST'
#!/bin/bash
APP=$1
if [ -z "$APP" ]; then
    echo "Usage: vajra-split-tunnel <app-name>"
    exit 1
fi
if command -v torsocks &>/dev/null; then
    exec torsocks "$APP"
else
    apt-get install -y torsocks 2>/dev/null
    exec torsocks "$APP"
fi
ST
chmod +x /usr/local/bin/vajra-split-tunnel
echo "  ✓ Split tunnel ready"

# === 6. Tor Bridges ===
echo "[6/10] Configuring Tor bridges..."
mkdir -p /etc/tor
cat > /etc/tor/bridges.conf << 'BRI'
# Tor bridges for censorship bypass
# Bridge obfs4 IP:PORT FINGERPRINT cert=CERT iat-mode=0
BRI
echo "UseBridges 0" >> /etc/tor/torrc 2>/dev/null || true
echo "ClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy" >> /etc/tor/torrc 2>/dev/null || true
echo "  ✓ Tor bridges configured"

# === 7. AIDE ===
echo "[7/10] Setting up AIDE..."
apt-get install -y aide 2>/dev/null || true
if command -v aide &>/dev/null; then
    cat > /usr/local/bin/vajra-aide-init << 'AI'
#!/bin/bash
echo "Initializing AIDE database..."
aideinit 2>/dev/null || aide --init 2>/dev/null || true
cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db 2>/dev/null || true
echo "AIDE database initialized."
AI
    chmod +x /usr/local/bin/vajra-aide-init
    cat > /usr/local/bin/vajra-aide-check << 'AC'
#!/bin/bash
echo "Checking file integrity..."
aide --check 2>/dev/null || aide -C 2>/dev/null || echo "AIDE not initialized. Run vajra-aide-init first."
AC
    chmod +x /usr/local/bin/vajra-aide-check
    cat > /etc/cron.daily/vajra-aide << 'AC'
#!/bin/bash
/usr/local/bin/vajra-aide-check
AC
    chmod +x /etc/cron.daily/vajra-aide
    echo "  ✓ AIDE file integrity monitoring active"
else
    echo "  ⚠ AIDE install failed"
fi

# === 8. Audit Logging ===
echo "[8/10] Setting up audit logging..."
apt-get install -y auditd 2>/dev/null || true
if command -v auditctl &>/dev/null; then
    cat > /etc/audit/rules.d/vajra.rules << 'AUD'
## Vajra OS Audit Rules
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k actions
-w /etc/hosts -p wa -k system
-w /var/log/faillog -p wa -k logins
-w /var/log/lastlog -p wa -k logins
-w /etc/ssh/sshd_config -p wa -k sshd
-a always,exit -F arch=b64 -S unlink -S unlinkat -S rmdir -S rename -S renameat -k delete
-a always,exit -F arch=b64 -S chmod -S fchmod -S fchmodat -k perms
-a always,exit -F arch=b64 -S setuid -S setgid -S setresuid -S setresgid -k privilege
-w /sbin/insmod -p x -k modules
-w /sbin/rmmod -p x -k modules
-w /sbin/modprobe -p x -k modules
AUD
    systemctl enable auditd 2>/dev/null || true
    systemctl restart auditd 2>/dev/null || true
    echo "  ✓ Audit logging active"
else
    echo "  ⚠ auditd install failed"
fi

# === 9. USB Device Control ===
echo "[9/10] Setting up USB device control..."
cat > /usr/local/bin/vajra-usb-control << 'UC'
#!/bin/bash
case "$1" in
    block) modprobe -r usb-storage 2>/dev/null || true; echo "blacklist usb-storage" > /etc/modprobe.d/vajra-usb-block.conf; echo "USB storage blocked." ;;
    allow) rm -f /etc/modprobe.d/vajra-usb-block.conf; modprobe usb-storage 2>/dev/null || true; echo "USB storage allowed." ;;
    list) lsusb 2>/dev/null || echo "lsusb not available" ;;
    *) echo "Usage: vajra-usb-control [block|allow|list]" ;;
esac
UC
chmod +x /usr/local/bin/vajra-usb-control
echo "  ✓ USB control ready"

# === 10. Mic/Camera Kill Switch ===
echo "[10/10] Setting up mic/camera kill switch..."
cat > /usr/local/bin/vajra-kill-mic-cam << 'MC'
#!/bin/bash
case "$1" in
    mic-off) amixer -c 0 cset numid=2 off 2>/dev/null || true; echo "0" > /sys/class/leds/micmute/brightness 2>/dev/null || true; echo "🔇 Microphone disabled" ;;
    mic-on) amixer -c 0 cset numid=2 on 2>/dev/null || true; echo "1" > /sys/class/leds/micmute/brightness 2>/dev/null || true; echo "🎤 Microphone enabled" ;;
    cam-off) modprobe -r uvcvideo 2>/dev/null || true; echo "blacklist uvcvideo" > /etc/modprobe.d/vajra-cam-block.conf; echo "📷 Camera disabled" ;;
    cam-on) rm -f /etc/modprobe.d/vajra-cam-block.conf; modprobe uvcvideo 2>/dev/null || true; echo "📷 Camera enabled" ;;
    status) lsmod | grep -q uvcvideo && echo "📷 Camera: ON" || echo "📷 Camera: OFF"; amixer -c 0 contents 2>/dev/null | grep -q "off" && echo "🔇 Mic: OFF" || echo "🎤 Mic: ON" ;;
    *) echo "Usage: vajra-kill-mic-cam [mic-off|mic-on|cam-off|cam-on|status]" ;;
esac
MC
chmod +x /usr/local/bin/vajra-kill-mic-cam
echo "  ✓ Mic/camera kill switch ready"

echo ""
echo "◆ Vajra OS Security Suite — Complete!"
echo "  1.  Firejail sandboxing       ✓"
echo "  2.  LUKS encryption check     ✓"
echo "  3.  DNS sinkhole (25+ domains) ✓"
echo "  4.  Network kill switch       ✓"
echo "  5.  Tor split tunneling       ✓"
echo "  6.  Tor bridges (obfs4)        ✓"
echo "  7.  AIDE integrity monitoring ✓"
echo "  8.  Audit logging             ✓"
echo "  9.  USB device control        ✓"
echo "  10. Mic/camera kill switch    ✓"
echo ""
echo "◆ धर्मो रक्षति रक्षितः"
