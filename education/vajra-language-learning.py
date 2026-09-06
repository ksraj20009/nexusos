#!/usr/bin/env python3
"""Vajra OS Language Learning - Learn basic Hindi/Sanskrit (local, free)."""

LESSONS = [
    {"lang": "Hindi", "word": "Namaste", "meaning": "Hello / Greetings", "pron": "nah-MAH-stay"},
    {"lang": "Hindi", "word": "Dhanyavaad", "meaning": "Thank you", "pron": "dhahn-yah-VAAD"},
    {"lang": "Hindi", "word": "Haan", "meaning": "Yes", "pron": "haan"},
    {"lang": "Hindi", "word": "Nahi", "meaning": "No", "pron": "nah-hee"},
    {"lang": "Hindi", "word": "Paani", "meaning": "Water", "pron": "pah-nee"},
    {"lang": "Hindi", "word": "Khaana", "meaning": "Food", "pron": "kah-nah"},
    {"lang": "Sanskrit", "word": "Namaskaram", "meaning": "Greetings", "pron": "nah-mas-kah-rum"},
    {"lang": "Sanskrit", "word": "Dhanyosmi", "meaning": "I am grateful", "pron": "dhahn-yoh-smee"},
    {"lang": "Sanskrit", "word": "Aham", "meaning": "I am", "pron": "ah-hum"},
    {"lang": "Sanskrit", "word": "Shanti", "meaning": "Peace", "pron": "shan-tee"},
]

def main():
    print("=" * 50)
    print("  Vajra OS Language Learning")
    print("=" * 50)
    print(f"\n  {'Word':15s} {'Meaning':20s} {'Pronunciation':20s}")
    print("  " + "-" * 55)
    for l in LESSONS:
        print(f"  {l['word']:15s} {l['meaning']:20s} {l['pron']:20s}  [{l['lang']}]")
    print(f"\n  Total: {len(LESSONS)} words")

if __name__ == "__main__":
    main()