# Vajra OS Build Guide

Complete instructions for building Vajra OS from source.

## Quick Start (Pre-built ISO)

Download the pre-built ISO from the releases page and flash to USB:

```bash
dd if=vajra-os-1.0-amd64.iso of=/dev/sdX bs=4M status=progress
sync
```

Test in QEMU:
```bash
sudo apt install qemu-system-x86 ovmf
./iso/test-vajra-iso.sh vajra-os-1.0-amd64.iso
```

## Building the ISO Yourself

### Prerequisites (any Linux machine)

```bash
sudo apt install python3 python3-pip xorriso qemu-system-x86 ovmf
pip3 install pycdlib
```

### Build the ISO

```bash
# Clone the repo
git clone https://github.com/ksraj20009/vajra-os.git
cd vajra-os

# Build the ISO (downloads kernel + BusyBox, builds initramfs, creates bootable ISO)
python3 iso/build-iso.py

# The ISO will be at: vajra-os-1.0-amd64.iso (41.5 MB)
```

### What the build does

1. Downloads Alpine Linux kernel 6.6.142 (with 922 kernel modules)
2. Downloads BusyBox (396 Unix commands)
3. Downloads all 279 Vajra utility scripts from the repo
4. Downloads Buddhi AI assistant
5. Builds initramfs (cpio.gz, 27.5 MB) with all tools embedded
6. Downloads GRUB EFI binary for UEFI boot
7. Creates ISO with:
   - El Torito BIOS boot record (no-emulation mode)
   - UEFI boot via /EFI/BOOT/BOOTX64.EFI
   - ISOLINUX config for BIOS boot menu
   - GRUB config for UEFI boot menu
   - 3 boot options: default, debug, serial console

### Using xorriso (alternative)

If you have xorriso, you can build a more complete ISO:

```bash
sudo apt install xorriso isolinux syslinux-common grub-pc-bin grub-efi-amd64-bin

xorriso -as mkisofs \
  -o vajra-os-1.0-amd64.iso \
  -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
  -c boot.cat \
  -b vmlinuz \
  -no-emul-boot -boot-load-size 4 -boot-info-table \
  -eltorito-alt-boot \
  -e boot/efi/boot/bootx64.efi \
  -no-emul-boot -isohybrid-gpt-hfsplus \
  -V "VAJRA_OS_1.0" \
  -J -R \
  .
```

## Building Debian Packages

```bash
# Build all .deb packages
cd packaging/
./build-all-packages.sh

# Packages will be in: packaging/output/
```

## Building Docker Image

```bash
# Import the rootfs tarball as a Docker image
docker import vajra-os-rootfs.tar vajra-os:1.0

# Or build from Dockerfile
docker build -t vajra-os:1.0 -f docker/Dockerfile.vajra .

# Run
docker run -it vajra-os:1.0
```

## APT Repository

The APT repository is hosted in this repo at `apt-repo/`. To use it:

```bash
# Import GPG key
curl -fsSL https://raw.githubusercontent.com/ksraj20009/vajra-os/main/apt-repo/vajra-archive-keyring.asc | gpg --dearmor -o /usr/share/keyrings/vajra-archive-keyring.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/vajra-archive-keyring.gpg] https://raw.githubusercontent.com/ksraj20009/vajra-os/main/apt-repo vajra main" | sudo tee /etc/apt/sources.list.d/vajra.list

# Install
sudo apt update
sudo apt install vajra-core vajra-security-center vajra-control-center
```

## ISO Contents

| Component | Count | Size |
|-----------|-------|------|
| Linux Kernel | 6.6.142 | 10.4 MB |
| Kernel modules | 922 | 17 MB |
| BusyBox applets | 396 | 1.4 MB |
| Vajra core tools | 14 | 200 KB |
| Utility scripts | 279 | 2 MB |
| Buddhi AI | 1 | 49 KB |
| Disk installer | 1 | 10 KB |
| GPG public key | 1 | 1 KB |
| **Total ISO** | | **41.5 MB** |

## Boot Modes

1. **BIOS (El Torito)** — Works on all x86 PCs, legacy boot
2. **UEFI (GRUB)** — Works on modern PCs with UEFI firmware
3. **Serial console** — For headless servers and VMs

## Architecture

```
vajra-os-1.0-amd64.iso (41.5 MB)
├── /vmlinuz              — Linux kernel 6.6.142
├── /initramfs.cpio.gz    — Root filesystem (27.5 MB)
│   ├── /bin/             — BusyBox + Vajra tools
│   ├── /usr/bin/         — Buddhi AI + Vajra tools
│   ├── /usr/share/vajra/ — 279 utility scripts
│   ├── /lib/modules/     — 922 kernel modules
│   └── /etc/             — System config
├── /EFI/BOOT/BOOTX64.EFI — GRUB for UEFI boot
├── /ISOLINUX/            — ISOLINUX config for BIOS boot
├── /grub.cfg             — GRUB config for UEFI
├── /boot.cat             — El Torito boot catalog
├── /README.txt           — Documentation
└── /vajra-archive-keyring.asc — GPG public key
```

(c) 2026 Vajra OS Project
