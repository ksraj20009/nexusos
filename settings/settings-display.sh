#!/bin/bash
# Vajra OS — Display Settings
# Resolution, scaling, orientation, night light, multi-monitor
set -e

echo "◆ Vajra OS — Display Settings Setup"

SD_DIR="/opt/vajra/settings"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/settings-display.sh" << 'DISP'
#!/bin/bash

case "${1:-status}" in
    status)
        echo "  Vajra OS - Display Settings"
        echo ""
        echo "  Connected Displays:"
        xrandr 2>/dev/null | grep " connected" | while read -r line; do
            NAME=$(echo "$line" | awk '{print $1}')
            RES=$(echo "$line" | grep -o '[0-9]*x[0-9]*' | head -1)
            echo "    $NAME: $RES"
        done
        echo ""
        echo "  Available Resolutions:"
        xrandr 2>/dev/null | grep -E "^\s+[0-9]" | awk '{print "    "$1}' | head -10
        echo ""
        echo "  Scaling: $(gsettings get org.gnome.desktop.interface scaling-factor 2>/dev/null || echo 'default')"
        echo "  Orientation: $(xrandr 2>/dev/null | grep ' connected' | grep -o 'right\|left\|inverted' || echo 'normal')"
        echo "  Refresh Rate: $(xrandr 2>/dev/null | grep '*' | grep -o '[0-9.]*\*' | head -1)"
        NIGHT=$(cat /tmp/vajra-nightlight 2>/dev/null || echo "off")
        echo "  Night Light: $NIGHT"
        ;;
    resolution)
        DISP="$2"; RES="$3"
        [ -z "$DISP" ] || [ -z "$RES" ] && echo "  Usage: vajra-settings display resolution <display> <WxH>" && exit 1
        xrandr --output "$DISP" --mode "$RES" 2>/dev/null
        echo "  ✓ Set $DISP to $RES"
        ;;
    scale)
        FACTOR="${2:-1}"
        case "$FACTOR" in
            100) gsettings set org.gnome.desktop.interface scaling-factor 0 2>/dev/null ;;
            125) gsettings set org.gnome.desktop.interface scaling-factor 1 2>/dev/null; gsettings set org.gnome.desktop.interface text-scaling-factor 1.25 2>/dev/null ;;
            150) gsettings set org.gnome.desktop.interface scaling-factor 1 2>/dev/null; gsettings set org.gnome.desktop.interface text-scaling-factor 1.5 2>/dev/null ;;
            200) gsettings set org.gnome.desktop.interface scaling-factor 2 2>/dev/null ;;
            *) gsettings set org.gnome.desktop.interface text-scaling-factor "$FACTOR" 2>/dev/null ;;
        esac
        echo "  ✓ Scaling set to ${FACTOR}%"
        ;;
    rotate)
        DISP="${2:-eDP-1}"; DIR="${3:-normal}"
        xrandr --output "$DISP" --rotate "$DIR" 2>/dev/null
        echo "  ✓ Rotated $DISP to $DIR"
        ;;
    arrange)
        DISPLAYS=$(xrandr 2>/dev/null | grep " connected" | awk '{print $1}')
        PREV=""
        for d in $DISPLAYS; do
            if [ -z "$PREV" ]; then
                xrandr --output "$d" --primary --auto 2>/dev/null
                PREV="$d"
            else
                xrandr --output "$d" --right-of "$PREV" --auto 2>/dev/null
                PREV="$d"
            fi
        done
        echo "  ✓ Displays arranged side by side"
        ;;
    mirror)
        DISPLAYS=$(xrandr 2>/dev/null | grep " connected" | awk '{print $1}')
        for d in $DISPLAYS; do
            xrandr --output "$d" --auto --same-as $(echo "$DISPLAYS" | head -1) 2>/dev/null
        done
        echo "  ✓ Displays mirrored"
        ;;
    extend)
        DISPLAYS=$(xrandr 2>/dev/null | grep " connected" | awk '{print $1}')
        for d in $DISPLAYS; do xrandr --output "$d" --auto 2>/dev/null; done
        echo "  ✓ Extended displays"
        ;;
    nightlight) vajra-nightlight "${2:-on}" ;;
    single)
        DISP="$2"
        [ -z "$DISP" ] && echo "  Usage: vajra-settings display single <display>" && exit 1
        ALL=$(xrandr 2>/dev/null | grep " connected" | awk '{print $1}')
        for d in $ALL; do
            if [ "$d" = "$DISP" ]; then xrandr --output "$d" --auto 2>/dev/null
            else xrandr --output "$d" --off 2>/dev/null; fi
        done
        echo "  ✓ Using only $DISP"
        ;;
    *) echo "Usage: vajra-settings display {status|resolution|scale|rotate|arrange|mirror|extend|nightlight|single}" ;;
esac
DISP
chmod +x "$SD_DIR/settings-display.sh"
ln -sf "$SD_DIR/settings-display.sh" /usr/local/bin/vajra-settings-display 2>/dev/null || true

echo "  ✓ Display settings installed"
echo "◆ Done"
