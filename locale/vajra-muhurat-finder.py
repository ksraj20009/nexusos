#!/usr/bin/env python3
"""Vajra OS Muhurat Finder - Find auspicious times for activities (local, free)."""
import datetime

ACTIVITIES = [
    ("Marriage/Wedding", "Check Panchang for Shubh Lagna, avoid Rahu Kaal"),
    ("Starting business", "Wednesday or Thursday, Labh or Amrit Choghadiya"),
    ("House warming (Griha Pravesh)", "Thursday or Friday, Shubh Muhurat"),
    ("Buying vehicle", "Wednesday, Friday, or Saturday (Shukra/Shani)"),
    ("Joining new job", "Monday, Wednesday, or Thursday"),
    ("Travel", "Start in Char or Labh period, avoid Rahu Kaal"),
    ("Naming ceremony (Namkaran)", "12th day after birth, Shubh Muhurat"),
    ("Education/Vidya Arambha", "Saraswati Puja day, Vasant Panchami"),
]

RAHU_KAAL = [
    ("Monday", "07:30-09:00"),
    ("Tuesday", "15:00-16:30"),
    ("Wednesday", "12:00-13:30"),
    ("Thursday", "13:30-15:00"),
    ("Friday", "10:30-12:00"),
    ("Saturday", "09:00-10:30"),
    ("Sunday", "16:30-18:00"),
]

def main():
    print("=" * 55)
    print("  Vajra OS Muhurat Finder")
    print("=" * 55)
    print("\n  Select activity:")
    for i, (act, _) in enumerate(ACTIVITIES, 1):
        print(f"  {i}. {act}")
    choice = input("\n  Activity: ").strip()
    try: idx = int(choice) - 1
    except: return
    if 0 <= idx < len(ACTIVITIES):
        act, advice = ACTIVITIES[idx]
        print(f"\n  --- {act} ---")
        print(f"  Guidance: {advice}")
        today = datetime.date.today().strftime("%A")
        for day, rk in RAHU_KAAL:
            marker = " (TODAY)" if day == today else ""
            print(f"  {day}{marker}: Rahu Kaal {rk}")

if __name__ == "__main__":
    main()