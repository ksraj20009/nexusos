#!/bin/bash
export DISPLAY=:0
if command -v notify-send &>/dev/null; then
    notify-send -u normal -t 0 "Welcome to NexusOS!" "Your private, AI-powered OS.\n\nCtrl+Space for AI\nSay 'Nexus' for voice\n'nexus-ai' in terminal for AI chat\nDouble-click Install NexusOS to install"
fi
echo "Welcome to NexusOS 1.0 Aurora"
