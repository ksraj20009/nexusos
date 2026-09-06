#!/bin/bash
# Vajra OS Enhanced Terminal Setup
set -e
echo "=== Vajra OS Enhanced Terminal ==="
echo "[*] Installing terminal tools..."
apt-get install -y tmux htop neofetch tree jq ripgrep fd-find bat 2>/dev/null || true
echo "[*] Installing zsh + oh-my-zsh..."
apt-get install -y zsh 2>/dev/null || true
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 2>/dev/null || true
echo "[*] Configuring zsh theme..."
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc 2>/dev/null || true
echo "[*] Adding Vajra aliases..."
cat >> ~/.zshrc << 'ALIASES'
# Vajra OS aliases
alias vj-update="sudo apt update && sudo apt upgrade -y"
alias vj-clean="sudo apt autoremove -y && sudo apt clean"
alias vj-firewall="sudo ufw status"
alias vj-ai="python3 /opt/vajra/ai/buddhi-ai.py"
alias vj-voice="python3 /opt/vajra/ai/voice-control-daemon.py"
alias vj-sec="bash /opt/vajra/security/security-suite.sh"
alias vj-news="python3 /opt/vajra/apps/vajra-news-aggregator.py"
alias vj-weather="python3 /opt/vajra/apps/vajra-weather.py"
alias vj-panchang="python3 /opt/vajra/locale/vajra-panchang.py"
alias vj-gst="python3 /opt/vajra/apps/vajra-gst-calculator.py"
alias vj-train="python3 /opt/vajra/apps/vajra-irctc-checker.py"
alias vj-yoga="python3 /opt/vajra/locale/vajra-yoga-timer.py"
alias vj-ayurveda="python3 /opt/vajra/locale/vajra-ayurveda-db.py"
ALIASES
echo "[+] Enhanced terminal configured"
echo "Note: Restart terminal or run 'zsh' to use"