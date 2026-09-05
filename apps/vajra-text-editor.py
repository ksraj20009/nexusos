#!/usr/bin/env python3
"""Vajra OS - Built-in Text Editor"""
import sys, os

def main():
    if len(sys.argv) < 2:
        print("Vajra Text Editor")
        print("Usage: vajra-text <filename>")
        print("Commands: :w (save), :q (quit), :wq (save+quit), :n (new)")
        return
    filename = sys.argv[1]
    lines = []
    if os.path.exists(filename):
        with open(filename, 'r') as f:
            lines = f.read().split('\n')
        print(f"  Loaded: {filename} ({len(lines)} lines)")
    else:
        print(f"  New file: {filename}")
    print("  ':wq' to save+quit, ':q' to quit, ':w' to save, ':n' for new")
    print("-" * 40)
    while True:
        try:
            line = input()
            if line == ":wq":
                with open(filename, 'w') as f:
                    f.write('\n'.join(lines))
                print(f"  Saved {filename} ({len(lines)} lines)")
                return
            elif line == ":q":
                print("  Quit without saving.")
                return
            elif line == ":w":
                with open(filename, 'w') as f:
                    f.write('\n'.join(lines))
                print(f"  Saved {filename}")
            elif line == ":n":
                lines = []
                print("  New buffer")
            else:
                lines.append(line)
        except EOFError:
            return

if __name__ == "__main__":
    main()
