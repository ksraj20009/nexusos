#!/bin/bash
# Vajra OS — Spotlight Search
# Universal search: apps, files, web, commands, math
set -e

echo "◆ Vajra OS — Spotlight Search Setup"

SL_DIR="/opt/vajra/spotlight"
mkdir -p "$SL_DIR"

cat > "$SL_DIR/spotlight.sh" << 'SL'
#!/bin/bash
# Vajra Spotlight — Press Ctrl+Space to search

QUERY="$*"

if [ -z "$QUERY" ]; then
    QUERY=$(zenity --entry --title="Vajra Spotlight" \
        --text="Search apps, files, web, or type a calculation:" \
        --entry-text="" 2>/dev/null)
    [ -z "$QUERY" ] && exit 0
fi

# 1. Check if it's math
if echo "$QUERY" | grep -qE '^[0-9+\-*/.() ]+$'; then
    RESULT=$(echo "$QUERY" | bc -l 2>/dev/null)
    [ -n "$RESULT" ] && echo "= $RESULT" && notify-send "Vajra Spotlight" "$QUERY = $RESULT" && exit 0
fi

# 2. Search apps
FOUND_APP=""
for app_dir in /usr/share/applications ~/.local/share/applications; do
    MATCH=$(grep -il "$QUERY" "$app_dir"/*.desktop 2>/dev/null | head -1)
    if [ -n "$MATCH" ]; then
        FOUND_APP="$MATCH"
        break
    fi
done

if [ -n "$FOUND_APP" ]; then
    APP_NAME=$(grep "^Name=" "$FOUND_APP" | cut -d= -f2 | head -1)
    APP_EXEC=$(grep "^Exec=" "$FOUND_APP" | cut -d= -f2 | head -1 | sed 's/ %.*//')
    echo "App: $APP_NAME"
    notify-send "Vajra Spotlight" "Opening: $APP_NAME"
    nohup $APP_EXEC &>/dev/null &
    exit 0
fi

# 3. Search files
FILE_MATCH=$(find ~ -maxdepth 4 -iname "*$QUERY*" 2>/dev/null | head -5)
if [ -n "$FILE_MATCH" ]; then
    echo "Files found:"
    echo "$FILE_MATCH"
    FIRST=$(echo "$FILE_MATCH" | head -1)
    xdg-open "$FIRST" 2>/dev/null &
    exit 0
fi

# 4. Search web
echo "Searching web: $QUERY"
xdg-open "https://duckduckgo.com/?q=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$QUERY'))")" 2>/dev/null &
SL
chmod +x "$SL_DIR/spotlight.sh"
ln -sf "$SL_DIR/spotlight.sh" /usr/local/bin/vajra-spotlight 2>/dev/null || true

# Auto-bind Ctrl+Space in GNOME
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/vajra-spotlight/']" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/vajra-spotlight/ name "Vajra Spotlight" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/vajra-spotlight/ command "vajra-spotlight" 2>/dev/null || true
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/vajra-spotlight/ binding "<Control>space" 2>/dev/null || true

echo "  ✓ Spotlight search installed (Ctrl+Space)"
echo "  ◆ Usage: vajra-spotlight <query> or press Ctrl+Space"
echo "◆ Done"
