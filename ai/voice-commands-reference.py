#!/usr/bin/env python3
"""
Vajra OS Voice Commands Reference Guide
Shows all available voice commands for Buddhi AI.
"""

COMMANDS = {
    "Applications": [
        ("open terminal", "Opens the Vajra terminal"),
        ("open files", "Opens the file manager"),
        ("open browser", "Opens Firefox web browser"),
        ("open settings", "Opens Vajra settings"),
        ("open calculator", "Opens the calculator"),
        ("open music", "Opens the music player"),
        ("open text editor", "Opens the text editor"),
        ("open calendar", "Opens the calendar"),
        ("open ai", "Opens Buddhi AI chat"),
        ("close [app name]", "Closes the specified application"),
    ],
    "System Control": [
        ("set volume", "Adjusts system volume"),
        ("set brightness", "Adjusts screen brightness"),
        ("take screenshot", "Captures the screen"),
        ("lock screen", "Locks the screen"),
        ("shutdown", "Shuts down the computer"),
        ("restart", "Restarts the computer"),
    ],
    "Information": [
        ("what time", "Tells you the current time"),
        ("what date", "Tells you today's date"),
        ("check wifi", "Shows Wi-Fi connection status"),
        ("check battery", "Reports battery percentage"),
        ("check system", "Shows system information"),
    ],
    "Search": [
        ("search [query]", "Searches the web for your query"),
    ],
}

def main():
    print("=" * 60)
    print("  Vajra OS Voice Commands Reference")
    print("  Buddhi AI Voice Control")
    print("=" * 60)
    print()
    print("  Say 'Buddhi' followed by any command, or just say")
    print("  the command directly when voice control is active.")
    print()
    
    for category, cmds in COMMANDS.items():
        print(f"  --- {category} ---")
        for cmd, desc in cmds:
            print(f'    "{cmd}"')
            print(f"      -> {desc}")
        print()
    
    print("  Tips:")
    print("    - Speak clearly and naturally")
    print("    - Wait for the beep before speaking")
    print("    - Say 'stop' or 'quit' to exit voice mode")
    print("    - Voice data is processed locally (privacy-safe)")
    print()
    print("  To enable voice control:")
    print("    Settings > AI > Voice Control > Enable")
    print("    Or press Super+A and say 'enable voice'")

if __name__ == "__main__":
    main()