# Vajra OS (वज्र OS) — Installation Guide

## Download

### Option 1: ISO (for installing on real hardware / virtual machine)
Download the latest ISO from the [GitHub Actions artifacts](https://github.com/ksraj20009/vajra-os/actions) or from `https://vajra-os.org/download` (when available).

### Option 2: Docker (for testing without installing)
```bash
docker pull vajraos/vajra-os:latest
docker run -it vajraos/vajra-os:latest
```

### Option 3: APT (for adding Vajra tools to an existing Debian/Ubuntu system)
```bash
sudo apt install vajra-keyring vajra-sources
sudo apt update
sudo apt install vajra-desktop
```

## Installing from ISO

### Requirements
- 64-bit computer (x86_64)
- 4 GB RAM minimum (8 GB recommended)
- 20 GB disk space minimum
- USB flash drive (4 GB or larger)

### Step 1: Create a bootable USB
```bash
# On Linux:
sudo dd if=vajra-os-1.0.iso of=/dev/sdX bs=4M status=progress
sync

# On Windows: Use Rufus or balenaEtcher to flash the ISO to USB
```

### Step 2: Boot from USB
1. Insert the USB into your computer
2. Restart and enter BIOS/UEFI (usually F2, F12, or Del)
3. Set USB as the first boot device
4. Save and exit BIOS

### Step 3: Try or Install
- The USB boots into a live Vajra OS desktop
- You can explore the system without installing
- When ready, double-click **"Install Vajra OS"** on the desktop

### Step 4: Calamares Installer
The installer will guide you through:
1. **Language** — Choose your language (English, हिंदी, தமிழ், বাংলা, etc.)
2. **Location** — Set your timezone (default: Asia/Kolkata)
3. **Keyboard** — Choose your keyboard layout
4. **Disk** — Choose where to install (automatic or manual partitioning)
5. **User** — Create your account
6. **Install** — The system installs with a Vajra slideshow showing features

### Step 5: First Boot
After installation and reboot, you'll see:
- GRUB boot menu with "Vajra OS" entry
- GDM login screen with Vajra branding
- GNOME desktop with Vajra wallpaper and theme
- Welcome file on desktop with quick-start guide

## Post-Install Setup

### Security (recommended first step)
```bash
vajra-security-center
# Select option 8: "One-click security hardening"
```

### System Settings
```bash
vajra-control-center
# Set your language, timezone, display, network, etc.
```

### Install More Apps
```bash
vajra-app-store
# Browse 28 curated free/open-source apps
# Each app shows pros, cons, and permissions before install
```

### AI Assistant
```bash
buddhi
# Voice-controlled AI assistant with Indian language support
```

### Check for Updates
```bash
vajra-update-manager
# Creates snapshot, then checks and installs updates
```

## Two Modes

### Beginner Mode (default)
- Safety guardrails prevent accidental system damage
- Large icons and simplified menus
- sudo access blocked (admin actions require guided confirmation)
- Only curated apps from Vajra App Store

### Pro Mode
- Full system access
- Developer tools enabled
- Root shell available
- Advanced settings unlocked
- Install any package from any repository

Switch modes in: `vajra-control-center → About → Mode`

## Indian Language Support

Vajra OS includes fonts and input methods for:
- Hindi (हिंदी) — Devanagari
- Tamil (தமிழ்)
- Bengali (বাংলা)
- Telugu (తెలుగు)
- Marathi (मराठी)
- Gujarati (ગુજરાતી)
- Kannada (ಕನ್ನಡ)
- Malayalam (മലയാളം)
- Punjabi (ਪੰਜਾਬੀ)
- Odia (ଓଡ଼ିଆ)
- Assamese (অসমীয়া)

Set your language in `vajra-control-center → Language & Region`.

## Troubleshooting

### Won't boot from USB
- Ensure USB is set as first boot device in BIOS
- Disable Secure Boot if needed (or use the signed shim)
- Try Legacy BIOS mode if UEFI doesn't work

### Installation fails
- Ensure you have 20 GB+ free disk space
- Check your RAM (4 GB minimum)
- Try the "Erase disk" option for automatic partitioning

### No network after install
```bash
vajra-control-center
# Go to Network → Wi-Fi or Ethernet setup
```

### Display issues
```bash
vajra-display-server
# Set resolution, scale, and display mode
```

## Building from Source

### Build the ISO yourself
```bash
git clone https://github.com/ksraj20009/vajra-os.git
cd vajra-os/live-build
sudo lb config
sudo lb build
```

### Build packages
```bash
cd vajra-os/packaging
sudo bash build-all-packages.sh
```

### Build Docker image
```bash
cd vajra-os
docker build -t vajra-os:latest -f docker/Dockerfile .
```

## Support

- GitHub: https://github.com/ksraj20009/vajra-os
- Issues: https://github.com/ksraj20009/vajra-os/issues
- Website: https://vajra-os.org (coming soon)

---

वज्र OS — भारत का अपना ऑपरेटिंग सिस्टम
धर्मो रक्षति रक्षितः
