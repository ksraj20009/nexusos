#!/bin/bash
# ============================================================================
# Vajra OS — Build ALL .deb packages and add to repository
# ============================================================================
# This is the master build script that:
#   1. Builds every vajra-* package
#   2. Adds them to the APT repository
#   3. Signs the repo
#   4. Reports the final state
#
# Usage: sudo bash build-all-packages.sh
# ============================================================================
set -e

PACKAGING_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="/srv/repo/vajra"
BUILT=0
FAILED=0
FAILED_PACKAGES=""

echo "============================================"
echo "  Vajra OS — Master Package Builder"
echo "  Building all vajra-* packages"
echo "============================================"

# --- Find all package directories ---
PACKAGES=$(find "$PACKAGING_DIR" -maxdepth 1 -type d -name "vajra-*" | sort)

if [ -z "$PACKAGES" ]; then
    echo "[-] No package directories found in $PACKAGING_DIR"
    exit 1
fi

TOTAL=$(echo "$PACKAGES" | wc -l)
echo "[*] Found $TOTAL packages to build"
echo ""

# --- Build each package ---
for PKG_DIR in $PACKAGES; do
    PKG_NAME=$(basename "$PKG_DIR")
    echo "--- Building: $PKG_NAME ---"
    
    cd "$PKG_DIR"
    
    # Clean previous builds
    rm -f *.deb *.changes *.buildinfo 2>/dev/null
    dh_clean 2>/dev/null || true
    
    # Build
    if dpkg-buildpackage -us -uc -b 2>&1 | tail -3; then
        DEB_FILE=$(ls "$PACKAGING_DIR"/${PKG_NAME}_*.deb 2>/dev/null | head -1)
        if [ -n "$DEB_FILE" ]; then
            echo "  [+] Built: $(basename $DEB_FILE) ($(du -h $DEB_FILE | cut -f1))"
            ((BUILT++))
        else
            echo "  [-] No .deb produced"
            ((FAILED++))
            FAILED_PACKAGES="$FAILED_PACKAGES $PKG_NAME"
        fi
    else
        echo "  [-] Build failed"
        ((FAILED++))
        FAILED_PACKAGES="$FAILED_PACKAGES $PKG_NAME"
    fi
    echo ""
done

# --- Add all .deb files to repository ---
echo "============================================"
echo "  Adding packages to APT repository"
echo "============================================"

if [ -d "$REPO_ROOT" ]; then
    cd "$PACKAGING_DIR"
    for DEB in *.deb; do
        [ -f "$DEB" ] || continue
        echo "[*] Adding: $DEB"
        reprepro -b "$REPO_ROOT" includedeb vajra "$DEB" 2>/dev/null && echo "  [+] Added" || echo "  [-] Failed to add (may already exist)"
    done
    
    # Update repository
    echo ""
    echo "[*] Updating repository index..."
    reprepro -b "$REPO_ROOT" export vajra 2>/dev/null || true
    
    # List final state
    echo ""
    echo "--- Repository Contents ---"
    reprepro -b "$REPO_ROOT" list vajra 2>/dev/null || echo "  (empty or error)"
else
    echo "[-] Repository not initialized. Run repo-setup.sh first."
    echo "    Packages are built in $PACKAGING_DIR/"
fi

# --- Summary ---
echo ""
echo "============================================"
echo "  Build Summary"
echo "============================================"
echo "  Total:   $TOTAL"
echo "  Built:   $BUILT"
echo "  Failed:  $FAILED"
if [ -n "$FAILED_PACKAGES" ]; then
    echo "  Failed packages:$FAILED_PACKAGES"
fi
echo ""
if [ "$FAILED" -eq 0 ]; then
    echo "  ALL PACKAGES BUILT SUCCESSFULLY!"
else
    echo "  Some packages failed — check output above"
fi
echo "============================================"
