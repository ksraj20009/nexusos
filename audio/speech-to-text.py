#!/usr/bin/env python3
"""Vajra OS Speech-to-Text - Convert spoken audio to text (free, local whisper)."""
import subprocess, os, tempfile

def main():
    print("=" * 50)
    print("  Vajra OS Speech-to-Text")
    print("=" * 50)
    print("  1. Record and transcribe")
    print("  2. Transcribe audio file")
    print("  3. Exit")
    choice = input("  Choice: ").strip()
    if choice == "1":
        outfile = os.path.join(tempfile.gettempdir(), "vajra_stt.wav")
        print("  Recording 10 seconds... Speak now!")
        try:
            subprocess.run(["arecord", "-d", "10", "-f", "cd", outfile], timeout=15)
            print("  Transcribing...")
            subprocess.run(["whisper", outfile, "--model", "tiny", "--language", "en"], timeout=60)
        except FileNotFoundError:
            print("  [-] Install: sudo apt install alsa-utils")
            print("  [-] For transcription: pip install openai-whisper")
    elif choice == "2":
        filepath = input("  Audio file path: ").strip()
        if os.path.exists(filepath):
            try:
                subprocess.run(["whisper", filepath, "--model", "tiny"], timeout=120)
            except FileNotFoundError:
                print("  [-] Install: pip install openai-whisper")
        else:
            print("  [-] File not found")

if __name__ == "__main__":
    main()