#!/usr/bin/env python3
"""Vajra OS Text-to-Speech - Convert text to spoken audio (local, free, espeak)."""
import subprocess, os, tempfile
def main():
    print("=" * 50)
    print("  Vajra OS Text-to-Speech")
    print("=" * 50)
    text = input("  Enter text to speak: ").strip()
    if not text:
        print("  No text entered")
        return
    speed = input("  Speed (slow/normal/fast) [normal]: ").strip() or "normal"
    speed_map = {"slow": 80, "normal": 150, "fast": 250}
    wpm = speed_map.get(speed, 150)
    outfile = os.path.join(tempfile.gettempdir(), "vajra_tts.wav")
    try:
        subprocess.run([
            "espeak", text, "-s", str(wpm), "-w", outfile
        ], timeout=10)
        print(f"  [+] Audio saved to {outfile}")
        subprocess.run(["aplay", outfile], timeout=30)
    except FileNotFoundError:
        print("  [-] espeak not found. Install: sudo apt install espeak")
    except subprocess.TimeoutExpired:
        print("  [-] Timed out")

if __name__ == "__main__":
    main()