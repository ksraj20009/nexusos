#!/usr/bin/env python3
"""Vajra OS Choghadiya - Auspicious and inauspicious time periods (local, free)."""

PERIODS = [
    {"time": "06:00-07:30", "name": "Udveg", "type": "Inauspicious", "desc": "Avoid important work"},
    {"time": "07:30-09:00", "name": "Char", "type": "Auspicious", "desc": "Good for travel"},
    {"time": "09:00-10:30", "name": "Labh", "type": "Auspicious", "desc": "Good for business"},
    {"time": "10:30-12:00", "name": "Amrit", "type": "Very Auspicious", "desc": "Best for any work"},
    {"time": "12:00-13:30", "name": "Kaal", "type": "Inauspicious", "desc": "Avoid new ventures"},
    {"time": "13:30-15:00", "name": "Shubh", "type": "Auspicious", "desc": "Good for ceremonies"},
    {"time": "15:00-16:30", "name": "Rog", "type": "Inauspicious", "desc": "Avoid health-related"},
    {"time": "16:30-18:00", "name": "Udveg", "type": "Inauspicious", "desc": "Avoid important work"},
]

def _is_now(time_range):
    import datetime
    now = datetime.datetime.now().strftime("%H:%M")
    start, end = time_range.split("-")
    return start <= now < end

def main():
    print("=" * 55)
    print("  Vajra OS Choghadiya (Auspicious Times)")
    print("=" * 55)
    print(f"\n  {'Time':15s} {'Period':10s} {'Type':20s} {'Description'}")
    print("  " + "-" * 55)
    for p in PERIODS:
        marker = " <-- NOW" if _is_now(p["time"]) else ""
        print(f"  {p['time']:15s} {p['name']:10s} {p['type']:20s} {p['desc']}{marker}")

if __name__ == "__main__":
    main()