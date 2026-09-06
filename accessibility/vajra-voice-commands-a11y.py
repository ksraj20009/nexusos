#!/usr/bin/env python3
"""Vajra OS Voice Commands for Accessibility - Hands-free control (local, free)."""
import subprocess

COMMANDS = {
    "open terminal": "gnome-terminal",
    "open files": "nautilus",
    "open browser": "firefox",
    "open settings": "gnome-control-center",
    "lock screen": "gnome-screensaver-command -l",
    "take screenshot": "gnome-screenshot -i",
    "increase volume": "pactl set-sink-volume @DEFAULT_SINK@ +10%",
    "decrease volume": "pactl set-sink-volume @DEFAULT_SINK@ -10%",
    "mute": "pactl set-sink-mute @DEFAULT_SINK@ toggle",
}

def main():
    print("=" * 50)
    print("  Vajra OS Voice Commands (Accessibility)")
    print("=" * 50)
    print("  Available commands:")
    for cmd in COMMANDS:
        print(f"    - {cmd}")
    print()
    while True:
        cmd = input("  Command (or 'exit'): ").strip().lower()
        if cmd == "exit": break
        if cmd in COMMANDS:
            subprocess.run(COMMANDS[cmd].split(), timeout=10)
            print(f"  [+] Executed: {cmd}")
        else:
            print(f"  [-] Unknown command. Available: {', '.join(list(COMMANDS.keys())[:5])}...")

if __name__ == "__main__":
    main()