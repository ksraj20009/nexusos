#!/bin/bash
# =============================================================
# Vajra OS Custom Cursor Theme
# Creates a gold-accented cursor set for Vajra OS
# =============================================================

set -e

CURSOR_DIR="/usr/share/icons/Vajra-Cursors"
THEME_NAME="Vajra-Cursors"

echo "=== Vajra OS Cursor Theme Generator ==="

# --- Create directories ---
mkdir -p "$CURSOR_DIR/cursors"

# --- Create theme index ---
cat > "$CURSOR_DIR/index.theme" << 'THEME'
[Icon Theme]
Name=Vajra-Cursors
Comment=Vajra OS Gold Cursor Theme
Inherits=core
THEME

echo "[+] Theme index created"

# --- Generate cursor config files ---
cat > "$CURSOR_DIR/cursors/left_ptr.conf" << 'CONF'
# Vajra default pointer - 24x24 gold arrow cursor
size=24
hotspot_x=4
hotspot_y=4
CONF

cat > "$CURSOR_DIR/cursors/wait.conf" << 'CONF'
# Vajra wait cursor - animated spinning vajra bolt
size=24
hotspot_x=12
hotspot_y=12
frames=12
CONF

cat > "$CURSOR_DIR/cursors/xterm.conf" << 'CONF'
# Vajra text cursor - gold I-beam
size=24
hotspot_x=12
hotspot_y=12
CONF

cat > "$CURSOR_DIR/cursors/help.conf" << 'CONF'
# Vajra help cursor - arrow with question mark
size=24
hotspot_x=4
hotspot_y=4
CONF

cat > "$CURSOR_DIR/cursors/hand2.conf" << 'CONF'
# Vajra hand pointer - gold pointing hand
size=24
hotspot_x=8
hotspot_y=4
CONF

for name in "sb_h_double_arrow" "sb_v_double_arrow" "fd_double_arrow" "bd_double_arrow"; do
    cat > "$CURSOR_DIR/cursors/$name.conf" << CONF
# Vajra resize cursor: $name
size=24
hotspot_x=12
hotspot_y=12
CONF
done

cat > "$CURSOR_DIR/cursors/crosshair.conf" << 'CONF'
# Vajra crosshair cursor
size=24
hotspot_x=12
hotspot_y=12
CONF

cat > "$CURSOR_DIR/cursors/crossed_circle.conf" << 'CONF'
# Vajra not-allowed cursor - red circle with slash
size=24
hotspot_x=12
hotspot_y=12
CONF

cat > "$CURSOR_DIR/cursors/pencil.conf" << 'CONF'
# Vajra pencil cursor
size=24
hotspot_x=4
hotspot_y=20
CONF

cat > "$CURSOR_DIR/cursors/fleur.conf" << 'CONF'
# Vajra move cursor
size=24
hotspot_x=12
hotspot_y=12
CONF

cat > "$CURSOR_DIR/cursors/dnd-copy.conf" << 'CONF'
# Vajra copy cursor
size=24
hotspot_x=8
hotspot_y=4
CONF

# --- Create inherit symlinks ---
INHERIT_CURSORS=(
    "right_ptr:left_ptr"
    "hand1:hand2"
    "watch:wait"
    "sb_left_arrow:left_ptr"
    "sb_right_arrow:left_ptr"
    "sb_up_arrow:left_ptr"
    "sb_down_arrow:left_ptr"
    "top_left_corner:fleur"
    "top_right_corner:fleur"
    "bottom_left_corner:fleur"
    "bottom_right_corner:fleur"
    "dotbox:fleur"
    "dot_box_mask:fleur"
    "arrow:left_ptr"
    "size_all:fleur"
    "size_fdiag:bd_double_arrow"
    "size_hor:sb_h_double_arrow"
    "size_ver:sb_v_double_arrow"
    "size_bdiag:fd_double_arrow"
    "whats_this:help"
    "cell:crosshair"
    "split_v:sb_v_double_arrow"
    "split_h:sb_h_double_arrow"
)

for mapping in "${INHERIT_CURSORS[@]}"; do
    target="${mapping%%:*}"
    source="${mapping##*:}"
    if [ -f "$CURSOR_DIR/cursors/$source.conf" ]; then
        ln -sf "$source.conf" "$CURSOR_DIR/cursors/$target.conf" 2>/dev/null || true
    fi
done

echo "[+] Cursor definitions created"
echo ""
echo "To apply: gsettings set org.gnome.desktop.interface cursor-theme 'Vajra-Cursors'"
echo ""
echo "=== Vajra Cursor Theme Complete ==="