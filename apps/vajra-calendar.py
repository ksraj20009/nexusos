#!/usr/bin/env python3
"""Vajra OS - Built-in Calendar with Indian festivals"""
import calendar, sys
from datetime import datetime

INDIAN_FESTIVALS = {
    "01-14": "Makar Sankranti / Pongal",
    "01-26": "Republic Day",
    "03-08": "Maha Shivaratri (approx)",
    "03-25": "Holi (approx)",
    "08-15": "Independence Day",
    "08-19": "Raksha Bandhan (approx)",
    "09-07": "Ganesh Chaturthi (approx)",
    "10-02": "Gandhi Jayanti",
    "10-12": "Dussehra (approx)",
    "11-01": "Diwali (approx)",
    "12-25": "Christmas Day",
}

def show_calendar(year=None, month=None):
    now = datetime.now()
    year = year or now.year
    if month:
        print(calendar.month(year, month))
        mm = f"{month:02d}"
        for dd, name in INDIAN_FESTIVALS.items():
            if dd.startswith(mm):
                print(f"  {dd[-2:]}: {name}")
    else:
        print(calendar.calendar(year))
        print("\nIndian Festivals (approximate):")
        for dd, name in sorted(INDIAN_FESTIVALS.items()):
            print(f"  {dd}: {name}")

if __name__ == "__main__":
    if len(sys.argv) == 1:
        show_calendar()
    elif len(sys.argv) == 2:
        show_calendar(year=int(sys.argv[1]))
    elif len(sys.argv) == 3:
        show_calendar(year=int(sys.argv[1]), month=int(sys.argv[2]))
