#!/usr/bin/env python3
"""Vajra OS Wallpaper Changer - Auto-rotate wallpapers (local, free)."""
import subprocess, time, random
from pathlib import Path

WALLPAPER_DIR = Path.home() / "Pictures" / "Wallpapers"

def set_wallpaper(path):
    subprocess.run(["gsettings", "set", "org.gnome.desktop.background", "picture-uri", f"file://{path}"], timeout=5)

def main():
    print("=" * 50)
    print("  Vajra OS Wallpaper Changer")
    print("=" * 50)
    WALLPAPER_DIR.mkdir(parents=True, exist_ok=True)
    wallpapers = list(WALLPAPER_DIR.glob("*.jpg")) + list(WALLPAPER_DIR.glob("*.png"))
    if not wallpapers:
        print("  No wallpapers found in ~/Pictures/Wallpapers/")
        print("  Add .jpg or .png files there")
        return
    print(f"  Found {len(wallpapers)} wallpapers")
    interval = int(input("  Change interval (seconds) [300]: ") or "300")
    print(f"  Rotating every {interval}s. Ctrl+C to stop.")
    try:
        while True:
            wp = random.choice(wallpapers)
            set_wallpaper(str(wp))
            print(f"  [+] Set: {wp.name}")
            time.sleep(interval)
    except KeyboardInterrupt:
        print("\n  Stopped")

if __name__ == "__main__":
    main()