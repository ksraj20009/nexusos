#!/bin/bash
# NexusOS Welcome Screen
export DISPLAY=:0
if command -v notify-send &>/dev/null; then
    notify-send -u normal -t 0 "◆ Welcome to NexusOS!" "Your private, AI-powered OS.

Ctrl+Space for AI
Say 'Nexus' for voice
'nexus-ai' in terminal
Click Install NexusOS to install

No tracking. No cloud. All local."
fi
echo ""
echo "  ◆ NexusOS 1.0 Aurora"
echo "  Your OS. Your Rules. Your Privacy."
echo ""
echo "  Ctrl+Space — AI command bar"
echo "  nexus-ai    — AI in terminal"
echo "  Say 'Nexus' — Voice commands"
echo ""
