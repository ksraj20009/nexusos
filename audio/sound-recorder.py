#!/usr/bin/env python3
"""Vajra OS Sound Recorder - Record audio from microphone (local, free, arecord)."""
import subprocess, sys, os, datetime
def main():
    print("=" * 50)
    print("  Vajra OS Sound Recorder")
    print("=" * 50)
    outdir = os.path.expanduser("~/Music/Recordings")
    os.makedirs(outdir, exist_ok=True)
    ts = datetime.datetime.now().strftime("%Y%m%d-%H%M%S")
    outfile = os.path.join(outdir, f"vajra-recording-{ts}.wav")
    duration = input("  Duration in seconds [10]: ").strip() or "10"
    try:
        d = int(duration)
    except ValueError:
        d = 10
    print(f"  Recording {d} seconds to {outfile}...")
    print("  Speak now!")
    try:
        subprocess.run([
            "arecord", "-d", str(d), "-f", "cd", "-t", "wav", outfile
        ], timeout=d+5)
        print(f"  [+] Recording saved: {outfile}")
    except FileNotFoundError:
        print("  [-] arecord not found. Install: sudo apt install alsa-utils")
    except subprocess.TimeoutExpired:
        print("  [-] Recording timed out")

if __name__ == "__main__":
    main()