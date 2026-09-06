#!/bin/bash
# Vajra OS Regional Keyboard Layouts
# Installs and configures 12+ Indic keyboard layouts

set -e

echo "=== Vajra OS Regional Keyboard Layouts ==="

LAYOUTS=(
    "in:eng:Indian English (with Rupee on AltGr+4)"
    "in:hin:Hindi (Devanagari phonetic)"
    "in:ben:Bengali (phonetic)"
    "in:tam:Tamil (phonetic)"
    "in:tel:Telugu (phonetic)"
    "in:mar:Marathi (Devanagari)"
    "in:kan:Kannada (KaGaPa)"
    "in:mal:Malayalam (Swanalekha)"
    "in:guj:Gujarati (phonetic)"
    "in:guru:Punjabi (Gurmukhi)"
    "in:urd:Urdu (Nastaliq phonetic)"
    "in:ori:Odia (phonetic)"
    "in:asm:Assamese (phonetic)"
)

echo "Available keyboard layouts:"
for i in "${!LAYOUTS[@]}"; do
    IFS=':' read -r country variant desc <<< "${LAYOUTS[$i]}"
    echo "  $((i+1)). $desc"
done

echo ""
echo "Select layouts to install (comma-separated, 'all', or 'skip'):"
read -r choice

if [ "$choice" = "skip" ]; then exit 0; fi

if [ "$choice" = "all" ]; then
    SELECTED=("${!LAYOUTS[@]}")
else
    IFS=',' read -ra INDICES <<< "$choice"
    SELECTED=()
    for idx in "${INDICES[@]}"; do
        if [ "$idx" -ge 1 ] && [ "$idx" -le "${#LAYOUTS[@]}" ] 2>/dev/null; then
            SELECTED+=("$((idx-1))")
        fi
    done
fi

echo "[*] Installing input framework..."
apt-get install -y ibus ibus-m17n m17n-db im-config 2>/dev/null || true

INPUT_SOURCES=""
for idx in "${SELECTED[@]}"; do
    IFS=':' read -r country variant desc <<< "${LAYOUTS[$idx]}"
    echo "[+] Adding: $desc"
    src="('xkb', '$country+$variant')"
    if [ -z "$INPUT_SOURCES" ]; then
        INPUT_SOURCES="$src"
    else
        INPUT_SOURCES="$INPUT_SOURCES, $src"
    fi
done

if [ -n "$INPUT_SOURCES" ]; then
    INPUT_SOURCES="[$INPUT_SOURCES]"
    gsettings set org.gnome.desktop.input-sources sources "$INPUT_SOURCES" 2>/dev/null || true
    echo "[+] Input sources configured"
fi

im-config -n ibus 2>/dev/null || true
ibus restart 2>/dev/null || true

echo ""
echo "=== Regional Keyboard Setup Complete ==="
echo "Installed layouts: ${#SELECTED[@]}"
echo "Switch keyboards: Super+Space"