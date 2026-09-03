# NexusOS Customization Guide

## Themes

### Change accent color
Edit `desktop/nexus-shell.py`:
```python
THEME = {
    "accent": "#00ff88",       # Green accent
    "accent_secondary": "#ff0088",  # Pink secondary
}
```

### Change desktop environment
Edit `config/packages.x86_64` and replace GNOME with:

**KDE Plasma:**
```
plasma
plasma-wayland-session
sddm
```

**XFCE:**
```
xfce4
xfce4-goodies
lightdm
lightdm-gtk-greeter
```

**Sway (tiling WM):**
```
sway
swaylock
swayidle
wlroots
```

## Custom Apps

### Add an app to the desktop
Edit `desktop/nexus-shell.py`:
```python
APPS.append({
    "id": "myapp",
    "name": "My App",
    "icon": "🎯",
    "command": "my-app-command",
    "category": "utility"
})
```

### Add a package
Edit `config/packages.x86_64`:
```
my-package-name
```

## AI Customization

### Change AI behavior
Edit `ai/config.yaml`:
```yaml
llm:
  temperature: 0.3    # More focused responses
  max_tokens: 1000    # Longer responses
```

### Add custom commands
Edit `ai/nexus-ai.py`, add to `QueryProcessor.process()`:
```python
elif "screenshot" in q_lower:
    success, output = os_control.run_command("gnome-screenshot")
    response = "Screenshot taken!"
    action = "screenshot"
```

### Change voice wake word
Edit `ai/config.yaml`:
```yaml
voice:
  wake_word: "jarvis"  # or any word
```

## Privacy Customization

### Disable Tor (use VPN instead)
Edit `config/nexusos.conf`:
```
TOR_TRANSPARENT_PROXY=false
```

### Allow specific incoming connections
```bash
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

### Disable MAC randomization
Edit `/etc/NetworkManager/conf.d/nexusos-mac.conf`:
```
[connection]
wifi.cloned-mac-address=preserve
ethernet.cloned-mac-address=preserve
```

## Boot Customization

### Change GRUB theme
1. Place theme in `/boot/grub/themes/nexusos/`
2. Edit `/etc/default/grub`:
```
GRUB_THEME="/boot/grub/themes/nexusos/theme.txt"
```
3. Run: `sudo grub-mkconfig -o /boot/grub/grub.cfg`

### Change boot splash (Plymouth)
```bash
sudo pacman -S plymouth
sudo plymouth-set-default-theme -R nexusos
```

## File System

### Default layout
```
/          → btrfs (with subvolumes @, @home, @var, @tmp)
/home      → btrfs subvolume @home
/boot/efi  → fat32 (512MB)
swap       → 8GB
```

### Enable snapshots
```bash
sudo pacman -S snapper
sudo snapper -c root create-config /
sudo snapper -c home create-config /home
systemctl enable snapper-timeline.timer
systemctl start snapper-timeline.timer
```

## Network

### Change DNS provider
Edit `/etc/systemd/resolved.conf`:
```ini
DNS=1.1.1.1#cloudflare-dns.com
FallbackDNS=9.9.9.9#dns.quad9.net
DNSOverTLS=yes
```

### Add VPN
```bash
sudo pacman -S networkmanager-openvpn
nmcli connection import type openvpn file /path/to/config.ovpn
```