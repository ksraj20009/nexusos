#!/bin/bash
# ============================================================
#  NexusOS ISO Builder
#  Builds a bootable NexusOS ISO using archiso
# ============================================================
set -e

# --- Configuration ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
WORK_DIR="${PROJECT_DIR}/work"
OUTPUT_DIR="${PROJECT_DIR}/output"
PROFILE_DIR="${PROJECT_DIR}/archiso"
ISO_NAME="nexusos"
ISO_VERSION="1.0"
ISO_LABEL="NEXUSOS_1.0"

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}◆ NexusOS ISO Builder${NC}"
echo -e "${BLUE}========================${NC}"
echo ""

# --- Check root ---
if [[ $EUID -ne 0 ]]; then
    echo -e "${RED}Error: This script must be run as root.${NC}"
    echo -e "  Run: ${YELLOW}sudo ./scripts/build-iso.sh${NC}"
    exit 1
fi

# --- Check dependencies ---
echo -e "${BLUE}[1/6] Checking dependencies...${NC}"
check_dep() {
    if ! command -v "$1" &>/dev/null; then
        echo -e "${RED}Missing dependency: $1${NC}"
        echo -e "Install with: ${YELLOW}sudo pacman -S $2${NC}"
        exit 1
    fi
}
check_dep mkarchiso archiso
check_dep git git
check_dep xorriso xorriso
check_dep squashfs-tools squashfs-tools
echo -e "${GREEN}✓ All dependencies found${NC}"

# --- Prepare archiso profile ---
echo -e "${BLUE}[2/6] Preparing archiso profile...${NC}"
if [[ ! -d "$PROFILE_DIR" ]]; then
    mkdir -p "$PROFILE_DIR"
    cp -r /usr/share/archiso/configs/releng/* "$PROFILE_DIR/"
    echo -e "${GREEN}✓ Base profile copied${NC}"
else
    echo -e "${YELLOW}→ Profile directory exists, using existing${NC}"
fi

# --- Copy NexusOS customization into profile ---
echo -e "${BLUE}[3/6] Customizing profile...${NC}"

if [[ -f "$PROJECT_DIR/config/packages.x86_64" ]]; then
    cat "$PROJECT_DIR/config/packages.x86_64" >> "$PROFILE_DIR/packages.x86_64"
    echo -e "${GREEN}✓ Added NexusOS packages${NC}"
fi

mkdir -p "$PROFILE_DIR/airootfs/opt/nexusos/ai"
cp -r "$PROJECT_DIR/ai/"* "$PROFILE_DIR/airootfs/opt/nexusos/ai/"

mkdir -p "$PROFILE_DIR/airootfs/opt/nexusos/privacy"
cp -r "$PROJECT_DIR/privacy/"* "$PROFILE_DIR/airootfs/opt/nexusos/privacy/"

mkdir -p "$PROFILE_DIR/airootfs/opt/nexusos/desktop"
cp -r "$PROJECT_DIR/desktop/"* "$PROFILE_DIR/airootfs/opt/nexusos/desktop/"

cp "$PROJECT_DIR/config/nexusos.conf" "$PROFILE_DIR/airootfs/etc/nexusos.conf" 2>/dev/null || true
cp "$PROJECT_DIR/config/hostname" "$PROFILE_DIR/airootfs/etc/hostname" 2>/dev/null || true

for svc in nexus-ai.service nexus-tor.service nexus-firewall.service; do
    if [[ -f "$PROJECT_DIR/config/$svc" ]]; then
        cp "$PROJECT_DIR/config/$svc" "$PROFILE_DIR/airootfs/etc/systemd/system/$svc"
    fi
done

cp "$PROJECT_DIR/scripts/first-boot.sh" "$PROFILE_DIR/airootfs/opt/nexusos/first-boot.sh"
chmod +x "$PROFILE_DIR/airootfs/opt/nexusos/first-boot.sh"

cat > "$PROFILE_DIR/airootfs/etc/systemd/system/nexus-firstboot.service" << 'EOF'
[Unit]
Description=NexusOS First Boot Setup
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/opt/nexusos/first-boot.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

mkdir -p "$PROFILE_DIR/airootfs/etc/systemd/system/multi-user.target.wants"
for svc in nexus-ai nexus-tor nexus-firewall nexus-firstboot; do
    ln -sf "/etc/systemd/system/${svc}.service" \
           "$PROFILE_DIR/airootfs/etc/systemd/system/multi-user.target.wants/${svc}.service" 2>/dev/null || true
done

if [[ -d "$PROJECT_DIR/installer" ]]; then
    mkdir -p "$PROFILE_DIR/airootfs/etc/calamares"
    cp -r "$PROJECT_DIR/installer/"* "$PROFILE_DIR/airootfs/etc/calamares/" 2>/dev/null || true
fi

echo -e "${GREEN}✓ Profile customized${NC}"

# --- Build ISO ---
echo -e "${BLUE}[4/6] Building ISO (this will take a while)...${NC}"
mkdir -p "$WORK_DIR" "$OUTPUT_DIR"

mkarchiso -v \
    -w "$WORK_DIR" \
    -o "$OUTPUT_DIR" \
    -L "$ISO_LABEL" \
    "$PROFILE_DIR"

echo -e "${GREEN}✓ ISO built successfully${NC}"

# --- Post-build ---
echo -e "${BLUE}[5/6] Post-build tasks...${NC}"
ISO_FILE="$OUTPUT_DIR/${ISO_NAME}-${ISO_VERSION}-x86_64.iso"

if [[ -f "$ISO_FILE" ]]; then
    cd "$OUTPUT_DIR"
    sha256sum "${ISO_NAME}-${ISO_VERSION}-x86_64.iso" > "${ISO_NAME}-${ISO_VERSION}-x86_64.iso.sha256"
    md5sum "${ISO_NAME}-${ISO_VERSION}-x86_64.iso" > "${ISO_NAME}-${ISO_VERSION}-x86_64.iso.md5"
    echo -e "${GREEN}✓ Checksums generated${NC}"
else
    echo -e "${RED}Warning: ISO file not found at expected location${NC}"
fi

# --- Summary ---
echo -e "${BLUE}[6/6] Build complete!${NC}"
echo ""
echo -e "${GREEN}◆ NexusOS ISO Build Summary${NC}"
echo -e "${GREEN}============================${NC}"
echo -e "  ISO:      ${ISO_FILE}"
echo -e "  Size:     $(du -h "$ISO_FILE" 2>/dev/null | cut -f1 || echo 'unknown')"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Flash to USB: ${BLUE}sudo dd if=${ISO_FILE} of=/dev/sdX bs=4M status=progress${NC}"
echo -e "  2. Boot from USB"
echo -e "  3. Follow the installer"
echo ""
echo -e "${GREEN}◆ NexusOS — Your OS. Your Rules. Your Privacy.${NC}"