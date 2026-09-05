#!/bin/bash
# Vajra OS — Startup Manager
# Manage applications that start on boot/login
set -e

echo "◆ Vajra OS — Startup Manager Setup"

SU_DIR="/opt/vajra/startup"
mkdir -p "$SU_DIR" "$HOME/.config/autostart"

cat > "$SU_DIR/startup-manager.sh" << 'SU'
#!/bin/bash
AUTOSTART_DIR="$HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"

case "${1:-list}" in
    list)
        echo "◆ Startup Applications:"
        for f in "$AUTOSTART_DIR"/*.desktop; do
            [ -f "$f" ] || continue
            NAME=$(grep "^Name=" "$f" | cut -d= -f2)
            ENABLED=$(grep "^X-GNOME-Autostart-enabled=" "$f" | cut -d= -f2)
            [ "$ENABLED" = "false" ] && STATUS="DISABLED" || STATUS="ENABLED"
            echo "  [$STATUS] $NAME"
        done
        ;;
    add)
        NAME="$2"; CMD="$3"
        [ -z "$NAME" ] || [ -z "$CMD" ] && echo "  Usage: vajra-startup add <name> <command>" && exit 1
        cat > "$AUTOSTART_DIR/$NAME.desktop" << DESK
[Desktop Entry]
Type=Application
Name=$NAME
Exec=$CMD
Terminal=false
X-GNOME-Autostart-enabled=true
DESK
        echo "  ✓ Added $NAME to startup"
        ;;
    remove)
        rm -f "$AUTOSTART_DIR/$2.desktop"
        echo "  ✓ Removed $2 from startup"
        ;;
    disable)
        sed -i 's/X-GNOME-Autostart-enabled=true/X-GNOME-Autostart-enabled=false/' "$AUTOSTART_DIR/$2.desktop" 2>/dev/null
        echo "  ✓ Disabled $2"
        ;;
    enable)
        sed -i 's/X-GNOME-Autostart-enabled=false/X-GNOME-Autostart-enabled=true/' "$AUTOSTART_DIR/$2.desktop" 2>/dev/null
        echo "  ✓ Enabled $2"
        ;;
    delay)
        NAME="$2"; SEC="${3:-5}"
        CMD=$(grep "^Exec=" "$AUTOSTART_DIR/$NAME.desktop" | cut -d= -f2)
        sed -i "s|^Exec=.*|Exec=bash -c 'sleep $SEC; $CMD'|" "$AUTOSTART_DIR/$NAME.desktop"
        echo "  ✓ Added ${SEC}s delay to $NAME"
        ;;
    *) echo "Usage: vajra-startup {list|add|remove|disable|enable|delay}" ;;
esac
SU
chmod +x "$SU_DIR/startup-manager.sh"
ln -sf "$SU_DIR/startup-manager.sh" /usr/local/bin/vajra-startup 2>/dev/null || true

echo "  ✓ Startup manager installed"
echo "  ◆ Usage: vajra-startup {list|add|remove|disable|enable|delay}"
echo "◆ Done"
