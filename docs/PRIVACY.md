# NexusOS Privacy Guide

## Privacy Levels

NexusOS offers three privacy levels. All are configured during or after installation.

### Level 1: Paranoid (Default)
- All traffic routed through Tor
- Encrypted DNS (DoH/DoT)
- MAC address randomization
- No telemetry
- Firewall (drop zone, no incoming)
- VPN kill switch
- No cloud services
- Local AI only
- USB device blocking
- AppArmor enabled
- SSH hardened (key-only, no root)

### Level 2: Balanced
- Tor available but not forced
- Encrypted DNS
- MAC randomization on WiFi
- No telemetry
- Firewall (allow SSH)
- VPN available

### Level 3: Minimal
- Standard firewall
- No MAC randomization
- Telemetry disabled
- Standard DNS
- AI available

---

## Changing Privacy Level

Edit `/etc/nexusos/nexusos.conf`:

```bash
sudo nano /etc/nexusos/nexusos.conf
```

Set the level:
```
PRIVACY_MODE=true        # Level 1 (Paranoid)
TOR_TRANSPARENT_PROXY=true
DNS_ENCRYPTION=true
MAC_RANDOMIZATION=true
```

Then apply:
```bash
sudo /opt/nexusos/privacy/harden.sh
```

---

## Tor Usage

### Check if Tor is working
```bash
# Check Tor service
systemctl status tor

# Check your Tor IP
curl --socks5 127.0.0.1:9050 https://check.torproject.org/api/ip

# Get a new identity (new exit node)
sudo systemctl reload tor
```

### Configure browser for Tor
Firefox is pre-configured to use Tor's SOCKS proxy:
- SOCKS Host: 127.0.0.1
- SOCKS Port: 9050
- DNS through SOCKS: enabled

For maximum anonymity, use the Tor Browser:
```bash
tor-browser-en
```

---

## Encrypted DNS

NexusOS uses DNS-over-HTTPS and DNS-over-TLS:

```bash
# Check DNS configuration
resolvectl status

# Test DNS encryption
dig +tls @127.0.0.1 example.com
```

---

## VPN Kill Switch

The firewall is configured as a kill switch — if Tor or VPN drops, all traffic is blocked:

```bash
sudo iptables -L OUTPUT -n
```

---

## File Encryption

### Full-disk encryption (LUKS)
Enabled during installation. To verify:
```bash
sudo cryptsetup luksDump /dev/sdXN
```

### Home directory encryption
```bash
sudo ecryptfs-migrate-home -u raj
```

### File-level encryption
Use VeraCrypt (installed):
```bash
veracrypt
```

---

## Privacy Cleaner

Run BleachBit to clean traces:
```bash
sudo bleachbit -c /etc/nexusos/bleachbit.conf
```

---

## What NexusOS Does NOT Track

- browsing history
- search queries
- file access patterns
- application usage
- location data
- keystrokes
- clipboard contents
- network traffic metadata

---

## Additional Privacy Tools

| Tool | Purpose | Install |
|------|---------|---------|
| KeePassXC | Password manager | `sudo pacman -S keepassxc` |
| VeraCrypt | File encryption | `sudo pacman -S veracrypt` |
| Signal | Private messaging | `sudo pacman -S signal-desktop` |
| BleachBit | System cleaner | `sudo pacman -S bleachbit` |
| macchanger | MAC spoofing | `sudo pacman -S macchanger` |
| Mat2 | Metadata removal | `sudo pacman -S mat2` |