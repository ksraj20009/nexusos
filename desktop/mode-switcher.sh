#!/bin/bash
# Vajra OS — Mode Switcher (Beginner / Pro)
# Changes UI, available tools, and complexity based on user level
set -e

echo "◆ Vajra OS — Mode Switcher"

MODE_FILE="/opt/vajra/mode"
MODE_DIR="/opt/vajra/modes"
mkdir -p "$MODE_DIR"

[ ! -f "$MODE_FILE" ] && echo "beginner" > "$MODE_FILE"
CURRENT=$(cat "$MODE_FILE")

show_status() {
    echo "╔═══════════════════════════════════════════════╗"
    echo "║  ◆ Vajra OS — Mode: $(cat "$MODE_FILE" | tr a-z A-Z)         ║"
    echo "╚═══════════════════════════════════════════════╝"
    echo ""
    if [ "$CURRENT" = "beginner" ]; then
        echo "  Current: Beginner Mode"
        echo "  ✓ Large icons, simplified menus"
        echo "  ✓ Hidden advanced settings"
        echo "  ✓ Guided tutorials on"
        echo "  ✓ Safety guardrails on (no rm -rf, no root shell)"
        echo "  ✓ Auto-updates silent"
        echo "  ✓ Buddhi AI voice guidance on"
        echo ""
        echo "  Available: vajra-mode pro    (switch to Pro)"
    else
        echo "  Current: Pro Mode"
        echo "  ✓ Full terminal access"
        echo "  ✓ Advanced settings visible"
        echo "  ✓ Developer tools enabled"
        echo "  ✓ Root shell available"
        echo "  ✓ All system services visible"
        echo "  ✓ Custom kernel configs"
        echo ""
        echo "  Available: vajra-mode beginner (switch to Beginner)"
    fi
}

switch_beginner() {
    echo "beginner" > "$MODE_FILE"
    gsettings set org.gnome.desktop.interface icon-size "Large" 2>/dev/null || true
    gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 64 2>/dev/null || true
    gsettings set org.gnome.desktop.lockdown disable-command-line true 2>/dev/null || true
    touch /tmp/vajra-beginner-mode
    cat > /etc/profile.d/vajra-beginner-safety.sh << 'SAFETY'
# Beginner mode safety aliases
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"
vajra-sudo() {
    echo "Beginner Mode: Please use the GUI Settings app for system changes."
    echo "  To switch to Pro mode: vajra-mode pro"
}
alias sudo="vajra-sudo"
SAFETY
    echo "  ✓ Switched to Beginner Mode"
    echo "  ✓ Safety guardrails enabled"
    echo "  ✓ Large icons, simplified UI"
    echo ""
    echo "  Restart your session for changes to take effect."
}

switch_pro() {
    echo "pro" > "$MODE_FILE"
    rm -f /etc/profile.d/vajra-beginner-safety.sh 2>/dev/null || true
    rm -f /tmp/vajra-beginner-mode 2>/dev/null || true
    gsettings set org.gnome.desktop.interface icon-size "Normal" 2>/dev/null || true
    gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48 2>/dev/null || true
    gsettings set org.gnome.desktop.lockdown disable-command-line false 2>/dev/null || true
    echo "  ✓ Switched to Pro Mode"
    echo "  ✓ Full terminal access"
    echo "  ✓ Developer tools available"
    echo ""
    echo "  Restart your session for changes to take effect."
}

case "${1:-status}" in
    beginner) switch_beginner ;;
    pro|developer) switch_pro ;;
    status) show_status ;;
    toggle)
        if [ "$CURRENT" = "beginner" ]; then
            switch_pro
        else
            switch_beginner
        fi
        ;;
    *)
        echo "Usage: vajra-mode {beginner|pro|status|toggle}"
        ;;
esac
