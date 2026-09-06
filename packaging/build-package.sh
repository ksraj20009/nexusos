#!/bin/bash
# ============================================================================
# Vajra OS — Build a single .deb package
# ============================================================================
# Usage: bash build-package.sh <package-name>
# Example: bash build-package.sh vajra-control-center
#
# This builds a proper Debian .deb package from a package directory.
# Each package directory under packaging/ has:
#   - debian/control        (package metadata + dependencies)
#   - debian/rules          (build rules)
#   - debian/changelog      (version history)
#   - debian/install        (file install locations)
#   - debian/postinst       (post-install script)
#   - debian/compat         (debhelper compatibility)
#   - src/                  (source files to install)
# ============================================================================
set -e

PKG_NAME="$1"
PACKAGING_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ -z "$PKG_NAME" ]; then
    echo "Usage: bash build-package.sh <package-name>"
    echo ""
    echo "Available packages:"
    ls -d "$PACKAGING_DIR"/vajra-*/ 2>/dev/null | xargs -I{} basename {} | sed 's/^/  /'
    exit 1
fi

PKG_DIR="$PACKAGING_DIR/$PKG_NAME"

if [ ! -d "$PKG_DIR" ]; then
    echo "[-] Package directory not found: $PKG_DIR"
    echo "Available packages:"
    ls -d "$PACKAGING_DIR"/vajra-*/ 2>/dev/null | xargs -I{} basename {} | sed 's/^/  /'
    exit 1
fi

echo "============================================"
echo "  Building: $PKG_NAME"
echo "============================================"

# --- Check prerequisites ---
if ! command -v dpkg-buildpackage &>/dev/null; then
    echo "[*] Installing build tools..."
    sudo apt-get install -y dpkg-dev debhelper devscripts 2>/dev/null
fi

# --- Verify debian/ directory ---
if [ ! -d "$PKG_DIR/debian" ]; then
    echo "[-] No debian/ directory in $PKG_DIR"
    exit 1
fi

if [ ! -f "$PKG_DIR/debian/control" ]; then
    echo "[-] Missing debian/control"
    exit 1
fi

if [ ! -f "$PKG_DIR/debian/rules" ]; then
    echo "[-] Missing debian/rules"
    exit 1
fi

if [ ! -f "$PKG_DIR/debian/changelog" ]; then
    echo "[-] Missing debian/changelog"
    exit 1
fi

# --- Build ---
echo "[1/3] Cleaning previous builds..."
cd "$PKG_DIR"
rm -f *.deb *.changes *.buildinfo *.dsc
dh_clean 2>/dev/null || true

echo "[2/3] Building package..."
dpkg-buildpackage -us -uc -b 2>&1 | tail -15

# --- Find and verify the built .deb ---
echo "[3/3] Verifying package..."
DEB_FILE=$(ls "$PACKAGING_DIR"/${PKG_NAME}_*.deb 2>/dev/null | head -1)

if [ -n "$DEB_FILE" ]; then
    echo ""
    echo "[+] Package built successfully!"
    echo "    File: $(basename $DEB_FILE)"
    echo "    Size: $(du -h $DEB_FILE | cut -f1)"
    echo ""
    echo "    Contents:"
    dpkg-deb --contents "$DEB_FILE" | head -20
    echo ""
    echo "    Install with: sudo dpkg -i $DEB_FILE"
    echo "    Add to repo:  reprepro -b /srv/repo/vajra includedeb vajra $DEB_FILE"
else
    echo "[-] Build failed — no .deb file found"
    exit 1
fi
