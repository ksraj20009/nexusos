#!/usr/bin/env python3
"""Vajra OS Sanskrit Tutor - Learn basic Sanskrit (local, free)."""

SHLOKAS = [
    {"shloka": "Om Sahana Vavatu", "meaning": "May we be protected together", "context": "Peace invocation"},
    {"shloka": "Vasudhaiva Kutumbakam", "meaning": "The whole world is one family", "context": "Maha Upanishad"},
    {"shloka": "Satyameva Jayate", "meaning": "Truth alone triumphs", "context": "Mundaka Upanishad"},
    {"shloka": "Ahimsa Paramo Dharma", "meaning": "Non-violence is the highest duty", "context": "Mahabharata"},
    {"shloka": "Gamana Trayate Iti Gita", "meaning": "That which saves you from karma is Gita", "context": "Bhagavad Gita"},
]

ALPHABET = [
    ("a", "a"), ("aa", "aa"), ("i", "i"), ("ee", "ee"),
    ("u", "u"), ("oo", "oo"), ("e", "e"), ("ai", "ai"),
    ("o", "o"), ("au", "au"), ("am", "am"), ("aha", "aha"),
]

def main():
    print("=" * 55)
    print("  Vajra OS Sanskrit Tutor")
    print("=" * 55)
    print("\n  1. Basic vowels (Swaras)")
    print("  2. Famous shlokas with meanings")
    print("  3. Exit")
    c = input("  Choice: ").strip()
    if c == "1":
        print(f"\n  {'Sanskrit':10s} {'Transliteration':15s}")
        for s, t in ALPHABET:
            print(f"  {s:10s} {t:15s}")
    elif c == "2":
        for i, s in enumerate(SHLOKAS, 1):
            print(f"\n  Shloka {i}: {s['shloka']}")
            print(f"  Meaning: {s['meaning']}")
            print(f"  Context: {s['context']}")

if __name__ == "__main__":
    main()