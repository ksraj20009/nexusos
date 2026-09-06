#!/usr/bin/env python3
"""Vajra OS Health Reminders - Periodic health and wellness notifications."""
import subprocess, time, datetime

REMINDERS = [
    {"time": "10:00", "msg": "Time to drink water! Stay hydrated.", "type": "hydration"},
    {"time": "12:00", "msg": "Take a break from screen. Look 20ft away for 20 seconds.", "type": "eyes"},
    {"time": "14:00", "msg": "Drink water and stretch your body.", "type": "hydration"},
    {"time": "16:00", "msg": "Take a 5-minute walk. Movement is medicine.", "type": "movement"},
    {"time": "18:00", "msg": "Evening yoga time. Try vj-yoga for guided session.", "type": "yoga"},
    {"time": "20:00", "msg": "Dinner time. Eat light per Ayurveda (vj-ayurveda).", "type": "diet"},
    {"time": "22:00", "msg": "Wind down. Reduce screen brightness. Sleep by 23:00.", "type": "sleep"},
]

def notify(title, msg):
    try:
        subprocess.run(["notify-send", "-u", "normal", title, msg], timeout=5)
    except Exception:
        print(f"[{title}] {msg}")

def main():
    print("=" * 50)
    print("  Vajra OS Health Reminders Daemon")
    print("  Running in background... (Ctrl+C to stop)")
    print("=" * 50)
    sent = set()
    while True:
        now = datetime.datetime.now().strftime("%H:%M")
        for r in REMINDERS:
            if now == r["time"] and r["time"] not in sent:
                notify("Vajra Health Reminder", r["msg"])
                sent.add(r["time"])
        if now == "00:00":
            sent.clear()
        time.sleep(30)

if __name__ == "__main__":
    main()