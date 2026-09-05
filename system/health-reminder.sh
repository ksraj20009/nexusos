#!/bin/bash
# Vajra OS — Health Reminder
# Yoga, break, water, and Ayurveda-based reminders
set -e

echo "◆ Vajra OS — Health Reminder Setup"

HL_DIR="/opt/vajra/health"
mkdir -p "$HL_DIR"

cat > "$HL_DIR/health-reminder.sh" << 'HL'
#!/bin/bash
WATER_INTERVAL=45
EYE_BREAK_INTERVAL=20
YOGA_TIMES="06:00 12:00 18:00"

notify() {
    if command -v notify-send &>/dev/null; then
        notify-send "◆ $1" "$2"
    fi
    echo "[$(date '+%H:%M')] $1: $2"
}

case "${1:-daemon}" in
    daemon)
        echo "◆ Vajra Health daemon started..."
        LAST_WATER=0; LAST_EYE=0
        while true; do
            NOW=$(date +%s); MIN=$(date +%M); HOUR=$(date +%H)
            ELAPSED=$(( (NOW - LAST_WATER) / 60 ))
            [ "$ELAPSED" -ge "$WATER_INTERVAL" ] && notify "Hydration" "Drink a glass of water" && LAST_WATER=$NOW
            ELAPSED_EYE=$(( (NOW - LAST_EYE) / 60 ))
            [ "$ELAPSED_EYE" -ge "$EYE_BREAK_INTERVAL" ] && notify "Eye Break" "Look 20 feet away for 20 seconds" && LAST_EYE=$NOW
            for YT in $YOGA_TIMES; do
                YH=$(echo "$YT" | cut -d: -f1); YM=$(echo "$YT" | cut -d: -f2)
                [ "$HOUR" = "$YH" ] && [ "$MIN" = "$YM" ] && notify "Yoga Time" "Time for a short yoga/stretch break!"
            done
            [ $((MIN % 30)) -eq 0 ] && [ "$MIN" != "00" ] && notify "Posture Check" "Sit straight, relax shoulders, take 3 deep breaths"
            sleep 60
        done
        ;;
    water) notify "Water" "Time to drink water!" ;;
    stretch) notify "Stretch" "Stand up! Neck rolls, shoulder shrugs, wrist circles, forward fold" ;;
    posture) notify "Posture" "Feet flat, back straight, screen at eye level" ;;
    eye) notify "Eye Care" "Look 20 feet away for 20 seconds. Blink slowly 10 times." ;;
    ayurveda) notify "Ayurveda" "Drink warm water with lemon in the morning for digestion" ;;
    tips) echo "◆ Ayurvedic Dinacharya:
  4:30 AM  Brahma Muhurta — Wake, meditate
  6:00 AM  Abhyanga — Oil massage + exercise
  8:00 AM  Breakfast (warm, nourishing)
  12:00 PM Lunch (largest meal)
  6:00 PM  Dinner (light, early)
  10:00 PM Sleep
◆ Yoga for Desk Workers:
  Neck rolls, shoulder shrugs, eye exercises, wrist circles, spinal twist" ;;
    schedule) echo "◆ Health Schedule: Water every ${WATER_INTERVAL}min, Eye break every ${EYE_BREAK_INTERVAL}min, Yoga at $YOGA_TIMES" ;;
    *) echo "Usage: vajra-health {daemon|tips|water|stretch|posture|eye|ayurveda|schedule}" ;;
esac
HL
chmod +x "$HL_DIR/health-reminder.sh"
ln -sf "$HL_DIR/health-reminder.sh" /usr/local/bin/vajra-health 2>/dev/null || true

cat > /etc/systemd/system/vajra-health.service << 'SVC'
[Unit]
Description=Vajra OS Health Reminder
After=graphical.target
[Service]
Type=simple
ExecStart=/opt/vajra/health/health-reminder.sh daemon
Restart=always
RestartSec=30
Environment=DISPLAY=:0
[Install]
WantedBy=graphical.target
SVC
systemctl enable vajra-health 2>/dev/null || true

echo "  ✓ Health reminder installed (daemon running)"
echo "  ◆ Usage: vajra-health {tips|water|stretch|posture|schedule}"
echo "◆ Done"
