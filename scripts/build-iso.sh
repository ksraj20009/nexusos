#!/bin/bash
# Vajra OS ISO Builder
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="${PROJECT_DIR}/output"

echo "◆ Vajra OS ISO Builder"
echo "========================"

echo "[1/4] Building Vajra custom kernel..."
bash "${SCRIPT_DIR}/build-kernel.sh"

echo "[2/4] Setting up live-build..."
LB_DIR="${PROJECT_DIR}/live-build"
mkdir -p "${LB_DIR}"/{auto,config/{package-lists,hooks/normal,includes.chroot/opt/vajra/{ai,privacy,scripts,desktop}}}

echo "[3/4] Configuring live-build..."
cd "${LB_DIR}"
lb config \
    --distribution trixie \
    --architecture amd64 \
    --bootloaders syslinux,grub-efi \
    --iso-volume VajraOS-1.0 \
    --iso-application "Vajra OS" \
    --mirror-bootstrap http://deb.debian.org/debian/ \
    --mirror-binary http://deb.debian.org/debian/ \
    --locale en_IN.UTF-8 \
    --apt-recommends true \
    --checksums sha256 \
    --compression xz

mkdir -p config/includes.chroot/boot config/includes.chroot/lib/modules
cp "${OUTPUT_DIR}/vajra-kernel-"*"-x86_64" config/includes.chroot/boot/vmlinuz 2>/dev/null || true
cp -r "${OUTPUT_DIR}/modules/" config/includes.chroot/lib/modules/ 2>/dev/null || true

echo "[4/4] Building ISO..."
sudo lb build 2>&1 | tee build.log
for f in *.hybrid.iso *.iso; do
    if [ -f "$f" ]; then mv "$f" vajra-os-1.0-amd64.iso; break; fi
done
sha256sum vajra-os-1.0-amd64.iso > vajra-os-1.0-amd64.iso.sha256 2>/dev/null || true
echo "◆ Vajra OS ISO Build Complete!"
echo "  ISO: ${LB_DIR}/vajra-os-1.0-amd64.iso"
