#!/bin/bash
# Vajra OS Display Server Manager — X11/Wayland, display manager, resolution.
# Like Windows Display Settings / Linux xrandr+wayland+gdm.
# This is the fundamental display/graphics layer of the OS.
set -e

show_display_menu() {
    echo "============================================"
    echo "    VAJRA OS DISPLAY SERVER MANAGER"
    echo "    X11 | Wayland | Resolution | Multi-Monitor"
    echo "============================================"
    echo "  1. Display server status"
    echo "  2. List displays & resolutions"
    echo "  3. Set resolution"
    echo "  4. Set refresh rate"
    echo "  5. Enable/disable display"
    echo "  6. Set primary display"
    echo "  7. Mirror displays"
    echo "  8. Extend displays"
    echo "  9. Display manager (GDM/LightDM/SDDM)"
    echo "  10. Switch X11/Wayland"
    echo "  11. Screen brightness"
    echo "  12. Night light (blue light filter)"
    echo "  13. Screen orientation"
    echo "  14. DPI/scale settings"
    echo "  0. Exit"
    echo "============================================"
}

display_status() {
    echo ""
    echo "--- Display Server Status ---"

    # Check if Wayland or X11
    if [ -n "$WAYLAND_DISPLAY" ]; then
        echo "  Display Server: Wayland"
        echo "  Wayland display: $WAYLAND_DISPLAY"
    elif [ -n "$DISPLAY" ]; then
        echo "  Display Server: X11"
        echo "  X display: $DISPLAY"
    else
        echo "  Display Server: None (TTY/headless)"
    fi

    # Display manager
    local dm=""
    for d in gdm lightdm sddm lxdm; do
        if systemctl is-active "$d" 2>/dev/null | grep -q active; then
            dm="$d"
            break
        fi
    done
    echo "  Display Manager: ${dm:-none}"

    # Current resolution
    if command -v xrandr &>/dev/null; then
        local connected=$(xrandr 2>/dev/null | grep " connected" | awk '{print $1}')
        echo "  Connected displays: ${connected:-none}"
        for disp in $connected; do
            local res=$(xrandr 2>/dev/null | grep -A1 "^$disp" | tail -1 | awk '{print $1}')
            echo "    $disp: $res"
        done
    fi

    # Compositor
    if pgrep -x "mutter" >/dev/null 2>&1; then
        echo "  Compositor: Mutter (GNOME)"
    elif pgrep -x "kwin" >/dev/null 2>&1; then
        echo "  Compositor: KWin (KDE)"
    elif pgrep -x "weston" >/dev/null 2>&1; then
        echo "  Compositor: Weston"
    elif pgrep -x "sway" >/dev/null 2>&1; then
        echo "  Compositor: Sway"
    fi
    echo ""
}

list_displays() {
    echo ""
    echo "--- Connected Displays ---"
    if command -v xrandr &>/dev/null; then
        xrandr 2>/dev/null | head -30
    else
        echo "  xrandr not available (may be running Wayland)"
        if [ -d /sys/class/drm ]; then
            echo "  DRM cards:"
            for card in /sys/class/drm/card*-*; do
                [ -f "$card/status" ] && echo "    $(basename $card): $(cat $card/status)"
            done
        fi
    fi
}

set_resolution() {
    echo ""
    if ! command -v xrandr &>/dev/null; then
        echo "  [-] xrandr not available"
        return
    fi
    echo "Connected displays:"
    xrandr 2>/dev/null | grep " connected" | awk '{print NR". "$1}'
    read -p "  Display number: " num
    local disp=$(xrandr 2>/dev/null | grep " connected" | awk -v n="$num" 'NR==n{print $1}')
    [ -z "$disp" ] && { echo "  [-] Invalid display"; return; }
    echo "Available resolutions for $disp:"
    xrandr 2>/dev/null | grep -A50 "^$disp" | grep -E "^\s+[0-9]" | awk '{print NR". "$1}'
    read -p "  Resolution number: " rnum
    local res=$(xrandr 2>/dev/null | grep -A50 "^$disp" | grep -E "^\s+[0-9]" | awk -v n="$rnum" 'NR==n{print $1}')
    [ -z "$res" ] && { echo "  [-] Invalid resolution"; return; }
    xrandr --output "$disp" --mode "$res"
    echo "  [+] Set $disp to $res"
}

set_refresh_rate() {
    echo ""
    if ! command -v xrandr &>/dev/null; then echo "  [-] xrandr not available"; return; fi
    read -p "  Display (e.g. HDMI-1): " disp
    read -p "  Resolution (e.g. 1920x1080): " res
    echo "Available refresh rates:"
    xrandr 2>/dev/null | grep "$res" | head -1
    read -p "  Refresh rate (Hz): " rate
    xrandr --output "$disp" --mode "$res" --rate "$rate"
    echo "  [+] Set $disp to $res @ ${rate}Hz"
}

enable_display() {
    read -p "  Display to enable: " disp
    xrandr --output "$disp" --auto 2>/dev/null
    echo "  [+] Enabled $disp"
}

disable_display() {
    read -p "  Display to disable: " disp
    xrandr --output "$disp" --off 2>/dev/null
    echo "  [+] Disabled $disp"
}

set_primary() {
    read -p "  Primary display: " disp
    xrandr --output "$disp" --primary 2>/dev/null
    echo "  [+] Set $disp as primary"
}

mirror_displays() {
    echo ""
    if ! command -v xrandr &>/dev/null; then echo "  [-] xrandr not available"; return; fi
    echo "Connected displays:"
    xrandr 2>/dev/null | grep " connected" | awk '{print NR". "$1}'
    read -p "  First display: " d1
    read -p "  Second display: " d2
    local disp1=$(xrandr 2>/dev/null | grep " connected" | awk -v n="$d1" 'NR==n{print $1}')
    local disp2=$(xrandr 2>/dev/null | grep " connected" | awk -v n="$d2" 'NR==n{print $1}')
    xrandr --output "$disp2" --same-as "$disp1" 2>/dev/null
    echo "  [+] Mirrored $disp1 and $disp2"
}

extend_displays() {
    echo ""
    if ! command -v xrandr &>/dev/null; then echo "  [-] xrandr not available"; return; fi
    echo "Connected displays:"
    xrandr 2>/dev/null | grep " connected" | awk '{print NR". "$1}'
    read -p "  Primary display: " d1
    read -p "  Extended display: " d2
    read -p "  Position (right/left/above/below): " pos
    local disp1=$(xrandr 2>/dev/null | grep " connected" | awk -v n="$d1" 'NR==n{print $1}')
    local disp2=$(xrandr 2>/dev/null | grep " connected" | awk -v n="$d2" 'NR==n{print $1}')
    xrandr --output "$disp2" "--$pos" "$disp1" --auto 2>/dev/null
    echo "  [+] Extended $disp2 $pos of $disp1"
}

manage_display_manager() {
    echo ""
    echo "--- Display Manager ---"
    echo "  1. GDM (GNOME)  2. LightDM  3. SDDM (KDE)  4. Disable"
    read -p "  Choice: " c
    case "$c" in
        1) sudo systemctl enable gdm 2>/dev/null; sudo systemctl restart gdm 2>/dev/null; echo "  [+] GDM enabled" ;;
        2) sudo systemctl enable lightdm 2>/dev/null; sudo systemctl restart lightdm 2>/dev/null; echo "  [+] LightDM enabled" ;;
        3) sudo systemctl enable sddm 2>/dev/null; sudo systemctl restart sddm 2>/dev/null; echo "  [+] SDDM enabled" ;;
        4) echo "  Display manager keeps running. Use 'sudo systemctl disable gdm' to disable." ;;
    esac
}

switch_x11_wayland() {
    echo ""
    echo "--- Switch X11 / Wayland ---"
    echo "  Current: $(if [ -n "$WAYLAND_DISPLAY" ]; then echo 'Wayland'; else echo 'X11'; fi)"
    echo "  1. Use Wayland (default, modern)"
    echo "  2. Use X11 (legacy, more compatible)"
    read -p "  Choice: " c
    if [ "$c" = "1" ]; then
        if [ -f /etc/gdm3/custom.conf ]; then
            sudo sed -i 's/WaylandEnable=false/#WaylandEnable=false/' /etc/gdm3/custom.conf
        fi
        echo "  [+] Wayland enabled (restart display manager to apply)"
    elif [ "$c" = "2" ]; then
        if [ -f /etc/gdm3/custom.conf ]; then
            sudo sed -i 's/#WaylandEnable=false/WaylandEnable=false/' /etc/gdm3/custom.conf
        fi
        echo "  [+] X11 enabled (restart display manager to apply)"
    fi
}

set_brightness() {
    echo ""
    echo "--- Screen Brightness ---"
    if [ -d /sys/class/backlight ]; then
        for bl in /sys/class/backlight/*/; do
            local max=$(cat "${bl}max_brightness" 2>/dev/null)
            local cur=$(cat "${bl}brightness" 2>/dev/null)
            local pct=$((cur * 100 / max))
            echo "  $(basename $bl): ${pct}% (${cur}/${max})"
            read -p "  Set brightness (0-$max): " new
            if [ -n "$new" ]; then
                echo "$new" | sudo tee "${bl}brightness" >/dev/null
                echo "  [+] Brightness set to $((new * 100 / max))%"
            fi
        done
    elif command -v brightnessctl &>/dev/null; then
        brightnessctl info
        read -p "  Set brightness (0-100%): " pct
        [ -n "$pct" ] && brightnessctl set "$pct%" && echo "  [+] Brightness set to ${pct}%"
    else
        echo "  No brightness control available"
    fi
}

night_light() {
    echo ""
    echo "--- Night Light (Blue Light Filter) ---"
    if command -v redshift &>/dev/null; then
        echo "  1. Enable (3500K warm)"
        echo "  2. Enable (2500K very warm)"
        echo "  3. Disable"
        read -p "  Choice: " c
        case "$c" in
            1) redshift -O 3500 &>/dev/null & echo "  [+] Night light on (3500K)" ;;
            2) redshift -O 2500 &>/dev/null & echo "  [+] Night light on (2500K)" ;;
            3) killall redshift 2>/dev/null; echo "  [+] Night light off" ;;
        esac
    else
        echo "  redshift not installed. Install with: sudo apt install redshift"
    fi
}

set_orientation() {
    echo ""
    if ! command -v xrandr &>/dev/null; then echo "  [-] xrandr not available"; return; fi
    read -p "  Display: " disp
    echo "  1. Normal  2. Left  3. Right  4. Inverted"
    read -p "  Orientation: " o
    case "$o" in
        1) xrandr --output "$disp" --rotate normal ;;
        2) xrandr --output "$disp" --rotate left ;;
        3) xrandr --output "$disp" --rotate right ;;
        4) xrandr --output "$disp" --rotate inverted ;;
    esac
    echo "  [+] Orientation set"
}

set_dpi_scale() {
    echo ""
    echo "--- DPI / Scale Settings ---"
    echo "  1. 100% (96 DPI)"
    echo "  2. 125% (120 DPI)"
    echo "  3. 150% (144 DPI)"
    echo "  4. 200% (192 DPI, HiDPI)"
    read -p "  Scale: " s
    case "$s" in
        1) xrandr --dpi 96 2>/dev/null; gsettings set org.gnome.desktop.interface scaling-factor 1 2>/dev/null; echo "  [+] 100% scale" ;;
        2) xrandr --dpi 120 2>/dev/null; gsettings set org.gnome.desktop.interface scaling-factor 1 2>/dev/null; echo "  [+] 125% scale" ;;
        3) xrandr --dpi 144 2>/dev/null; gsettings set org.gnome.desktop.interface scaling-factor 2 2>/dev/null; echo "  [+] 150% scale" ;;
        4) xrandr --dpi 192 2>/dev/null; gsettings set org.gnome.desktop.interface scaling-factor 2 2>/dev/null; echo "  [+] 200% scale (HiDPI)" ;;
    esac
}

main() {
    while true; do
        show_display_menu
        read -p "  Choice: " choice
        case "$choice" in
            1) display_status ;;
            2) list_displays ;;
            3) set_resolution ;;
            4) set_refresh_rate ;;
            5) read -p "  Enable(1) or Disable(2): " e; if [ "$e" = "1" ]; then enable_display; else disable_display; fi ;;
            6) set_primary ;;
            7) mirror_displays ;;
            8) extend_displays ;;
            9) manage_display_manager ;;
            10) switch_x11_wayland ;;
            11) set_brightness ;;
            12) night_light ;;
            13) set_orientation ;;
            14) set_dpi_scale ;;
            0) break ;;
            *) echo "  Invalid choice" ;;
        esac
    done
}

main
