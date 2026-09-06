#!/usr/bin/env python3
"""Vajra OS Calendar with Indian holidays and festivals."""
import datetime, calendar

INDIAN_HOLIDAYS = {
    1: {1: "New Year", 14: "Makar Sankranti", 26: "Republic Day"},
    2: {12: "Vasant Panchami"},
    3: {7: "Maha Shivaratri", 14: "Holi"},
    4: {8: "Rama Navami", 14: "Vaisakhi", 21: "Good Friday"},
    5: {1: "Labour Day", 23: "Buddha Purnima"},
    6: {},
    7: {},
    8: {15: "Independence Day", 29: "Janmashtami"},
    9: {5: "Ganesh Chaturthi", 6: "Onam"},
    10: {2: "Gandhi Jayanti", 11: "Dussehra", 21: "Diwali"},
    11: {7: "Bhai Dooj", 12: "Guru Nanak Jayanti"},
    12: {25: "Christmas"},
}

def show_calendar(year, month):
    cal = calendar.TextCalendar(calendar.SUNDAY)
    cal_str = cal.formatmonth(year, month)
    print(f"\n{cal_str}")
    holidays = INDIAN_HOLIDAYS.get(month, {})
    if holidays:
        print("  Holidays this month:")
        for day, name in sorted(holidays.items()):
            print(f"    {day:2d}: {name}")

def main():
    today = datetime.date.today()
    print("=" * 50)
    print(f"  Vajra OS Calendar - {today.strftime('%B %Y')}")
    print(f"  Today: {today.strftime('%A, %d %B %Y')}")
    print("=" * 50)
    show_calendar(today.year, today.month)
    while True:
        c = input("\n  N=Next month  P=Prev  Q=Quit: ").strip().lower()
        if c == "n":
            month = today.month + 1
            year = today.year
            if month > 12: month = 1; year += 1
            show_calendar(year, month)
        elif c == "p":
            month = today.month - 1
            year = today.year
            if month < 1: month = 12; year -= 1
            show_calendar(year, month)
        elif c == "q":
            break

if __name__ == "__main__":
    main()