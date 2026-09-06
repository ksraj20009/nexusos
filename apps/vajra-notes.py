#!/usr/bin/env python3
"""Vajra OS Notes App - Simple note-taking with tags and search."""
import os, json, datetime
from pathlib import Path

NOTES_DIR = Path.home() / ".vajra" / "notes"
NOTES_FILE = NOTES_DIR / "notes.json"

def load_notes():
    if NOTES_FILE.exists():
        with open(NOTES_FILE) as f:
            return json.load(f)
    return []

def save_notes(notes):
    NOTES_DIR.mkdir(parents=True, exist_ok=True)
    with open(NOTES_FILE, "w") as f:
        json.dump(notes, f, indent=2)

def main():
    notes = load_notes()
    print("=" * 50)
    print("  Vajra OS Notes")
    print("=" * 50)
    while True:
        print(f"\n  Notes: {len(notes)}")
        print("  1. New note  2. List  3. Search  4. Delete  5. Export  6. Exit")
        c = input("  Choice: ").strip()
        if c == "1":
            title = input("  Title: ").strip()
            body = input("  Body: ").strip()
            tags = input("  Tags (comma-sep): ").strip().split(",")
            notes.append({"title": title, "body": body, "tags": [t.strip() for t in tags],
                          "date": datetime.datetime.now().isoformat()})
            save_notes(notes)
            print("  [+] Note saved")
        elif c == "2":
            for i, n in enumerate(notes):
                print(f"  {i+1}. {n['title']} [{','.join(n['tags'])}] ({n['date'][:10]})")
        elif c == "3":
            q = input("  Search: ").strip().lower()
            for n in notes:
                if q in n["title"].lower() or q in n["body"].lower() or q in n["tags"]:
                    print(f"  - {n['title']}: {n['body'][:60]}")
        elif c == "4":
            idx = int(input("  Note number: ")) - 1
            if 0 <= idx < len(notes):
                notes.pop(idx)
                save_notes(notes)
                print("  [+] Deleted")
        elif c == "5":
            print(f"  Exported to {NOTES_FILE}")
        elif c == "6":
            break

if __name__ == "__main__":
    main()