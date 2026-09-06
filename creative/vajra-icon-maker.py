#!/usr/bin/env python3
"""Vajra OS Icon Maker - Create app icons from text/emoji (local, free)."""
import subprocess, os

def main():
    print("=" * 50)
    print("  Vajra OS Icon Maker")
    print("=" * 50)
    text = input("  Icon text/emoji (1-2 chars): ").strip() or "V"
    size = int(input("  Size (px) [128]: ") or "128")
    color = input("  Background color (hex without #) [1a73e8]: ").strip() or "1a73e8"
    outfile = os.path.expanduser(f"~/Pictures/vajra-icon-{text}.png")
    try:
        subprocess.run([
            "convert", "-size", f"{size}x{size}",
            f"xc:#{color}", "-gravity", "center",
            "-font", "DejaVu-Sans-Bold", "-pointsize", str(size//3),
            "-fill", "white", "-annotate", "+0+0", text,
            outfile
        ], timeout=10)
        print(f"  [+] Icon saved: {outfile}")
    except FileNotFoundError:
        print("  [-] Install ImageMagick: sudo apt install imagemagick")

if __name__ == "__main__":
    main()