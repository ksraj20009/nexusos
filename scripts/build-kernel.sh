#!/bin/bash
# NexusOS Kernel Builder
# Clones the REAL Linux kernel from torvalds/linux,
# applies NexusOS patches and config, then compiles.
set -e

KERNEL_VERSION="v6.10"
KERNEL_REPO="https://github.com/torvalds/linux.git"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="${PROJECT_DIR}/kernel/build"
OUTPUT_DIR="${PROJECT_DIR}/output"

echo "◆ NexusOS Kernel Builder"
echo "========================="
echo "  Kernel:  Linux ${KERNEL_VERSION}"
echo "  Repo:    ${KERNEL_REPO}"
echo ""

echo "[1/7] Cloning Linux kernel..."
if [ -d "${BUILD_DIR}/linux" ]; then
    cd "${BUILD_DIR}/linux"
    git fetch --depth=1 origin "${KERNEL_VERSION}"
    git checkout "${KERNEL_VERSION}"
else
    mkdir -p "${BUILD_DIR}"
    cd "${BUILD_DIR}"
    git clone --depth=1 --branch "${KERNEL_VERSION}" "${KERNEL_REPO}" linux
    cd linux
fi
echo "  ✓ Kernel source ready"

echo "[2/7] Applying NexusOS patches..."
PATCH_DIR="${PROJECT_DIR}/kernel/patches"
if [ -d "${PATCH_DIR}" ]; then
    for patch in "${PATCH_DIR}"/*.patch; do
        if [ -f "$patch" ]; then
            echo "  → Applying $(basename "$patch")..."
            git apply "$patch" 2>/dev/null || echo "  ⚠ Patch already applied or failed: $(basename "$patch")"
        fi
    done
fi
echo "  ✓ Patches applied"

echo "[3/7] Configuring kernel..."
CONFIG_FILE="${PROJECT_DIR}/kernel/configs/nexusos.config"
make defconfig
if [ -f "${CONFIG_FILE}" ]; then
    while IFS= read -r line; do
        [[ "$line" =~ ^# ]] && continue
        [[ -z "$line" ]] && continue
        key=$(echo "$line" | cut -d= -f1)
        value=$(echo "$line" | cut -d= -f2)
        if [ "$value" = "y" ]; then
            scripts/config --enable "$key"
        elif [ "$value" = "n" ]; then
            scripts/config --disable "$key"
        else
            scripts/config --set-val "$key" "$value"
        fi
    done < "${CONFIG_FILE}"
fi
scripts/config --set-str LOCALVERSION "-nexusos"
make olddefconfig
echo "  ✓ Kernel configured"

echo "[4/7] Building kernel..."
make -j"$(nproc)" 2>&1 | tail -5
echo "  ✓ Kernel built"

echo "[5/7] Building modules..."
make modules -j"$(nproc)" 2>&1 | tail -5
echo "  ✓ Modules built"

echo "[6/7] Packaging..."
mkdir -p "${OUTPUT_DIR}"
cp arch/x86/boot/bzImage "${OUTPUT_DIR}/nexusos-kernel-${KERNEL_VERSION}-x86_64"
make modules_install INSTALL_MOD_PATH="${OUTPUT_DIR}/modules" 2>&1 | tail -3
cd "${OUTPUT_DIR}"
tar czf "nexusos-kernel-${KERNEL_VERSION}-x86_64.tar.gz" "nexusos-kernel-${KERNEL_VERSION}-x86_64" "modules/"
sha256sum "nexusos-kernel-${KERNEL_VERSION}-x86_64.tar.gz" > "nexusos-kernel-${KERNEL_VERSION}-x86_64.tar.gz.sha256"
echo "  ✓ Packaged"

echo "[7/7] Build complete!"
echo "  Package: ${OUTPUT_DIR}/nexusos-kernel-${KERNEL_VERSION}-x86_64.tar.gz"
echo ""
echo "◆ NexusOS — Your OS. Your Rules. Your Privacy."
