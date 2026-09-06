#!/usr/bin/env python3
"""Vajra OS Typing Tutor - Learn touch typing (local, free)."""
import time

LESSONS = [
    {"name": "Home Row", "text": "asdf asdf jkl; jkl; asdf jkl; sad fad lass fall"},
    {"name": "Top Row", "text": "qwerty queue were year tear rate true tree"},
    {"name": "Bottom Row", "text": "zxcvbn zebra xenon cover bird next zone"},
    {"name": "Common Words", "text": "the quick brown fox jumps over the lazy dog"},
    {"name": "Speed Test", "text": "India is a diverse country with many languages and cultures"},
]

def main():
    print("=" * 50)
    print("  Vajra OS Typing Tutor")
    print("=" * 50)
    for i, l in enumerate(LESSONS, 1):
        print(f"  {i}. {l['name']}")
    choice = input("  Lesson [1]: ").strip() or "1"
    try: idx = int(choice) - 1
    except: idx = 0
    if 0 <= idx < len(LESSONS):
        lesson = LESSONS[idx]
        print(f"\n  --- {lesson['name']} ---")
        print(f"  Type: {lesson['text']}")
        input("  Press Enter when ready...")
        start = time.time()
        typed = input("  > ").strip()
        elapsed = time.time() - start
        correct = sum(1 for a, b in zip(typed, lesson['text']) if a == b)
        accuracy = correct * 100 // len(lesson['text']) if lesson['text'] else 0
        wpm = len(typed.split()) * 60 // int(elapsed) if elapsed > 0 else 0
        print(f"\n  Time: {elapsed:.1f}s")
        print(f"  Accuracy: {accuracy}%")
        print(f"  WPM: {wpm}")

if __name__ == "__main__":
    main()