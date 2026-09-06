#!/usr/bin/env python3
"""Vajra OS Screenshot Annotator - Add arrows/text to screenshots (free, GIMP)."""
import subprocess, os

def main():
    print("=" * 50)
    print("  Vajra OS Screenshot Annotator")
    print("=" * 50)
    print("  1. Take screenshot and annotate")
    print("  2. Annotate existing image")
    print("  3. Install GIMP for annotation (free)")
    print("  4. Exit")
    c = input("  Choice: ").strip()
    if c == "1":
        outfile = os.path.expanduser("~/Pictures/Screenshots/vajra-annotate.png")
        os.makedirs(os.path.dirname(outfile), exist_ok=True)
        subprocess.run(["gnome-screenshot", "-a", "-f", outfile], timeout=30)
        subprocess.run(["gimp", outfile], timeout=5)
        print(f"  [+] Screenshot taken, opened in GIMP for annotation")
    elif c == "2":
        path = input("  Image path: ").strip()
        if os.path.exists(path):
            subprocess.run(["gimp", path])
        else:
            print("  [-] File not found")
    elif c == "3":
        subprocess.run(["apt-get", "install", "-y", "gimp"])
        print("  [+] GIMP installed")

if __name__ == "__main__":
    main()