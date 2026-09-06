#!/usr/bin/env python3
"""Vajra OS Download Manager - with app info, pros/cons, permissions display (local, free)."""
import os

APPS_DB = [
    {"name": "Firefox", "url": "https://mozilla.org/firefox", "size": "55MB", "perms": "network, storage", "pros": "Privacy-focused, fast, free", "cons": "Uses RAM"},
    {"name": "VLC", "url": "https://vlc.org", "size": "40MB", "perms": "audio, video, storage", "pros": "Plays everything, free", "cons": "Cluttered UI"},
    {"name": "GIMP", "url": "https://gimp.org", "size": "200MB", "perms": "storage, display", "pros": "Powerful image editor, free", "cons": "Steep learning curve"},
    {"name": "VS Code", "url": "https://code.visualstudio.com", "size": "80MB", "perms": "filesystem, network", "pros": "Great for coding, free", "cons": "Microsoft telemetry"},
    {"name": "Telegram", "url": "https://telegram.org", "size": "35MB", "perms": "network, contacts, storage", "pros": "Fast messaging, free", "cons": "Not E2E by default"},
]

def main():
    print("=" * 50)
    print("  Vajra OS Download Manager")
    print("=" * 50)
    print("\n  Available apps:")
    for i, app in enumerate(APPS_DB, 1):
        print(f"  {i}. {app['name']} ({app['size']})")
    choice = input("\n  Select app to download: ").strip()
    try: idx = int(choice) - 1
    except: return
    if 0 <= idx < len(APPS_DB):
        app = APPS_DB[idx]
        print(f"\n  === App Info ===")
        print(f"  Name: {app['name']}")
        print(f"  Size: {app['size']}")
        print(f"  Permissions: {app['perms']}")
        print(f"  Pros: {app['pros']}")
        print(f"  Cons: {app['cons']}")
        print(f"  URL: {app['url']}")
        confirm = input(f"\n  Download {app['name']}? (yes/no): ").strip()
        if confirm == "yes":
            os.system(f"xdg-open {app['url']} 2>/dev/null")
            print(f"  [+] Opening download page for {app['name']}")

if __name__ == "__main__":
    main()