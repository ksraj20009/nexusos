#!/bin/bash
# =============================================================
# Vajra OS Custom Icon Theme Generator
# Creates a branded icon set for Vajra OS applications
# =============================================================

set -e

ICON_DIR="/usr/share/icons/Vajra"
THEME_NAME="Vajra"

echo "=== Vajra OS Icon Theme Generator ==="

# --- Create directory structure ---
echo "[*] Creating icon theme directories..."

SIZES=(16 22 24 32 48 64 96 128 256)
CATEGORIES=(apps actions devices places categories status mimes emblems)

for size in "${SIZES[@]}"; do
    for cat in "${CATEGORIES[@]}"; do
        mkdir -p "$ICON_DIR/${size}x${size}/$cat"
    done
done

# Scalable icons (SVG)
for cat in "${CATEGORIES[@]}"; do
    mkdir -p "$ICON_DIR/scalable/$cat"
done

# --- Create theme index ---
cat > "$ICON_DIR/index.theme" << 'THEME'
[Icon Theme]
Name=Vajra
Comment=Vajra OS Icon Theme
Inherits=Adwaita,Mint-X,elementary

[16x16/apps]
Size=16
Context=Applications
Type=Fixed

[22x22/apps]
Size=22
Context=Applications
Type=Fixed

[48x48/apps]
Size=48
Context=Applications
Type=Fixed

[256x256/apps]
Size=256
Context=Applications
Type=Fixed

[scalable/apps]
Size=128
Context=Applications
Type=Scalable
MinSize=16
MaxSize=512
THEME

echo "[+] Theme index created"

# --- Generate Vajra SVG icons ---
echo "[*] Generating Vajra SVG icons..."

generate_icon() {
    local name="$1"
    local svg="$2"
    local dir="$ICON_DIR/scalable/apps"
    echo "$svg" > "$dir/$name.svg"
}

# Vajra Logo (Thunderbolt pattern)
generate_icon "vajra-os" '<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 128 128"><rect width="128" height="128" rx="20" fill="#0A1628"/><path d="M64 16L40 72H58L48 112L88 56H66L76 16Z" fill="#FFD700" stroke="#B8860B" stroke-width="2"/></svg>'

# Buddhi AI icon
generate_icon "buddhi-ai" '<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 128 128"><rect width="128" height="128" rx="20" fill="#0A1628"/><circle cx="64" cy="64" r="40" fill="none" stroke="#FFD700" stroke-width="4"/><circle cx="64" cy="64" r="20" fill="#FFD700" opacity="0.8"/><path d="M64 24V44M64 84V104M24 64H44M84 64H104" stroke="#FFD700" stroke-width="4" stroke-linecap="round"/></svg>'

# Vajra Terminal
generate_icon "vajra-terminal" '<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 128 128"><rect width="128" height="128" rx="20" fill="#0A1628"/><rect x="16" y="24" width="96" height="80" rx="6" fill="#1A2F4E" stroke="#FFD700" stroke-width="2"/><text x="28" y="60" fill="#FFD700" font-family="monospace" font-size="20">>_</text></svg>'

# Vajra Calculator
generate_icon "vajra-calculator" '<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 128 128"><rect width="128" height="128" rx="20" fill="#0A1628"/><rect x="20" y="16" width="88" height="24" rx="4" fill="#1A2F4E" stroke="#FFD700"/><g fill="#1A2F4E" stroke="#FFD700"><rect x="20" y="48" width="20" height="20" rx="3"/><rect x="44" y="48" width="20" height="20" rx="3"/><rect x="68" y="48" width="20" height="20" rx="3"/><rect x="92" y="48" width="20" height="20" rx="3" fill="#FFD700"/><rect x="20" y="72" width="20" height="20" rx="3"/><rect x="44" y="72" width="20" height="20" rx="3"/><rect x="92" y="72" width="20" height="20" rx="3" fill="#FFD700"/></g></svg>'

# Vajra Security Shield
generate_icon "vajra-security" '<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 128 128"><rect width="128" height="128" rx="20" fill="#0A1628"/><path d="M64 16L28 32V64C28 88 44 104 64 112C84 104 100 88 100 64V32L64 16Z" fill="#1A2F4E" stroke="#FFD700" stroke-width="3"/><path d="M48 64L58 74L80 52" stroke="#FFD700" stroke-width="4" fill="none"/></svg>'

# Vajra Settings
generate_icon "vajra-settings" '<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 128 128"><rect width="128" height="128" rx="20" fill="#0A1628"/><circle cx="64" cy="64" r="20" fill="none" stroke="#FFD700" stroke-width="4"/><circle cx="64" cy="64" r="8" fill="#FFD700"/><g stroke="#FFD700" stroke-width="4"><path d="M64 24V36M64 92V104M24 64H36M92 64H104"/></g></svg>'

# Vajra File Manager
generate_icon "vajra-files" '<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 128 128"><rect width="128" height="128" rx="20" fill="#0A1628"/><path d="M16 40C16 34 20 30 26 30H50L60 42H102C108 42 112 46 112 52V88C112 94 108 98 102 98H26C20 98 16 94 16 88V40Z" fill="#1A2F4E" stroke="#FFD700" stroke-width="2"/></svg>'

# Vajra Music
generate_icon "vajra-music" '<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 128 128"><rect width="128" height="128" rx="20" fill="#0A1628"/><path d="M48 84V40L88 32V76" stroke="#FFD700" stroke-width="4" fill="none"/><circle cx="40" cy="84" r="12" fill="#FFD700"/><circle cx="80" cy="76" r="12" fill="#FFD700"/></svg>'

# Vajra Calendar
generate_icon "vajra-calendar" '<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 128 128"><rect width="128" height="128" rx="20" fill="#0A1628"/><rect x="16" y="24" width="96" height="88" rx="6" fill="#1A2F4E" stroke="#FFD700"/><rect x="16" y="24" width="96" height="20" rx="6" fill="#FFD700"/><text x="64" y="80" text-anchor="middle" fill="#FFD700" font-size="32" font-weight="bold">14</text><circle cx="92" cy="80" r="6" fill="#FF4444"/></svg>'

# Vajra Weather
generate_icon "vajra-weather" '<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 128 128"><rect width="128" height="128" rx="20" fill="#0A1628"/><circle cx="48" cy="48" r="16" fill="#FFD700"/><path d="M36 76C28 76 20 82 20 92C20 100 26 106 34 106H86C94 106 102 98 102 88C102 80 96 74 88 72C88 62 80 54 70 54C60 54 50 62 48 72C44 74 40 76 36 76Z" fill="#1A2F4E" stroke="#FFD700" stroke-width="2"/></svg>'

# Vajra App Store
generate_icon "vajra-app-store" '<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 128 128"><rect width="128" height="128" rx="20" fill="#0A1628"/><path d="M52 28L84 64L52 100" stroke="#FFD700" stroke-width="6" fill="none" stroke-linecap="round"/><rect x="20" y="56" width="24" height="16" rx="3" fill="#FFD700"/></svg>'

echo "[+] Generated 11 custom Vajra SVG icons"
echo ""
echo "To apply: gsettings set org.gnome.desktop.interface icon-theme 'Vajra'"
echo ""
echo "=== Vajra Icon Theme Complete ==="