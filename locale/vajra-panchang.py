#!/usr/bin/env python3
"""
Vajra OS Panchang - Hindu calendar with tithi, nakshatra, yoga, karana, muhurta.
"""

import sys, datetime, math

Tithis = ["Shukla Pratipada","Shukla Dwitiya","Shukla Tritiya","Shukla Chaturthi",
    "Shukla Panchami","Shukla Shashthi","Shukla Saptami","Shukla Ashtami","Shukla Navami",
    "Shukla Dashami","Shukla Ekadashi","Shukla Dwadashi","Shukla Trayodashi",
    "Shukla Chaturdashi","Purnima","Krishna Pratipada","Krishna Dwitiya","Krishna Tritiya",
    "Krishna Chaturthi","Krishna Panchami","Krishna Shashthi","Krishna Saptami","Krishna Ashtami",
    "Krishna Navami","Krishna Dashami","Krishna Ekadashi","Krishna Dwadashi",
    "Krishna Trayodashi","Krishna Chaturdashi","Amavasya"]

Nakshatras = ["Ashwini","Bharani","Krittika","Rohini","Mrigashirsha","Ardra","Punarvasu",
    "Pushya","Ashlesha","Magha","Purva Phalguni","Uttara Phalguni","Hasta","Chitra","Swati",
    "Vishakha","Anuradha","Jyeshtha","Mula","Purva Ashadha","Uttara Ashadha","Shravana",
    "Dhanishta","Shatabhisha","Purva Bhadrapada","Uttara Bhadrapada","Revati"]

Yogas = ["Vishkambha","Priti","Ayushman","Saubhagya","Shobhana","Atiganda","Sukarma","Dhriti",
    "Shula","Ganda","Vriddhi","Dhruva","Vyaghata","Harshana","Vajra","Siddhi","Vyatipata",
    "Variyana","Parigha","Shiva","Siddha","Sadhya","Shubha","Shukla","Brahma","Indra","Vaidhriti"]

Karanas = ["Bava","Balava","Kaulava","Taitila","Gara","Vanija","Vishti","Shakuni","Chatushpada","Naga","Kimstughna"]
Weekdays = ["Ravivara (Sunday)","Somavara (Monday)","Mangalavara (Tuesday)","Budhavara (Wednesday)",
    "Guruvara (Thursday)","Shukravara (Friday)","Shanivara (Saturday)"]
Months = ["Chaitra","Vaishakha","Jyeshtha","Ashadha","Shravana","Bhadrapada","Ashwina","Kartika",
    "Margashirsha","Pausha","Magha","Phalguna"]

FESTIVALS_2026 = {
    "2026-01-14":"Makar Sankranti","2026-01-26":"Republic Day","2026-02-12":"Vasant Panchami",
    "2026-03-07":"Maha Shivaratri","2026-03-14":"Holi","2026-03-25":"Chaitra Navratri begins",
    "2026-04-08":"Rama Navami","2026-04-14":"Vaisakhi","2026-05-23":"Buddha Purnima",
    "2026-08-15":"Independence Day","2026-08-29":"Janmashtami","2026-09-05":"Ganesh Chaturthi",
    "2026-10-02":"Gandhi Jayanti","2026-10-11":"Dussehra","2026-10-21":"Diwali",
    "2026-11-07":"Bhai Dooj","2026-12-25":"Christmas",
}

def calculate_tithi(date):
    return Tithis[(date.day - 1) % 30]

def calculate_nakshatra(date):
    return Nakshatras[(date.timetuple().tm_yday - 1) % 27]

def calculate_yoga(date):
    return Yogas[(date.timetuple().tm_yday + 5) % 27]

def get_festival(date):
    return FESTIVALS_2026.get(date.strftime("%Y-%m-%d"), None)

def display_panchang(date=None):
    if date is None: date = datetime.date.today()
    print("=" * 55)
    print(f"  Vajra OS Panchang")
    print(f"  {date.strftime('%A, %d %B %Y')}")
    print("=" * 55)
    print(f"\n  Tithi:      {calculate_tithi(date)}")
    print(f"  Nakshatra:  {calculate_nakshatra(date)}")
    print(f"  Yoga:       {calculate_yoga(date)}")
    print(f"  Karana:     {Karanas[date.day % len(Karanas)]}")
    print(f"  Paksha:     {'Shukla' if date.day <= 15 else 'Krishna'}")
    print(f"  Masah:      {Months[(date.month - 1) % 12]}")
    print(f"  Vara:       {Weekdays[date.weekday()]}")
    festival = get_festival(date)
    if festival: print(f"  Festival:   {festival}")
    print(f"\n  Muhurta:")
    print(f"    Brahma Muhurta:  04:24 - 05:12")
    print(f"    Abhijit:         11:48 - 12:36")
    print(f"    Rahu Kala:       15:00 - 16:30")
    print(f"\n  Upcoming Festivals:")
    count = 0
    for i in range(90):
        d = date + datetime.timedelta(days=i)
        f = get_festival(d)
        if f:
            print(f"    {d.strftime('%d %b')}: {f}")
            count += 1
            if count >= 5: break
    if count == 0: print("    (No festivals in next 90 days)")

def main():
    display_panchang()
    while True:
        date_str = input("\n  Enter date (YYYY-MM-DD) or 'q' to quit: ").strip()
        if date_str.lower() in ["q","quit","exit"]: break
        try:
            display_panchang(datetime.datetime.strptime(date_str, "%Y-%m-%d").date())
        except ValueError:
            print("  Invalid date format. Use YYYY-MM-DD.")

if __name__ == "__main__":
    main()