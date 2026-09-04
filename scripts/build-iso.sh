#!/bin/bash
# NexusOS ISO Builder
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="${PROJECT_DIR}/output"

echo "◆ NexusOS Full ISO Builder"
echo "==========================="

echo "[1/4] Building NexusOS custom kernel..."
bash "${SCRIPT_DIR}/build-kernel.sh"

echo "[2/4] Setting up live-build..."
LB_DIR="${PROJECT_DIR}/live-build"
mkdir -p "${LB_DIR}"/{auto,config/{package-lists,hooks/normal,includes.chroot/opt/nexusos/{ai,privacy,scripts}}}

echo "[3/4] Configuring live-build..."
cd "${LB_DIR}"
lb config --distribution trixie --architecture amd64 --bootloaders syslinux,grub-efi --iso-volume NexusOS-1.0 --iso-application NexusOS --mirror-bootstrap http://deb.debian.org/debian/ --mirror-binary http://deb.debian.org/debian/ --locale en_IN.UTF-8 --apt-recommends true --checksums sha256 --compression xz

mkdir -p config/includes.chroot/boot
cp "${OUTPUT_DIR}/nexusos-kernel-"*"-x86_64" config/includes.chroot/boot/vmlinuz 2>/dev/null || true
cp -r "${OUTPUT_DIR}/modules/" config/includes.chroot/lib/modules/ 2>/dev/null || true

echo "[4/4] Building ISO..."
sudo lb build 2>&1 | tee build.log
for f in *.hybrid.iso *.iso; do
    if [ -f "$f" ]; then mv "$f" nexusos-1.0-amd64.iso; break; fi
done
sha256sum nexusos-1.0-amd64.iso > nexusos-1.0-amd64.iso.sha256 2>/dev/null || true
echo "◆ NexusOS ISO Build Complete!"
echo "  ISO: ${LB_DIR}/nexusos-1.0-amd64.iso"
