#!/usr/bin/env python3
"""Vajra OS - Built-in Notes App"""
import sys, os, json
from datetime import datetime

NOTES_FILE = os.path.expanduser("~/.vajra-notes.json")

def load_notes():
    if os.path.exists(NOTES_FILE):
        with open(NOTES_FILE, 'r') as f:
            return json.load(f)
    return []

def save_notes(notes):
    with open(NOTES_FILE, 'w') as f:
        json.dump(notes, f, indent=2)

def main():
    notes = load_notes()
    cmd = sys.argv[1] if len(sys.argv) > 1 else "list"
    if cmd == "add":
        text = " ".join(sys.argv[2:])
        notes.append({"date": datetime.now().strftime("%Y-%m-%d %H:%M"), "text": text})
        save_notes(notes)
        print(f"  Note added: {text}")
    elif cmd == "list":
        if not notes:
            print("  No notes yet. Use: vajra-notes add <text>")
        for i, n in enumerate(notes, 1):
            print(f"  [{i}] {n['date']}: {n['text']}")
    elif cmd == "remove":
        idx = int(sys.argv[2]) - 1
        if 0 <= idx < len(notes):
            removed = notes.pop(idx)
            save_notes(notes)
            print(f"  Removed: {removed['text']}")
    elif cmd == "clear":
        save_notes([])
        print("  All notes cleared.")
    else:
        print("  Vajra Notes - Commands: add <text>, list, remove <n>, clear")

if __name__ == "__main__":
    main()
