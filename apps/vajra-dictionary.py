#!/usr/bin/env python3
"""Vajra OS Dictionary - English word lookup (free API, local client)."""
import urllib.request, json

def lookup(word):
    try:
        url = f"https://api.dictionaryapi.dev/api/v2/entries/en/{word}"
        req = urllib.request.Request(url, headers={"User-Agent": "VajraOS/1.0"})
        with urllib.request.urlopen(req, timeout=10) as r:
            data = json.loads(r.read())
        if data:
            entry = data[0]
            meanings = entry.get("meanings", [])
            result = []
            for m in meanings[:2]:
                pos = m.get("partOfSpeech", "")
                defs = m.get("definitions", [])
                for d in defs[:2]:
                    result.append(f"  ({pos}) {d.get('definition', '')}")
            return result
    except Exception:
        return None

def main():
    print("=" * 50)
    print("  Vajra OS Dictionary")
    print("=" * 50)
    while True:
        word = input("\n  Word (or 'exit'): ").strip()
        if word == "exit": break
        defs = lookup(word)
        if defs:
            print(f"\n  {word}:")
            for d in defs:
                print(d)
        else:
            print(f"  No definition found for '{word}'")

if __name__ == "__main__":
    main()