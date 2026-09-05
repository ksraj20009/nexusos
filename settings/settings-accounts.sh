#!/bin/bash
# Vajra OS — Accounts Settings
set -e
echo "◆ Vajra OS — Accounts Settings Setup"
SD_DIR="/opt/vajra/settings"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/settings-accounts.sh" << 'ACC'
#!/bin/bash
case "${1:-status}" in
    status)
        echo "  Vajra OS - Accounts Settings"
        echo "  Current User: $(whoami)"
        echo "  UID: $(id -u)  Groups: $(id -nG)"
        echo "  Home: $HOME  Shell: $SHELL"
        echo "  All Users:"
        awk -F: '$3 >= 1000 && $3 < 65534 {print "    "$1" (UID: "$3")"}' /etc/passwd
        echo "  Auto-login: $(grep -i autologin /etc/gdm3/custom.conf 2>/dev/null | head -1 || echo 'disabled')"
        ;;
    add) USERNAME="$2"; [ -z "$USERNAME" ] && echo "  Usage: vajra-settings accounts add <username>" && exit 1; sudo useradd -m -s /bin/bash "$USERNAME"; echo "  ✓ User $USERNAME created. Set password: sudo passwd $USERNAME" ;;
    remove) USERNAME="$2"; [ -z "$USERNAME" ] && exit 1; sudo userdel -r "$USERNAME" 2>/dev/null; echo "  ✓ User $USERNAME removed" ;;
    password) passwd ;;
    add-admin) sudo usermod -aG sudo "$2"; echo "  ✓ $2 is now an administrator" ;;
    remove-admin) sudo deluser "$2" sudo; echo "  ✓ $2 is no longer an administrator" ;;
    auto-login)
        USERNAME="${2:-vajra}"
        sudo sed -i 's/.*AutomaticLoginEnable=.*/AutomaticLoginEnable=true/' /etc/gdm3/custom.conf 2>/dev/null
        sudo sed -i "s/.*AutomaticLogin=.*/AutomaticLogin=$USERNAME/" /etc/gdm3/custom.conf 2>/dev/null
        echo "  ✓ Auto-login enabled for $USERNAME"
        ;;
    auto-login-off) sudo sed -i 's/.*AutomaticLoginEnable=.*/AutomaticLoginEnable=false/' /etc/gdm3/custom.conf 2>/dev/null; echo "  ✓ Auto-login disabled" ;;
    guest)
        if ! id "guest" &>/dev/null; then sudo useradd -m -s /bin/bash guest; sudo passwd -d guest; echo "  ✓ Guest account created"
        else echo "  Guest account already exists"; fi
        ;;
    guest-off) sudo userdel -r guest 2>/dev/null; echo "  ✓ Guest account removed" ;;
    shell) sudo chsh -s "${3:-/bin/bash}" "$2"; echo "  ✓ Shell for $2 set to ${3:-/bin/bash}" ;;
    *) echo "Usage: vajra-settings accounts {status|add|remove|password|add-admin|remove-admin|auto-login|guest|shell}" ;;
esac
ACC
chmod +x "$SD_DIR/settings-accounts.sh"
ln -sf "$SD_DIR/settings-accounts.sh" /usr/local/bin/vajra-settings-accounts 2>/dev/null || true
echo "  ✓ Accounts settings installed"
echo "◆ Done"
