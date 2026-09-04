#!/bin/bash
# Vajra OS Welcome Screen
export DISPLAY=:0
if command -v notify-send &>/dev/null; then
    notify-send -u normal -t 0 "◆ वज्र OS — Welcome to Vajra OS!" "Your private, AI-powered operating system.

🤖 Buddhi AI: Type 'buddhi' in terminal or Ctrl+Space
🎤 Voice: Say 'Buddhi' then your command
🛡 Privacy: Tor active, no tracking, all local
🔒 Security: AppArmor, firewall, hardened kernel

Type 'help' in Buddhi for full command list.

धर्मो रक्षति रक्षितः — Dharma protects those who protect it."
fi
echo ""
echo "  ╔══════════════════════════════════════╗"
echo "  ║  ◆ वज्र OS — Vajra OS 1.0            ║"
echo "  ║  Your OS. Your Rules. Your Privacy.  ║"
echo "  ╚══════════════════════════════════════╝"
echo ""
echo "  🤖 buddhi    — AI assistant in terminal"
echo "  🎤 Voice     — Say 'Buddhi' then command"
echo "  🛡 Tor       — All traffic anonymized"
echo "  📥 Install   — Click 'Install Vajra OS'"
echo ""
echo "  धर्मो रक्षति रक्षितः"
echo ""
