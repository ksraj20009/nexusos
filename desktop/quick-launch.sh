#!/bin/bash
# Vajra OS — Quick Launch
# Application launcher / dock with favorites
set -e

echo "◆ Vajra OS — Quick Launch Setup"

QL_DIR="/opt/vajra/quicklaunch"
mkdir -p "$QL_DIR"

cat > "$QL_DIR/quick-launch.sh" << 'QL'
#!/bin/bash
FAVORITES_FILE="$HOME/.config/vajra/favorites"
mkdir -p "$(dirname "$FAVORITES_FILE")"

[ ! -f "$FAVORITES_FILE" ] && cat > "$FAVORITES_FILE" << FAV
firefox-esr|Web Browser
thunderbird|Email
libreoffice|LibreOffice
gnome-terminal|Terminal
nautilus|Files
gnome-system-monitor|System Monitor
vlc|Media Player
FAV

case "${1:-menu}" in
    menu)
        echo "╔═══════════════════════════════════════════════╗"
        echo "║  ◆ Vajra OS — Quick Launch                   ║"
        echo "╠═══════════════════════════════════════════════╣"
        NL=1
        while IFS='|' read -r cmd name; do
            printf "║  %d. %-40s║\n" "$NL" "$name"
            NL=$((NL+1))
        done < "$FAVORITES_FILE"
        echo "║  0. Exit"
        echo "╚═══════════════════════════════════════════════╝"
        echo ""
        read -p "  Select [0-$((NL-1))]: " choice
        if [ "$choice" = "0" ]; then exit 0
        elif [ "$choice" -ge 1 ] 2>/dev/null && [ "$choice" -le $((NL-1)) ]; then
            CMD=$(sed -n "${choice}p" "$FAVORITES_FILE" | cut -d'|' -f1)
            echo "  Launching: $CMD"
            nohup $CMD &>/dev/null &
        fi
        ;;
    search)
        QUERY="$2"
        echo "◆ Searching apps for: $QUERY"
        for app_dir in /usr/share/applications ~/.local/share/applications; do
            grep -il "$QUERY" "$app_dir"/*.desktop 2>/dev/null | while read -r f; do
                NAME=$(grep "^Name=" "$f" | cut -d= -f2)
                EXEC=$(grep "^Exec=" "$f" | cut -d= -f2 | sed 's/ %.*//')
                echo "  ● $NAME -> $EXEC"
            done
        done
        ;;
    add) CMD="$2"; NAME="$3"; [ -z "$CMD" ] || [ -z "$NAME" ] && echo "  Usage: vajra-launch add <cmd> <name>" && exit 1
        echo "$CMD|$NAME" >> "$FAVORITES_FILE"; echo "  ✓ Added $NAME" ;;
    remove) sed -i "/|$2$/d" "$FAVORITES_FILE"; echo "  ✓ Removed $2" ;;
    list)
        echo "◆ Favorites:"
        NL=1
        while IFS='|' read -r cmd name; do echo "  $NL. $name ($cmd)"; NL=$((NL+1)); done < "$FAVORITES_FILE"
        ;;
    run) nohup $2 &>/dev/null &; echo "  ✓ Launched: $2" ;;
    recent)
        echo "◆ Recent Documents:"
        find ~ -maxdepth 3 \( -name "*.txt" -o -name "*.pdf" -o -name "*.docx" -o -name "*.md" \) 2>/dev/null | \
        xargs ls -t 2>/dev/null | head -10 | while read -r f; do echo "  ● $(basename "$f")"; echo "    $f"; done
        ;;
    *) echo "Usage: vajra-launch {menu|search|add|remove|list|run|recent}" ;;
esac
QL
chmod +x "$QL_DIR/quick-launch.sh"
ln -sf "$QL_DIR/quick-launch.sh" /usr/local/bin/vajra-launch 2>/dev/null || true

echo "  ✓ Quick launch installed"
echo "  ◆ Usage: vajra-launch {menu|search|add|remove|list|recent}"
echo "◆ Done"
