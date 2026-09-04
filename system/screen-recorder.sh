#!/bin/bash
# Vajra OS — Screen Recorder
# Record screen with audio using ffmpeg
set -e

echo "◆ Vajra OS — Screen Recorder Setup"

SR_DIR="/opt/vajra/screenrecorder"
mkdir -p "$SR_DIR"

cat > "$SR_DIR/screen-recorder.sh" << 'SR'
#!/bin/bash

REC_DIR="$HOME/Videos/Vajra-Recordings"
mkdir -p "$REC_DIR"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
OUTPUT="$REC_DIR/vajra-$TIMESTAMP.mp4"
RES=$(xrandr 2>/dev/null | grep '*' | awk '{print $1}' | head -1)
[ -z "$RES" ] && RES="1920x1080"

case "${1:-start}" in
    start)
        echo "◆ Starting screen recording..."
        if ! command -v ffmpeg &>/dev/null; then
            sudo apt-get install -y ffmpeg 2>/dev/null || true
        fi
        ffmpeg -y \
            -f x11grab -framerate 30 -video_size "$RES" -i ":0.0" \
            -f pulse -i default \
            -c:v libx264 -preset fast -crf 23 \
            -c:a aac -b:a 128k \
            "$OUTPUT" &
        REC_PID=$!
        echo "$REC_PID" > /tmp/vajra-rec-pid
        echo "  ✓ Recording started (PID: $REC_PID)"
        echo "  Stop with: vajra-record stop"
        ;;
    stop)
        if [ -f /tmp/vajra-rec-pid ]; then
            PID=$(cat /tmp/vajra-rec-pid)
            kill -INT "$PID" 2>/dev/null
            rm -f /tmp/vajra-rec-pid
            echo "  ✓ Recording stopped"
            echo "  Saved to: $OUTPUT"
        else
            echo "  ⚠ No recording in progress"
        fi
        ;;
    region)
        echo "◆ Region recording — select area..."
        if command -v slop &>/dev/null; then
            eval "$(slop -f "W=%w H=%h X=%x Y=%y")"
            ffmpeg -y -f x11grab -framerate 30 -video_size "${W}x${H}" -i ":0.0+${X},${Y}" \
                -c:v libx264 -preset fast -crf 23 "$OUTPUT"
            echo "  ✓ Saved to: $OUTPUT"
        else
            echo "  ⚠ Install slop: sudo apt install slop"
        fi
        ;;
    gif)
        echo "◆ Recording GIF..."
        ffmpeg -y -f x11grab -framerate 15 -video_size "$RES" -i ":0.0" \
            -t 10 -vf "fps=10,scale=800:-1" \
            -loop 0 "$REC_DIR/vajra-$TIMESTAMP.gif"
        echo "  ✓ GIF saved to: $REC_DIR/vajra-$TIMESTAMP.gif"
        ;;
    list)
        echo "◆ Recent recordings:"
        ls -lht "$REC_DIR" | head -10
        ;;
    *)
        echo "Usage: vajra-record {start|stop|region|gif|list}"
        ;;
esac
SR
chmod +x "$SR_DIR/screen-recorder.sh"
ln -sf "$SR_DIR/screen-recorder.sh" /usr/local/bin/vajra-record 2>/dev/null || true

echo "  ✓ Screen recorder installed"
echo "  ◆ Usage: vajra-record {start|stop|region|gif|list}"
echo "◆ Done"
