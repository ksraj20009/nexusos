#!/usr/bin/env python3
"""Vajra OS Battery Monitor with low battery alerts."""
import os, time, subprocess

BAT_PATH = "/sys/class/power_supply/BAT0"

def get_battery_info():
    info = {}
    try:
        for key in ["capacity", "status", "charge_full", "charge_full_design"]:
            with open(f"{BAT_PATH}/{key}") as f:
                info[key] = f.read().strip()
    except Exception:
        return None
    return info

def notify(title, msg):
    subprocess.run(["notify-send", title, msg])

def main():
    print("=" * 50)
    print("  Vajra OS Battery Monitor")
    print("=" * 50)
    warned_20 = False
    warned_10 = False
    warned_5 = False
    while True:
        info = get_battery_info()
        if not info:
            print("  No battery found")
            break
        pct = int(info.get("capacity", 0))
        status = info.get("status", "Unknown")
        print(f"\r  Battery: {pct}% ({status})", end="", flush=True)
        if pct <= 5 and not warned_5:
            notify("Vajra Battery CRITICAL", f"Battery at {pct}%! Plug in immediately!")
            warned_5 = True
        elif pct <= 10 and not warned_10:
            notify("Vajra Battery LOW", f"Battery at {pct}%")
            warned_10 = True
        elif pct <= 20 and not warned_20:
            notify("Vajra Battery Warning", f"Battery at {pct}%")
            warned_20 = True
        if pct > 25:
            warned_20 = warned_10 = warned_5 = False
        try:
            time.sleep(60)
        except KeyboardInterrupt:
            print("\n  Stopped")
            break

if __name__ == "__main__":
    main()