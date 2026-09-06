#!/bin/bash
# Vajra OS Indic Keyboard Setup
# Configures multi-language input for 10+ Indian languages

set -e

echo "=== Vajra OS Indic Keyboard Setup ==="

LANGUAGES=(
    "hi:हिन्दी (Hindi):Devanagari"
    "ta:தமிழ் (Tamil):Tamil"
    "bn:বাংলা (Bengali):Bengali"
    "te:తెలుగు (Telugu):Telugu"
    "mr:मराठी (Marathi):Devanagari"
    "kn:ಕನ್ನಡ (Kannada):Kannada"
    "ml:മലയാളം (Malayalam):Malayalam"
    "gu:ગુજરાતી (Gujarati):Gujarati"
    "pa:ਪੰਜਾਬੀ (Punjabi):Gurmukhi"
    "ur:اردو (Urdu):Nastaliq"
    "or:ଓଡ଼ିଆ (Odia):Odia"
    "as:অসমীয়া (Assamese):Assamese"
)

echo "Available Indic keyboard layouts:"
for i in "${!LANGUAGES[@]}"; do
    IFS=':' read -r code name script <<< "${LANGUAGES[$i]}"
    echo "  $((i+1)). $name ($script)"
done

echo ""
echo "Select languages to install (comma-separated, 'all', or 'skip'):"
read -r choice

if [ "$choice" = "skip" ]; then
    echo "Skipping Indic keyboard setup."
    exit 0
fi

if [ "$choice" = "all" ]; then
    SELECTED=("${!LANGUAGES[@]}")
else
    IFS=',' read -ra INDICES <<< "$choice"
    SELECTED=()
    for idx in "${INDICES[@]}"; do
        if [ "$idx" -ge 1 ] && [ "$idx" -le "${#LANGUAGES[@]}" ] 2>/dev/null; then
            SELECTED+=("$((idx-1))")
        fi
    done
fi

echo "[*] Installing IBus and m17n input frameworks..."
apt-get install -y ibus ibus-m17n m17n-db 2>/dev/null || true

INPUT_SOURCES=""
for idx in "${SELECTED[@]}"; do
    IFS=':' read -r code name script <<< "${LANGUAGES[$idx]}"
    echo "[+] Adding keyboard: $name"
    if [ -z "$INPUT_SOURCES" ]; then
        INPUT_SOURCES="('xkb', 'in'), ('ibus', 'm17n:ia:$code')"
    else
        INPUT_SOURCES="$INPUT_SOURCES, ('ibus', 'm17n:ia:$code')"
    fi
done

if [ -n "$INPUT_SOURCES" ]; then
    INPUT_SOURCES="[$INPUT_SOURCES]"
    gsettings set org.gnome.desktop.input-sources sources "$INPUT_SOURCES" 2>/dev/null || true
    echo "[+] Input sources configured"
fi

echo "[*] Enabling Rupee symbol input..."
echo "  Type Ctrl+Shift+U, then 20B9, then Enter to type ₹"

ibus restart 2>/dev/null || true

echo ""
echo "=== Indic Keyboard Setup Complete ==="
echo "Switch keyboards with Super+Space or the input indicator in the panel."