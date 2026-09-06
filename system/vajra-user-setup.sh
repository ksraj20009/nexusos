#!/bin/bash
# =============================================================
# Vajra OS User Setup Script
# Creates the default 'vajra' user and configures home directory
# =============================================================

set -e

echo "=== Vajra OS User Setup ==="

# --- Create default user ---
VAJRA_USER="${1:-vajra}"
VAJRA_FULLNAME="${2:-Vajra User}"
VAJRA_PASSWORD="${3:-vajra}"

echo "[*] Creating user: $VAJRA_USER"

# Check if user already exists
if id "$VAJRA_USER" &>/dev/null; then
    echo "[!] User '$VAJRA_USER' already exists. Skipping creation."
else
    # Create user with home directory
    useradd -m -c "$VAJRA_FULLNAME" -s /bin/bash "$VAJRA_USER"
    echo "[+] User '$VAJRA_USER' created"
    
    # Set password
    echo "$VAJRA_USER:$VAJRA_PASSWORD" | chpasswd
    echo "[+] Password set"
fi

# --- Add to appropriate groups ---
VAJRA_GROUPS="sudo,audio,video,cdrom,dip,plugdev,netdev,bluetooth,scanner,docker"

if [ "$VAJRA_USER" != "root" ]; then
    usermod -aG "$VAJRA_GROUPS" "$VAJRA_USER" 2>/dev/null || true
    echo "[+] Added to groups: $VAJRA_GROUPS"
fi

# --- Create home directory structure ---
HOME_DIR="/home/$VAJRA_USER"
echo "[*] Setting up home directory: $HOME_DIR"

DIRECTORIES=(
    "Desktop"
    "Documents"
    "Downloads"
    "Music"
    "Pictures"
    "Pictures/Wallpapers"
    "Pictures/Screenshots"
    "Videos"
    ".config"
    ".config/vajra"
    ".config/autostart"
    ".local/share"
    ".local/share/applications"
    ".local/share/vajra"
    ".local/share/vajra/ai"
    ".local/share/vajra/backups"
    ".local/share/vajra/logs"
    ".local/share/vajra/cache"
    ".cache"
    "Templates"
    "Public"
)

for dir in "${DIRECTORIES[@]}"; do
    mkdir -p "$HOME_DIR/$dir"
done

echo "[+] Home directory structure created"

# --- Copy default configuration files ---

# .bashrc with Vajra customizations
cat > "$HOME_DIR/.bashrc" << 'BASHRC'
# Vajra OS .bashrc
# Vajra (वज्र) — Thunderbolt Strong. Unbreakable.

# --- Vajra prompt ---
PS1='\[\033[38;5;220m\]vajra\[\033[0m\]@\h:\[\033[38;5;33m\]\w\[\033[0m\]\$ '

# --- Aliases ---
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias update='sudo apt update && sudo apt upgrade -y'
alias install='sudo apt install -y'
alias remove='sudo apt remove -y'
alias search='apt search'
alias clean='sudo apt autoremove -y && sudo apt clean'

# --- Vajra aliases ---
alias vajra-help='cat /etc/vajra/help.txt 2>/dev/null || echo "Vajra Help: Run vajra-welcome"'
alias vajra-mode='cat /etc/vajra/mode 2>/dev/null || echo "Mode not set"'
alias buddhi='python3 /opt/vajra/ai/buddhi-ai.py'
alias vajra-security='bash /opt/vajra/security/security-suite.sh'
alias vajra-update='bash /opt/vajra/system/update-manager.sh'
alias vajra-backup='bash /opt/vajra/system/backup-manager.sh'

# --- History settings ---
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth:erasedups

# --- Color support ---
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# --- Welcome message ---
if [ -f /etc/vajra/welcome.txt ]; then
    cat /etc/vajra/welcome.txt
fi

# --- Buddhi AI greeting ---
if [ -f /etc/vajra/ai-enabled ] && [ "$(cat /etc/vajra/ai-enabled 2>/dev/null)" = "true" ]; then
    echo ""
    echo "Buddhi AI is active. Type 'buddhi' to interact."
fi
BASHRC

echo "[+] .bashrc configured"

# .profile
cat > "$HOME_DIR/.profile" << 'PROFILE'
# Vajra OS Profile
# Add local bin to PATH
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Vajra paths
if [ -d "/opt/vajra/bin" ]; then
    PATH="/opt/vajra/bin:$PATH"
fi

export PATH
PROFILE

echo "[+] .profile configured"

# --- Create desktop shortcuts ---
cat > "$HOME_DIR/Desktop/vajra-help.desktop" << DESKTOP
[Desktop Entry]
Name=Vajra Help
Comment=Get help with Vajra OS
Exec=bash /opt/vajra/scripts/welcome.sh
Icon=help-browser
Terminal=true
Type=Application
Categories=System;
DESKTOP

cat > "$HOME_DIR/Desktop/vajra-terminal.desktop" << DESKTOP2
[Desktop Entry]
Name=Vajra Terminal
Comment=Vajra OS Terminal
Exec=gnome-terminal --name=VajraTerminal
Icon=utilities-terminal
Terminal=false
Type=Application
Categories=System;TerminalEmulator;
DESKTOP2

echo "[+] Desktop shortcuts created"

# --- Set ownership ---
chown -R "$VAJRA_USER":"$VAJRA_USER" "$HOME_DIR"
chmod 700 "$HOME_DIR"
echo "[+] Ownership set to $VAJRA_USER"

# --- Create Vajra config directory ---
mkdir -p /etc/vajra
cat > /etc/vajra/version << 'VER'
Vajra OS 1.0 (वज्र)
Thunderbolt Strong. Unbreakable.
Codename: Vajra
Build: 1.0.0
VER

echo "[+] System version file created"

# --- Create welcome message ---
cat > /etc/vajra/welcome.txt << 'WELCOME'

  Vajra OS (वज्र) — Thunderbolt Strong. Unbreakable.

  Type 'vajra-help' for quick commands.
  Type 'buddhi' to talk to your AI assistant.

WELCOME

echo "[+] Welcome file created"

# --- Set up Vajra mode ---
echo "beginner" > /etc/vajra/mode
echo "[+] Default mode: beginner"

# --- Set hostname ---
echo "vajra" > /etc/hostname
echo "127.0.1.1 vajra" >> /etc/hosts
echo "[+] Hostname set to: vajra"

echo ""
echo "=== User Setup Complete ==="
echo "User: $VAJRA_USER"
echo "Home: $HOME_DIR"
echo "Groups: $VAJRA_GROUPS"
echo ""
echo "Next steps:"
echo "  1. Set password: sudo passwd $VAJRA_USER"
echo "  2. Install display manager: sudo apt install lightdm"
echo "  3. Enable display manager: sudo systemctl enable lightdm"
echo "  4. Reboot: sudo reboot"