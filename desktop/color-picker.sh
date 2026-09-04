#!/bin/bash
# Vajra OS — Color Picker Tool
# Pick colors from screen, manage palettes
set -e

echo "◆ Vajra OS — Color Picker Setup"

CP_DIR="/opt/vajra/colorpicker"
mkdir -p "$CP_DIR"

cat > "$CP_DIR/color-picker.sh" << 'CP'
#!/bin/bash

PALETTE_FILE="$HOME/.local/share/vajra/palettes.json"
mkdir -p "$(dirname "$PALETTE_FILE")"
[ ! -f "$PALETTE_FILE" ] && echo '{"palettes": []}' > "$PALETTE_FILE"

case "${1:-pick}" in
    pick)
        echo "◆ Click anywhere to pick a color..."
        if command -v xcolor &>/dev/null; then
            COLOR=$(xcolor)
        elif command -v gpick &>/dev/null; then
            COLOR=$(gpick --one-shot --no-wrap)
        else
            import -window root -crop 1x1 /tmp/vajra-pixel.ppm 2>/dev/null
            COLOR=$(python3 -c "
from PIL import Image
img = Image.open('/tmp/vajra-pixel.ppm')
print('#%02x%02x%02x' % img.getpixel((0,0)))
" 2>/dev/null)
        fi
        if [ -n "$COLOR" ]; then
            echo "  Color: $COLOR"
            python3 -c "
color = '$COLOR'.lstrip('#')
r, g, b = int(color[0:2], 16), int(color[2:4], 16), int(color[4:6], 16)
print(f'  HEX:     #{color}')
print(f'  RGB:     rgb({r}, {g}, {b})')
print(f'  RGBA:    rgba({r}, {g}, {b}, 1.0)')
print(f'  HSL:     hsl({int(r/255*360)}, {int(g/255*100)}%, {int(b/255*100)}%)')
" 2>/dev/null
            echo -n "$COLOR" | xclip -selection clipboard 2>/dev/null || true
            echo "  ✓ Copied to clipboard"
        fi
        ;;
    palette)
        echo "◆ Color Palettes:"
        python3 -c "
import json
with open('$PALETTE_FILE') as f:
    data = json.load(f)
for p in data.get('palettes', []):
    print(f\"  {p['name']}:\")
    for c in p.get('colors', []):
        print(f\"    {c}\")
" 2>/dev/null || echo "  No palettes saved"
        ;;
    save)
        NAME="${2:-palette-$(date +%s)}"
        COLOR="${3:-#000000}"
        python3 -c "
import json
with open('$PALETTE_FILE') as f:
    data = json.load(f)
found = False
for p in data['palettes']:
    if p['name'] == '$NAME':
        p['colors'].append('$COLOR')
        found = True
if not found:
    data['palettes'].append({'name': '$NAME', 'colors': ['$COLOR']})
with open('$PALETTE_FILE', 'w') as f:
    json.dump(data, f, indent=2)
print('  ✓ Color $COLOR saved to palette $NAME')
" 2>/dev/null
        ;;
    random)
        python3 -c "
import colorsys, random
h = random.random()
r, g, b = colorsys.hsv_to_rgb(h, 0.7, 0.9)
print('#%02x%02x%02x' % (int(r*255), int(g*255), int(b*255)))
" 2>/dev/null
        ;;
    *)
        echo "Usage: vajra-color {pick|palette|save <name> <color>|random}"
        ;;
esac
CP
chmod +x "$CP_DIR/color-picker.sh"
ln -sf "$CP_DIR/color-picker.sh" /usr/local/bin/vajra-color 2>/dev/null || true

echo "  Installing color picker tools..."
sudo apt-get install -y xcolor gpick 2>/dev/null || true

echo "  ✓ Color picker installed"
echo "  ◆ Usage: vajra-color {pick|palette|save|random}"
echo "◆ Done"
