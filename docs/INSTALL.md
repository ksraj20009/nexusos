# NexusOS Installation Guide

## Step 1: Download the ISO

Download `nexusos-1.0-x86_64.iso` from the [releases page](https://github.com/ksraj20009/nexusos/releases).

Verify the checksum:
```bash
sha256sum -c nexusos-1.0-x86_64.iso.sha256
```

## Step 2: Flash to USB

### Linux
```bash
lsblk  # Find your USB device
sudo dd if=nexusos-1.0-x86_64.iso of=/dev/sdX bs=4M status=progress
sync
```

### Windows
Use [Rufus](https://rufus.ie/) or [balenaEtcher](https://etcher.balena.io/)

### macOS
```bash
diskutil list
sudo dd if=nexusos-1.0-x86_64.iso of=/dev/rdiskN bs=4m
diskutil eject /dev/diskN
```

## Step 3: Boot from USB

1. Insert the USB drive into your computer
2. Restart and enter BIOS/UEFI (usually F2, F12, or Del)
3. Set the USB drive as the first boot device
4. Disable Secure Boot
5. Save and exit BIOS

## Step 4: Install NexusOS

The live USB boots into NexusOS. To install:

1. **Welcome** — Choose your language
2. **Location** — Select your timezone
3. **Keyboard** — Choose your keyboard layout
4. **Partitioning** — Choose:
   - **Erase disk** (automatic — recommended for beginners)
   - **Manual** (for advanced users)
   - **Encrypt** (recommended — enables LUKS full-disk encryption)
5. **Users** — Create your account
6. **Summary** — Review settings
7. **Install** — Click Install and wait (10-30 minutes)

## Step 5: Post-Install Setup

After installation, NexusOS automatically:
- Enables Tor transparent proxy
- Enables firewall (drop zone)
- Enables MAC randomization
- Enables encrypted DNS (DoH/DoT)
- Disables all telemetry
- Starts AI assistant service

### Verify Tor is working
```bash
curl --socks5 127.0.0.1:9050 https://check.torproject.org/api/ip
```

### Set up AI assistant
```bash
systemctl --user status nexus-ai
```

### Download AI model (optional)
```bash
ollama pull llama3.2
```

## Step 6: Using NexusOS

- **Ctrl+Space** — Open AI command bar
- **Ctrl+Alt+T** — Open Terminal
- **Say "Nexus"** — Trigger voice assistant
- **Right-click desktop** — Context menu

## Dual Boot

To dual-boot with Windows:

1. In Windows, shrink your partition (Disk Management)
2. Create a new partition for NexusOS (30GB+)
3. Boot from USB and choose "Manual" partitioning
4. Select the new partition for NexusOS
5. Install bootloader to the same drive
6. Disable Windows Fast Startup

## Troubleshooting Installation

### Won't boot from USB
- Try a different USB port
- Try a different USB drive
- Verify ISO checksum
- Disable Secure Boot

### Installation fails
- Check disk space (need 15GB+)
- Try "Erase disk" instead of manual
- Check RAM (need 2GB+)

### No internet after install
```bash
sudo systemctl restart NetworkManager
nmcli device wifi list
nmcli device wifi connect "SSID" password "password"
```

### AI assistant not working
```bash
systemctl --user start nexus-ai
journalctl --user -u nexus-ai -f
```