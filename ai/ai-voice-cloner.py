#!/usr/bin/env python3
"""Vajra OS AI Voice Cloner - Record and replay voice patterns (local, free)."""
import subprocess, os, tempfile

def main():
    print("=" * 50)
    print("  Vajra OS AI Voice Cloner (Buddhi)")
    print("=" * 50)
    print("  1. Record voice sample")
    print("  2. Play recorded sample")
    print("  3. Modify pitch (fun)")
    print("  4. Exit")
    c = input("  Choice: ").strip()
    outfile = os.path.join(tempfile.gettempdir(), "vajra_voice_sample.wav")
    if c == "1":
        print("  Recording 10 seconds... Speak now!")
        try:
            subprocess.run(["arecord", "-d", "10", "-f", "cd", outfile], timeout=15)
            print(f"  [+] Voice saved: {outfile}")
        except FileNotFoundError:
            print("  [-] Install: sudo apt install alsa-utils")
    elif c == "2":
        try:
            subprocess.run(["aplay", outfile], timeout=15)
        except: print("  [-] No recording found")
    elif c == "3":
        try:
            subprocess.run(["sox", outfile, outfile + "_pitched.wav", "pitch", "200"], timeout=10)
            subprocess.run(["aplay", outfile + "_pitched.wav"], timeout=15)
            print("  [+] Pitched voice played")
        except FileNotFoundError:
            print("  [-] Install: sudo apt install sox")

if __name__ == "__main__":
    main()