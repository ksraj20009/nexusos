#!/bin/bash
# Vajra OS — Sound Settings
set -e
echo "◆ Vajra OS — Sound Settings Setup"
SD_DIR="/opt/vajra/settings"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/settings-sound.sh" << 'SND'
#!/bin/bash
case "${1:-status}" in
    status)
        echo "  Vajra OS - Sound Settings"
        echo "  Output Devices:"
        pactl list sinks short 2>/dev/null | awk '{print "    "$2}' | head -5
        echo "  Input Devices:"
        pactl list sources short 2>/dev/null | awk '{print "    "$2}' | head -5
        echo "  Master Volume: $(amixer sget Master 2>/dev/null | grep -o '[0-9]*%' | head -1)"
        echo "  Muted: $(amixer sget Master 2>/dev/null | grep -o '\[on\]\|\[off\]' | head -1)"
        echo "  Default Sink: $(pactl get-default-sink 2>/dev/null || echo 'unknown')"
        ;;
    volume)
        LEVEL="${2:-50}"
        pactl set-sink-volume @DEFAULT_SINK@ "${LEVEL}%" 2>/dev/null || amixer sset Master "${LEVEL}%" 2>/dev/null
        echo "  ✓ Volume set to ${LEVEL}%"
        ;;
    mute) pactl set-sink-mute @DEFAULT_SINK@ toggle 2>/dev/null || amixer sset Master toggle 2>/dev/null; echo "  ✓ Mute toggled" ;;
    mute-on) pactl set-sink-mute @DEFAULT_SINK@ 1 2>/dev/null || amixer sset Master mute 2>/dev/null; echo "  ✓ Muted" ;;
    mute-off) pactl set-sink-mute @DEFAULT_SINK@ 0 2>/dev/null || amixer sset Master unmute 2>/dev/null; echo "  ✓ Unmuted" ;;
    input-volume)
        LEVEL="${2:-50}"
        pactl set-source-volume @DEFAULT_SOURCE@ "${LEVEL}%" 2>/dev/null || amixer sset Capture "${LEVEL}%" 2>/dev/null
        echo "  ✓ Input volume set to ${LEVEL}%"
        ;;
    input-mute) pactl set-source-mute @DEFAULT_SOURCE@ toggle 2>/dev/null || amixer sset Capture toggle 2>/dev/null; echo "  ✓ Input mute toggled" ;;
    output-device)
        SINK="$2"
        [ -z "$SINK" ] && echo "  Available sinks:" && pactl list sinks short 2>/dev/null && exit 0
        pactl set-default-sink "$SINK" 2>/dev/null; echo "  ✓ Default output set to $SINK"
        ;;
    input-device)
        SOURCE="$2"
        [ -z "$SOURCE" ] && echo "  Available sources:" && pactl list sources short 2>/dev/null && exit 0
        pactl set-default-source "$SOURCE" 2>/dev/null; echo "  ✓ Default input set to $SOURCE"
        ;;
    balance) BAL="${2:-0}"; pactl set-sink-volume @DEFAULT_SINK@ "balance $BAL" 2>/dev/null || true; echo "  ✓ Balance set to $BAL" ;;
    test) echo "  Playing test sound..."; speaker-test -t sine -f 440 -l 1 2>/dev/null || echo "  not available" ;;
    apps) echo "  Audio applications:"; pactl list sink-inputs 2>/dev/null | grep -E "application.name|Sink Input" | head -10 ;;
    *) echo "Usage: vajra-settings sound {status|volume <n>|mute|input-volume|output-device|input-device|balance|test|apps}" ;;
esac
SND
chmod +x "$SD_DIR/settings-sound.sh"
ln -sf "$SD_DIR/settings-sound.sh" /usr/local/bin/vajra-settings-sound 2>/dev/null || true
echo "  ✓ Sound settings installed"
echo "◆ Done"
