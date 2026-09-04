#!/bin/bash
# Vajra OS — Font Manager
# Install, manage, and preview fonts including Indic fonts
set -e

echo "◆ Vajra OS — Font Manager Setup"

FM_DIR="/opt/vajra/fonts"
mkdir -p "$FM_DIR" "$FM_DIR/downloads"

cat > "$FM_DIR/font-manager.sh" << 'FM'
#!/bin/bash

FONT_DIRS=("/usr/share/fonts/truetype/vajra" "$HOME/.local/share/fonts")
for d in "${FONT_DIRS[@]}"; do
    mkdir -p "$d"
done

case "${1:-list}" in
    list)
        echo "◆ Installed Fonts:"
        fc-list | sed 's/:.*: /  /' | sort -u | head -50
        ;;
    indic)
        echo "◆ Installing Indic font collections..."
        INDIC_FONTS=(
            fonts-noto fonts-noto-cjk fonts-noto-color-emoji
            fonts-indic fonts-noto-sans-devanagari
            fonts-noto-sans-bengali fonts-noto-sans-tamil
            fonts-noto-sans-telugu fonts-noto-sans-kannada
            fonts-noto-sans-gujarati fonts-noto-sans-malayalam
            fonts-noto-sans-gurmukhi fonts-noto-sans-oriya
        )
        sudo apt-get install -y "${INDIC_FONTS[@]}" 2>/dev/null || true
        echo "  ✓ Indic fonts installed"
        fc-cache -f
        ;;
    install)
        FONT_FILE="$2"
        if [ -f "$FONT_FILE" ]; then
            cp "$FONT_FILE" "$HOME/.local/share/fonts/"
            fc-cache -f
            echo "  ✓ Installed: $FONT_FILE"
        else
            echo "  ✗ File not found: $FONT_FILE"
        fi
        ;;
    preview)
        echo "◆ Font Preview:"
        fc-list | head -20 | while read -r line; do
            font=$(echo "$line" | cut -d: -f1)
            name=$(echo "$line" | cut -d: -f2 | sed 's/^ //')
            echo "  $name"
            echo "    Path: $font"
        done
        ;;
    cache)
        echo "◆ Rebuilding font cache..."
        fc-cache -fv 2>/dev/null | tail -1
        echo "  ✓ Font cache rebuilt"
        ;;
    *)
        echo "Usage: vajra-font {list|indic|install <file>|preview|cache}"
        ;;
esac
FM
chmod +x "$FM_DIR/font-manager.sh"
ln -sf "$FM_DIR/font-manager.sh" /usr/local/bin/vajra-font 2>/dev/null || true

echo "  ✓ Font manager installed"
echo "  ◆ Usage: vajra-font {list|indic|install|preview|cache}"
echo "◆ Done"
