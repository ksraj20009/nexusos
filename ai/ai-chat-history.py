#!/usr/bin/env python3
"""Vajra OS AI Chat History - Store and search Buddhi conversations (local, free)."""
import json, os
from pathlib import Path

HISTORY_FILE = Path.home() / ".vajra" / "ai-chat-history.json"

def load():
    if HISTORY_FILE.exists():
        with open(HISTORY_FILE) as f: return json.load(f)
    return []

def save(data):
    HISTORY_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(HISTORY_FILE, "w") as f: json.dump(data, f, indent=2)

def main():
    print("=" * 50)
    print("  Vajra OS AI Chat History")
    print("=" * 50)
    history = load()
    print(f"  Total conversations: {len(history)}")
    print("  1. View recent  2. Search  3. Export  4. Clear  5. Exit")
    c = input("  Choice: ").strip()
    if c == "1":
        for h in history[-10:]:
            print(f"  {h['time']} | {h['user'][:40]} -> {h['ai'][:40]}")
    elif c == "2":
        q = input("  Search: ").strip().lower()
        for h in history:
            if q in h.get("user", "").lower() or q in h.get("ai", "").lower():
                print(f"  {h['time']} | {h['user'][:50]} -> {h['ai'][:50]}")
    elif c == "3":
        print(f"  Exported to {HISTORY_FILE}")
    elif c == "4":
        save([])
        print("  [+] History cleared")

if __name__ == "__main__":
    main()