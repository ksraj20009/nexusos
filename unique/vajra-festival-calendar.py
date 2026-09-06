#!/usr/bin/env python3
"""Vajra OS Festival Calendar - All Indian festivals with dates and descriptions."""
import datetime

FESTIVALS = [
    {"date": "01-14", "name": "Makar Sankranti", "desc": "Harvest festival, kite flying", "region": "All India"},
    {"date": "01-26", "name": "Republic Day", "desc": "Constitution came into effect (1950)", "region": "All India"},
    {"date": "02-12", "name": "Vasant Panchami", "desc": "Goddess Saraswati worship", "region": "North India"},
    {"date": "03-07", "name": "Maha Shivaratri", "desc": "Lord Shiva worship", "region": "All India"},
    {"date": "03-14", "name": "Holi", "desc": "Festival of colors", "region": "All India"},
    {"date": "03-25", "name": "Chaitra Navratri", "desc": "Nine nights of Goddess Durga", "region": "North India"},
    {"date": "04-08", "name": "Rama Navami", "desc": "Birth of Lord Rama", "region": "All India"},
    {"date": "04-14", "name": "Vaisakhi/Baisakhi", "desc": "Punjabi New Year, harvest", "region": "Punjab"},
    {"date": "04-14", "name": "Puthandu/Tamil New Year", "desc": "Tamil New Year", "region": "Tamil Nadu"},
    {"date": "05-23", "name": "Buddha Purnima", "desc": "Birth of Buddha", "region": "All India"},
    {"date": "08-15", "name": "Independence Day", "desc": "Independence from UK (1947)", "region": "All India"},
    {"date": "08-29", "name": "Janmashtami", "desc": "Birth of Lord Krishna", "region": "All India"},
    {"date": "09-05", "name": "Ganesh Chaturthi", "desc": "Birth of Lord Ganesha", "region": "Maharashtra"},
    {"date": "09-06", "name": "Onam", "desc": "Harvest festival of Kerala", "region": "Kerala"},
    {"date": "10-02", "name": "Gandhi Jayanti", "desc": "Birth of Mahatma Gandhi", "region": "All India"},
    {"date": "10-11", "name": "Dussehra (Vijayadashami)", "desc": "Victory of good over evil", "region": "All India"},
    {"date": "10-21", "name": "Diwali", "desc": "Festival of lights", "region": "All India"},
    {"date": "11-07", "name": "Bhai Dooj", "desc": "Brother-sister festival", "region": "North India"},
    {"date": "11-12", "name": "Guru Nanak Jayanti", "desc": "Birth of Guru Nanak", "region": "Punjab"},
    {"date": "12-25", "name": "Christmas", "desc": "Birth of Jesus Christ", "region": "All India"},
]

def main():
    today = datetime.date.today()
    print("=" * 55)
    print("  Vajra OS Festival Calendar")
    print(f"  Today: {today.strftime('%A, %d %B %Y')}")
    print("=" * 55)
    print(f"\n  {'Date':12s} {'Festival':25s} {'Region':15s}")
    print("  " + "-" * 55)
    for f in FESTIVALS:
        month, day = map(int, f["date"].split("-"))
        fdate = datetime.date(today.year, month, day)
        marker = " <-- TODAY!" if fdate == today else (" (past)" if fdate < today else " (upcoming)")
        print(f"  {fdate.strftime('%d %b'):12s} {f['name']:25s} {f['region']:15s}{marker}")
    print(f"\n  Total: {len(FESTIVALS)} festivals")
    
    print("\n  Upcoming festivals:")
    upcoming = []
    for f in FESTIVALS:
        month, day = map(int, f["date"].split("-"))
        fdate = datetime.date(today.year, month, day)
        if fdate >= today:
            upcoming.append((fdate, f))
    upcoming.sort()
    for fdate, f in upcoming[:5]:
        print(f"    {fdate.strftime('%d %b %Y')}: {f['name']} - {f['desc']}")

if __name__ == "__main__":
    main()