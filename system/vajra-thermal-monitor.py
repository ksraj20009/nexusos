#!/usr/bin/env python3
"""Vajra OS Thermal Monitor - CPU/GPU temperature (local, free, built-in)."""
import time, subprocess

def get_temps():
    temps = {}
    try:
        with open("/sys/class/thermal/thermal_zone0/temp") as f:
            temps["CPU"] = int(f.read().strip()) / 1000
    except: pass
    try:
        r = subprocess.run(["sensors"], capture_output=True, text=True, timeout=5)
        for line in r.stdout.split("\n"):
            if ":" in line and ("temp" in line.lower() or "Core" in line):
                parts = line.split(":")
                if len(parts) == 2:
                    name = parts[0].strip()
                    val = parts[1].strip().split()[0]
                    temps[name] = val
    except: pass
    return temps

def main():
    print("=" * 50)
    print("  Vajra OS Thermal Monitor (Ctrl+C to stop)")
    print("=" * 50)
    while True:
        temps = get_temps()
        if temps:
            for name, val in temps.items():
                if isinstance(val, float):
                    print(f"\r  {name}: {val:.1f}C", end="", flush=True)
                else:
                    print(f"  {name}: {val}")
        else:
            print("\r  No temperature sensors found", end="", flush=True)
        time.sleep(5)

if __name__ == "__main__":
    try: main()
    except KeyboardInterrupt: print("\n  Stopped")