#!/usr/bin/env python3
"""Vajra OS Stopwatch & Timer (local, free)."""
import time
def main():
    print("=" * 50)
    print("  Vajra OS Stopwatch")
    print("=" * 50)
    print("  1. Stopwatch")
    print("  2. Countdown timer")
    print("  3. Exit")
    c = input("  Choice: ").strip()
    if c == "1":
        print("  Press Enter to start, Ctrl+C to stop...")
        input()
        start = time.time()
        try:
            while True:
                elapsed = time.time() - start
                print(f"\r  {int(elapsed//60):02d}:{int(elapsed%60):02d}.{int((elapsed*100)%100):02d}", end="", flush=True)
                time.sleep(0.01)
        except KeyboardInterrupt:
            elapsed = time.time() - start
            print(f"\n  Final: {int(elapsed//60):02d}:{int(elapsed%60):02d}")
    elif c == "2":
        secs = int(input("  Seconds: ") or "60")
        while secs > 0:
            print(f"\r  {int(secs//60):02d}:{int(secs%60):02d}", end="", flush=True)
            time.sleep(1)
            secs -= 1
        print("\n  [+] Time's up!")

if __name__ == "__main__":
    main()