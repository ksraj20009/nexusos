#!/bin/bash
# Vajra OS — Time & Language Settings
set -e
echo "◆ Vajra OS — Time & Language Settings Setup"
SD_DIR="/opt/vajra/settings"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/settings-time-language.sh" << 'TL'
#!/bin/bash
case "${1:-status}" in
    status)
        echo "  Vajra OS - Time & Language"
        echo "  Date: $(date '+%A, %B %d, %Y')"
        echo "  Time: $(date '+%I:%M %p')"
        echo "  Timezone: $(timedatectl show --property=Timezone --value 2>/dev/null || cat /etc/timezone 2>/dev/null)"
        echo "  NTP: $(timedatectl show --property=NTP --value 2>/dev/null || echo 'unknown')"
        echo "  Locale: $(locale | head -1)"
        echo "  Language: $(echo $LANG)"
        echo "  Keyboard: $(localectl status 2>/dev/null | grep Layout | awk '{print $3}')"
        ;;
    timezone) sudo timedatectl set-timezone "${2:-Asia/Kolkata}" 2>/dev/null; echo "  ✓ Timezone set to ${2:-Asia/Kolkata}" ;;
    ntp) case "${2:-on}" in on) sudo timedatectl set-ntp true 2>/dev/null; echo "  ✓ NTP enabled" ;; off) sudo timedatectl set-ntp false 2>/dev/null; echo "  ✓ NTP disabled" ;; esac ;;
    set-time)
        TIME="$2"; [ -z "$TIME" ] && echo "  Usage: vajra-settings time set-time 'YYYY-MM-DD HH:MM:SS'" && exit 1
        sudo timedatectl set-ntp false 2>/dev/null; sudo timedatectl set-time "$TIME" 2>/dev/null; echo "  ✓ Time set to $TIME"
        ;;
    locale) sudo locale-gen "${2:-en_IN}" 2>/dev/null; sudo update-locale LANG="${2:-en_IN}" 2>/dev/null; echo "  ✓ Locale set to ${2:-en_IN}" ;;
    language) sudo update-locale LANG="${2:-en_IN}" LANGUAGE="${2:-en_IN}" 2>/dev/null; echo "  ✓ Language set to ${2:-en_IN}. Log out and back in." ;;
    keyboard) localectl set-keymap "${2:-us}" 2>/dev/null; echo "  ✓ Keyboard layout set to ${2:-us}" ;;
    keyboards) echo "  Available keyboard layouts:"; localectl list-keymaps 2>/dev/null | head -30 ;;
    24h) gsettings set org.gnome.desktop.interface clock-format '24h' 2>/dev/null; echo "  ✓ 24-hour format enabled" ;;
    12h) gsettings set org.gnome.desktop.interface clock-format '12h' 2>/dev/null; echo "  ✓ 12-hour format enabled" ;;
    indic) sudo apt-get install -y ibus-m17n 2>/dev/null || true; echo "  ✓ Indic keyboards available (Hindi, Tamil, Bengali, etc.)" ;;
    *) echo "Usage: vajra-settings time {status|timezone|ntp|set-time|locale|language|keyboard|keyboards|24h|12h|indic}" ;;
esac
TL
chmod +x "$SD_DIR/settings-time-language.sh"
ln -sf "$SD_DIR/settings-time-language.sh" /usr/local/bin/vajra-settings-time 2>/dev/null || true
echo "  ✓ Time & language settings installed"
echo "◆ Done"
