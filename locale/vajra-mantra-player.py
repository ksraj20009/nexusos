#!/usr/bin/env python3
"""Vajra OS Mantra Player - Play sacred mantras with descriptions (local, free)."""
import time

MANTRAS = [
    {"name": "Gayatri Mantra", "text": "Om Bhur Bhuva Svaha, Tat Savitur Varenyam, Bhargo Devasya Dhimahi, Dhiyo Yo Nah Prachodayat", "reps": 108, "purpose": "Universal enlightenment"},
    {"name": "Mahamrityunjaya", "text": "Om Tryambakam Yajamahe, Sugandhim Pushtivardhanam, Urvarukamiva Bandhanan, Mrityor Mukshiya Mamritat", "reps": 11, "purpose": "Healing and protection"},
    {"name": "Om Namah Shivaya", "text": "Om Namah Shivaya", "reps": 108, "purpose": "Shiva worship, inner peace"},
    {"name": "Hare Krishna", "text": "Hare Krishna Hare Krishna, Krishna Krishna Hare Hare, Hare Rama Hare Rama, Rama Rama Hare Hare", "reps": 16, "purpose": "Bhakti yoga, spiritual joy"},
    {"name": "Sri Suktam", "text": "Om Sri Hrim Shriyai Namah", "reps": 11, "purpose": "Abundance and prosperity"},
    {"name": "Durga Mantra", "text": "Om Dum Durgayei Namaha", "reps": 108, "purpose": "Protection, strength"},
]

def main():
    print("=" * 55)
    print("  Vajra OS Mantra Player")
    print("=" * 55)
    for i, m in enumerate(MANTRAS, 1):
        print(f"  {i}. {m['name']} ({m['reps']} reps - {m['purpose']})")
    choice = input("\n  Select mantra: ").strip()
    try: idx = int(choice) - 1
    except: return
    if 0 <= idx < len(MANTRAS):
        m = MANTRAS[idx]
        print(f"\n  --- {m['name']} ---")
        print(f"  Text: {m['text']}")
        print(f"  Repetitions: {m['reps']}")
        print(f"  Purpose: {m['purpose']}")
        print(f"\n  Chanting {m['reps']} times...")
        for i in range(m['reps']):
            print(f"\r  [{i+1}/{m['reps']}] {m['text'][:30]}...", end="", flush=True)
            time.sleep(2)
        print(f"\n\n  [+] Mantra chanting complete. Shanti Shanti Shanti.")

if __name__ == "__main__":
    main()