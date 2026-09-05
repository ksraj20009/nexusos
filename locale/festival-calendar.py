#!/usr/bin/env python3
"""
Vajra OS — Indian Festival Calendar
Shows major Indian festivals and their dates for 2025-2026.
"""

import sys
from datetime import date, datetime

FESTIVALS = [
    ("2025-01-14", "Makar Sankranti", "Harvest festival, sun enters Capricorn"),
    ("2025-01-26", "Republic Day", "Constitution of India adopted"),
    ("2025-02-26", "Maha Shivaratri", "Great night of Shiva"),
    ("2025-03-14", "Holi", "Festival of colors"),
    ("2025-03-30", "Ram Navami", "Birth of Lord Rama"),
    ("2025-04-10", "Mahavir Jayanti", "Birth of Mahavira"),
    ("2025-04-14", "Vaisakhi / Baisakhi", "Punjabi New Year"),
    ("2025-05-23", "Buddha Purnima", "Birth of Buddha"),
    ("2025-06-21", "International Yoga Day", "World Yoga Day"),
    ("2025-08-15", "Independence Day", "India's independence"),
    ("2025-08-16", "Janmashtami", "Birth of Lord Krishna"),
    ("2025-08-27", "Ganesh Chaturthi", "Birth of Lord Ganesha"),
    ("2025-10-02", "Gandhi Jayanti", "Birth of Mahatma Gandhi"),
    ("2025-10-20", "Dussehra / Vijayadashami", "Victory of good over evil"),
    ("2025-11-01", "Diwali", "Festival of lights"),
    ("2025-11-05", "Bhai Dooj", "Brother-sister bond"),
    ("2025-11-15", "Guru Nanak Jayanti", "Birth of Guru Nanak"),
    ("2025-12-25", "Christmas", "Birth of Jesus Christ"),
    ("2026-01-14", "Makar Sankranti", "Harvest festival"),
    ("2026-01-26", "Republic Day", "Constitution adopted"),
    ("2026-02-15", "Maha Shivaratri", "Great night of Shiva"),
    ("2026-03-04", "Holi", "Festival of colors"),
    ("2026-03-20", "Ram Navami", "Birth of Lord Rama"),
    ("2026-04-03", "Mahavir Jayanti", "Birth of Mahavira"),
    ("2026-04-14", "Vaisakhi", "Punjabi New Year"),
    ("2026-05-12", "Buddha Purnima", "Birth of Buddha"),
    ("2026-06-21", "International Yoga Day", "World Yoga Day"),
    ("2026-08-15", "Independence Day", "India's independence"),
    ("2026-09-05", "Janmashtami", "Birth of Lord Krishna"),
    ("2026-10-02", "Gandhi Jayanti", "Birth of Gandhi"),
    ("2026-10-11", "Dussehra", "Victory of good over evil"),
    ("2026-10-21", "Diwali", "Festival of lights"),
    ("2026-12-25", "Christmas", "Birth of Jesus"),
]

def show_upcoming(days=30):
    today = date.today()
    print("  ============================================")
    print("  Vajra OS - Festival Calendar")
    print("  ============================================")
    print(f"  Today: {today.strftime('%A, %B %d, %Y')}")
    print("")
    print("  Upcoming Festivals:")
    found = False
    for fdate, name, desc in FESTIVALS:
        fd = datetime.strptime(fdate, "%Y-%m-%d").date()
        delta = (fd - today).days
        if 0 <= delta <= days:
            day_str = fd.strftime("%b %d, %Y")
            weekday = fd.strftime("%A")
            print(f"    {name}")
            print(f"      {day_str} ({weekday})")
            print(f"      {desc}")
            print("")
            found = True
    if not found:
        print(f"  No festivals in the next {days} days.")

def show_all():
    print("All Indian Festivals (2025-2026):")
    current_year = None
    for fdate, name, desc in FESTIVALS:
        fd = datetime.strptime(fdate, "%Y-%m-%d").date()
        if fd.year != current_year:
            current_year = fd.year
            print(f"\n  --- {current_year} ---")
        print(f"  {fd.strftime('%b %d')}  {name}")
        print(f"          {desc}")

def search(query):
    query = query.lower()
    print(f"Festivals matching '{query}':")
    for fdate, name, desc in FESTIVALS:
        if query in name.lower() or query in desc.lower():
            fd = datetime.strptime(fdate, "%Y-%m-%d").date()
            print(f"  {fd.strftime('%b %d, %Y')}  {name}")
            print(f"          {desc}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        cmd = sys.argv[1]
        if cmd == "upcoming":
            days = int(sys.argv[2]) if len(sys.argv) > 2 else 30
            show_upcoming(days)
        elif cmd == "all":
            show_all()
        elif cmd == "search":
            if len(sys.argv) > 2:
                search(sys.argv[2])
            else:
                print("Usage: vajra-festival search <query>")
        else:
            print("Usage: vajra-festival {upcoming [days]|all|search <query>}")
    else:
        show_upcoming(60)
