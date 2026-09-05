#!/bin/bash
# Vajra OS — Window Tiler
# Snap windows like Windows (Win+Arrow) and auto-tiling
set -e

echo "◆ Vajra OS — Window Tiler Setup"

WT_DIR="/opt/vajra/window-tiler"
mkdir -p "$WT_DIR"

cat > "$WT_DIR/window-tiler.sh" << 'WT'
#!/bin/bash
get_screen_size() {
    if command -v xrandr &>/dev/null; then
        xrandr | grep '*' | awk '{print $1}' | head -1 | tr 'x' ' '
    else
        echo "1920 1080"
    fi
}
get_active_window() { xdotool getactivewindow 2>/dev/null || echo ""; }
snap_left() {
    W=$(get_active_window); [ -z "$W" ] && return
    read SW SH <<< "$(get_screen_size)"; W=$((SW / 2))
    xdotool windowsize "$W" "$W" "$SH" 2>/dev/null; xdotool windowmove "$W" 0 0 2>/dev/null
    echo "  ✓ Snapped left"
}
snap_right() {
    W=$(get_active_window); [ -z "$W" ] && return
    read SW SH <<< "$(get_screen_size)"; WSIZE=$((SW / 2)); XPOS=$((SW / 2))
    xdotool windowsize "$W" "$WSIZE" "$SH" 2>/dev/null; xdotool windowmove "$W" "$XPOS" 0 2>/dev/null
    echo "  ✓ Snapped right"
}
snap_full() {
    W=$(get_active_window); [ -z "$W" ] && return
    read SW SH <<< "$(get_screen_size)"
    xdotool windowsize "$W" "$SW" "$SH" 2>/dev/null; xdotool windowmove "$W" 0 0 2>/dev/null
    echo "  ✓ Maximized"
}
snap_top() {
    W=$(get_active_window); [ -z "$W" ] && return
    read SW SH <<< "$(get_screen_size)"; HALF=$((SH / 2))
    xdotool windowsize "$W" "$SW" "$HALF" 2>/dev/null; xdotool windowmove "$W" 0 0 2>/dev/null
    echo "  ✓ Snapped top"
}
snap_bottom() {
    W=$(get_active_window); [ -z "$W" ] && return
    read SW SH <<< "$(get_screen_size)"; HALF=$((SH / 2)); YPOS=$((SH / 2))
    xdotool windowsize "$W" "$SW" "$HALF" 2>/dev/null; xdotool windowmove "$W" 0 "$YPOS" 2>/dev/null
    echo "  ✓ Snapped bottom"
}
tile_all() {
    WINDOWS=$(xdotool search --onlyvisible --name "" 2>/dev/null | head -6)
    COUNT=$(echo "$WINDOWS" | wc -l)
    read SW SH <<< "$(get_screen_size)"
    case "$COUNT" in
        1) snap_full ;;
        2)
            W1=$(echo "$WINDOWS" | sed -n 1p); W2=$(echo "$WINDOWS" | sed -n 2p)
            HALF=$((SW / 2))
            xdotool windowsize "$W1" "$HALF" "$SH" && xdotool windowmove "$W1" 0 0
            xdotool windowsize "$W2" "$HALF" "$SH" && xdotool windowmove "$W2" "$HALF" 0
            echo "  ✓ Tiled 2 windows (split)" ;;
        4)
            QW=$((SW / 2)); QH=$((SH / 2))
            POSS=("0 0" "$QW 0" "0 $QH" "$QW $QH"); I=0
            for W in $WINDOWS; do
                X=$(echo "${POSS[$I]}" | awk '{print $1}'); Y=$(echo "${POSS[$I]}" | awk '{print $2}')
                xdotool windowsize "$W" "$QW" "$QH"; xdotool windowmove "$W" "$X" "$Y"
                I=$((I+1))
            done
            echo "  ✓ Tiled 4 windows (grid)" ;;
        *) echo "  Use snap commands for $COUNT windows" ;;
    esac
}
case "${1:-help}" in
    left|l) snap_left ;; right|r) snap_right ;; full|f|maximize) snap_full ;;
    top|t) snap_top ;; bottom|b) snap_bottom ;; tile) tile_all ;;
    *) echo "Usage: vajra-tile {left|right|top|bottom|full|tile}" ;;
esac
WT
chmod +x "$WT_DIR/window-tiler.sh"
ln -sf "$WT_DIR/window-tiler.sh" /usr/local/bin/vajra-tile 2>/dev/null || true
command -v xdotool &>/dev/null || sudo apt-get install -y xdotool 2>/dev/null || true

echo "  ✓ Window tiler installed"
echo "  ◆ Usage: vajra-tile {left|right|top|bottom|full|tile}"
echo "◆ Done"
