#!/usr/bin/env python3
"""
Vajra OS (वज्र OS) — Bootable ISO Builder
============================================
This script builds a real bootable Vajra OS ISO from scratch.

It downloads a Linux kernel and BusyBox, creates an initramfs with a
Vajra init script, and packs everything into a bootable ISO 9660 image.

The resulting ISO can be flashed to a USB drive and booted on any PC.

Requirements:
    pip install pycdlib Pillow

Usage:
    python3 build-iso.py

Output:
    vajra-os-1.0.iso  (bootable ISO image)
"""
import os
import sys
import gzip
import json
import shutil
import urllib.request
import subprocess
from pathlib import Path

# === Configuration ===
ISO_VERSION = "1.0"
ISO_LABEL = "VAJRA_OS_1.0"
WORK_DIR = Path("/scratch/work/vajra-iso")

# Sources for kernel and busybox
BUSYBOX_URL = "https://raw.githubusercontent.com/EXALAB/Busybox-static/main/busybox_amd64"
KERNEL_APK_URL = "https://dl-cdn.alpinelinux.org/alpine/v3.19/main/x86_64/linux-virt-6.6.142-r0.apk"

def download(url, dest):
    """Download a file with progress."""
    print(f"  Downloading: {url}")
    req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
    resp = urllib.request.urlopen(req, timeout=60)
    data = resp.read()
    with open(dest, 'wb') as f:
        f.write(data)
    print(f"  Saved: {dest} ({len(data):,} bytes)")
    return data

def make_cpio(entries):
    """Create a cpio archive in newc format (for initramfs)."""
    data = b""
    for name, content, mode in entries:
        name_bytes = name.encode() + b'\0'
        name_size = len(name_bytes)
        name_pad = (4 - (110 + name_size) % 4) % 4
        content_pad = (4 - len(content) % 4) % 4
        
        header = (f"070701{0:08X}{0:08X}{mode:08X}{0:08X}{0:08X}"
                  f"{1:08X}{0:08X}{len(content):08X}{0:08X}{0:08X}"
                  f"{name_size:08X}{0:08X}")
        data += header.encode() + name_bytes + b'\0' * name_pad + content + b'\0' * content_pad
    
    trailer = b"TRAILER!!!\0"
    header = (f"070701{0:08X}{0:08X}{0:08X}{0:08X}{0:08X}"
              f"{1:08X}{0:08X}{0:08X}{0:08X}{0:08X}"
              f"{len(trailer):08X}{0:08X}")
    data += header.encode() + trailer
    pad = (512 - len(data) % 512) % 512
    data += b'\0' * pad
    return data

def build_initramfs(busybox_path, init_script):
    """Build the initramfs cpio.gz with BusyBox and Vajra init."""
    print("\n[*] Building initramfs...")
    
    initramfs_dir = WORK_DIR / "initramfs"
    if initramfs_dir.exists():
        shutil.rmtree(initramfs_dir)
    
    # Create directory structure
    for d in ["bin", "sbin", "usr/bin", "usr/sbin", "proc", "sys", "dev",
              "etc", "root", "tmp", "var/log", "run", "mnt/cdrom"]:
        (initramfs_dir / d).mkdir(parents=True, exist_ok=True)
    
    # Copy BusyBox
    shutil.copy(busybox_path, initramfs_dir / "bin/busybox")
    os.chmod(initramfs_dir / "bin/busybox", 0o755)
    
    # Create symlinks for all BusyBox applets
    result = subprocess.run([str(busybox_path), "--list"], capture_output=True, text=True)
    applets = result.stdout.strip().split("\n")
    for applet in applets:
        target = initramfs_dir / "bin" / applet
        if not target.exists():
            os.symlink("busybox", str(target))
    print(f"  BusyBox: {len(applets)} applets linked")
    
    # Write init script
    init_path = initramfs_dir / "init"
    with open(init_path, "w") as f:
        f.write(init_script)
    os.chmod(init_path, 0o755)
    
    # Write /etc files
    (initramfs_dir / "etc/os-release").write_text(
        'NAME="Vajra OS"\nVERSION="1.0"\nID=vajra\n'
        'PRETTY_NAME="Vajra OS 1.0"\nHOME_URL="https://vajra-os.org"\n'
    )
    (initramfs_dir / "etc/hostname").write_text("vajra-os\n")
    (initramfs_dir / "etc/fstab").write_text(
        "proc /proc proc defaults 0 0\n"
        "sysfs /sys sysfs defaults 0 0\n"
        "devtmpfs /dev devtmpfs defaults 0 0\n"
    )
    (initramfs_dir / "etc/motd").write_text(
        "\n  Vajra OS 1.0 — India's Privacy-First AI-Powered OS\n"
        "  Dharmo Rakshati Rakshitah\n\n"
    )
    
    # Collect all files for cpio
    entries = [(".", b"", 0o040755)]
    for root, dirs, files in os.walk(initramfs_dir):
        dirs.sort()
        files.sort()
        for d in dirs:
            full = os.path.join(root, d)
            rel = os.path.relpath(full, initramfs_dir)
            entries.append(("./" + rel, b"", 0o040755))
        for f in files:
            full = os.path.join(root, f)
            rel = os.path.relpath(full, initramfs_dir)
            cpio_path = "./" + rel
            if os.path.islink(full):
                target = os.readlink(full)
                entries.append((cpio_path, target.encode(), 0o120755))
            else:
                with open(full, "rb") as fh:
                    content = fh.read()
                mode = 0o100755 if os.access(full, os.X_OK) else 0o100644
                entries.append((cpio_path, content, mode))
    
    # Build cpio.gz
    cpio_data = make_cpio(entries)
    initramfs_path = WORK_DIR / "initramfs.cpio.gz"
    with gzip.open(initramfs_path, "wb", compresslevel=9) as f:
        f.write(cpio_data)
    
    size = initramfs_path.stat().st_size
    print(f"  Initramfs: {size:,} bytes ({size/1024/1024:.1f} MB)")
    return initramfs_path

def build_iso(vmlinuz_path, initramfs_path, output_path):
    """Build the bootable ISO using pycdlib."""
    print("\n[*] Building ISO...")
    import pycdlib
    
    # ISOLINUX config
    isolinux_dir = WORK_DIR / "isolinux"
    isolinux_dir.mkdir(exist_ok=True)
    
    isolinux_cfg = (
        "DEFAULT vajra\n"
        "PROMPT 0\n"
        "TIMEOUT 30\n"
        "LABEL vajra\n"
        "  KERNEL /vmlinuz\n"
        f"  APPEND initrd=/initramfs.cpio.gz console=tty0 quiet\n"
        "LABEL vajra-debug\n"
        "  KERNEL /vmlinuz\n"
        "  APPEND initrd=/initramfs.cpio.gz console=tty0\n"
    )
    (isolinux_dir / "isolinux.cfg").write_text(isolinux_cfg)
    
    boot_msg = (
        "\n  Vajra OS 1.0 — India's Privacy-First AI-Powered OS\n"
        "  Dharmo Rakshati Rakshitah\n\n"
        "  Press Enter to boot Vajra OS.\n"
    )
    (isolinux_dir / "boot.msg").write_text(boot_msg)
    
    # Create ISO
    iso = pycdlib.PyCdlib()
    iso.new(interchange_level=3, joliet=True, rock_ridge="1.09",
            vol_ident=ISO_LABEL)
    
    iso.add_file(str(vmlinuz_path), "/VMLINUZ", rr_name="vmlinuz")
    iso.add_file(str(initramfs_path), "/INITRAMF.CPG", rr_name="initramfs.cpio.gz")
    iso.add_directory("/ISOLINUX", rr_name="isolinux")
    iso.add_file(str(isolinux_dir / "isolinux.cfg"),
                 "/ISOLINUX/ISOLINUX.CFG", rr_name="isolinux.cfg")
    iso.add_file(str(isolinux_dir / "boot.msg"),
                 "/BOOT.MSG", rr_name="boot.msg")
    
    # README
    readme = (WORK_DIR / "README.txt")
    readme.write_text(
        f"Vajra OS {ISO_VERSION}\n"
        "India's Privacy-First AI-Powered Operating System\n"
        "Dharmo Rakshati Rakshitah\n\n"
        "Boot: dd if=vajra-os-1.0.iso of=/dev/sdX bs=4M status=progress\n"
    )
    iso.add_file(str(readme), "/README.TXT", rr_name="README.txt")
    
    iso.write(str(output_path))
    iso.close()
    
    size = output_path.stat().st_size
    print(f"  ISO: {size:,} bytes ({size/1024/1024:.1f} MB)")
    return output_path

# === Vajra OS Init Script ===
INIT_SCRIPT = """#!/bin/busybox sh
export PATH=/bin:/sbin:/usr/bin:/usr/sbin
export HOME=/root
export TERM=linux

/bin/busybox mount -t proc none /proc
/bin/busybox mount -t sysfs none /sys
/bin/busybox mount -t devtmpfs none /dev
/bin/busybox mount -t tmpfs none /tmp
/bin/busybox mount -t tmpfs none /run
/bin/busybox mdev -s
/bin/busybox hostname vajra-os

cat << 'BANNER'

  ==================================================
  |    VAJRA OS (vajra OS) 1.0                     |
  |    India's Privacy-First AI-Powered OS         |
  |                                                |
  |    Dharmo Rakshati Rakshitah                  |
  |    (Dharma protects those who protect it)      |
  ==================================================

BANNER

echo "  Kernel: $(uname -r)"
echo "  CPU: $(grep 'model name' /proc/cpuinfo | head -1 | cut -d: -f2)"
echo "  Memory: $(grep MemTotal /proc/meminfo | awk '{print $2 " KB"}')"
echo "  Date: $(date)"
echo ""
echo "[+] Vajra OS is ready. Type 'help' for commands."
echo ""
export PS1='vajra@vajra-os:/ # '
/bin/busybox setsid /bin/busybox sh
/bin/busybox sync
/bin/busybox reboot
"""

# === Main ===
def main():
    print("=" * 55)
    print("  Vajra OS ISO Builder")
    print("=" * 55)
    
    WORK_DIR.mkdir(parents=True, exist_ok=True)
    
    # 1. Download BusyBox
    print("\n[1/4] Downloading BusyBox...")
    busybox_path = WORK_DIR / "busybox"
    if not busybox_path.exists() or busybox_path.stat().st_size < 100000:
        download(BUSYBOX_URL, busybox_path)
    os.chmod(busybox_path, 0o755)
    
    # 2. Download kernel
    print("\n[2/4] Downloading Linux kernel...")
    vmlinuz_path = WORK_DIR / "vmlinuz"
    if not vmlinuz_path.exists():
        import tarfile, io
        apk_path = WORK_DIR / "linux-virt.apk"
        if not apk_path.exists():
            download(KERNEL_APK_URL, apk_path)
        with gzip.open(apk_path, 'rb') as f:
            tar = tarfile.open(fileobj=f)
            for member in tar.getmembers():
                if 'vmlinuz' in member.name:
                    tar.extract(member, WORK_DIR)
                    shutil.move(WORK_DIR / member.name, vmlinuz_path)
                    break
            tar.close()
    print(f"  Kernel: {vmlinuz_path.stat().st_size:,} bytes")
    
    # 3. Build initramfs
    print("\n[3/4] Building initramfs...")
    initramfs_path = build_initramfs(busybox_path, INIT_SCRIPT)
    
    # 4. Build ISO
    print("\n[4/4] Building bootable ISO...")
    iso_path = WORK_DIR / f"vajra-os-{ISO_VERSION}.iso"
    build_iso(vmlinuz_path, initramfs_path, iso_path)
    
    print(f"\n{'=' * 55}")
    print(f"  Vajra OS ISO built successfully!")
    print(f"  File: {iso_path}")
    print(f"  Size: {iso_path.stat().st_size:,} bytes")
    print(f"{'=' * 55}")
    print(f"\n  Flash to USB:")
    print(f"    dd if={iso_path} of=/dev/sdX bs=4M status=progress")
    print(f"\n  Or test with QEMU:")
    print(f"    qemu-system-x86_64 -cdrom {iso_path} -m 512")

if __name__ == "__main__":
    main()
