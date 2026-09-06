#!/usr/bin/env python3
"""Vajra OS World Clock - Multiple timezones (local, free)."""
import datetime

ZONES = [
    ("India (IST)", "Asia/Kolkata", 5.5),
    ("USA (EST)", "America/New_York", -5),
    ("USA (PST)", "America/Los_Angeles", -8),
    ("UK (GMT)", "Europe/London", 0),
    ("UAE (GST)", "Asia/Dubai", 4),
    ("Singapore", "Asia/Singapore", 8),
    ("Japan (JST)", "Asia/Tokyo", 9),
    ("Australia (Sydney)", "Australia/Sydney", 11),
]

def main():
    print("=" * 50)
    print("  Vajra OS World Clock")
    print("=" * 50)
    utc_now = datetime.datetime.utcnow()
    print(f"\n  {'City':25s} {'Time':12s} {'Date':12s}")
    print("  " + "-" * 50)
    for name, tz, offset in ZONES:
        local = utc_now + datetime.timedelta(hours=offset)
        print(f"  {name:25s} {local.strftime('%H:%M:%S'):12s} {local.strftime('%d/%m/%Y'):12s}")

if __name__ == "__main__":
    main()