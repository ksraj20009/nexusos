# NexusOS Build Guide

## Prerequisites

### Option A: Build on Arch Linux (native)
- Arch Linux installed
- 20GB free disk space
- 4GB+ RAM
- `archiso` package installed

### Option B: Build with Docker (any Linux)
- Docker installed
- 20GB free disk space

---

## Building the ISO

### Method 1: Native Arch Linux

```bash
# 1. Clone the repository
git clone https://github.com/ksraj20009/nexusos.git
cd nexusos

# 2. Install build dependencies
sudo pacman -S archiso git xorriso squashfs-tools

# 3. Make scripts executable
chmod +x scripts/*.sh

# 4. Run the build (takes 15-60 minutes)
sudo ./scripts/build-iso.sh
```

### Method 2: Docker

```bash
docker build -t nexusos-builder .
mkdir output
docker run --rm -v $(pwd)/output:/nexusos/output nexusos-builder
```

---

## Output

The ISO file will be at:
```
output/nexusos-1.0-x86_64.iso
```

Along with checksums:
- `nexusos-1.0-x86_64.iso.sha256`
- `nexusos-1.0-x86_64.iso.md5`

---

## Flashing to USB

### Linux
```bash
lsblk
sudo dd if=output/nexusos-1.0-x86_64.iso of=/dev/sdX bs=4M status=progress
sync
```

### Windows
Use [Rufus](https://rufus.ie/) or [balenaEtcher](https://etcher.balena.io/)

### macOS
```bash
diskutil list
sudo dd if=output/nexusos-1.0-x86_64.iso of=/dev/diskN bs=4m
```

---

## Building for ARM64

```bash
sudo pacman -S archiso arm-none-eabi-gcc
sudo ./scripts/build-iso.sh --arch aarch64
```

---

## Customizing the Build

### Add packages
Edit `config/packages.x86_64` and add package names.

### Change desktop environment
Edit `config/packages.x86_64` — replace `gnome` with `plasma`, `xfce4`, etc.

### Change AI model
Edit `ai/config.yaml`:
```yaml
llm:
  model: "mistral"  # or phi3, gemma2, etc.
```

---

## Troubleshooting Build Issues

### "archiso command not found"
```bash
sudo pacman -S archiso
```

### "No space left on device"
The build needs ~20GB. Free up space or use a different drive.

### ISO won't boot
- Verify the ISO checksum
- Re-flash the USB drive
- Try a different USB drive
- Disable Secure Boot in BIOS