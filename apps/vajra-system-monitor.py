#!/usr/bin/env python3
"""Vajra OS System Monitor - CPU, RAM, disk, network, processes."""
import os, time, subprocess

def main():
    print("=" * 50)
    print("  Vajra OS System Monitor")
    print("=" * 50)
    while True:
        print(f"\n  Time: {time.strftime('%H:%M:%S')}")
        try:
            r = subprocess.run(["top", "-bn1"], capture_output=True, text=True, timeout=5)
            lines = r.stdout.split("\n")
            for line in lines[:7]:
                print(f"  {line}")
        except: pass
        try:
            with open("/proc/meminfo") as f:
                mem = {}
                for line in f:
                    parts = line.split(":")
                    if len(parts) == 2:
                        mem[parts[0].strip()] = parts[1].strip().split()[0]
                total = int(mem.get("MemTotal", 0))
                avail = int(mem.get("MemAvailable", 0))
                used = total - avail
                print(f"  Memory: {used//1024}MB / {total//1024}MB ({used*100//total if total else 0}%)")
        except: pass
        try:
            r = subprocess.run(["df", "-h", "/"], capture_output=True, text=True)
            print(f"  Disk: {r.stdout.strip().split(chr(10))[-1]}")
        except: pass
        try:
            with open("/sys/class/power_supply/BAT0/capacity") as f:
                print(f"  Battery: {f.read().strip()}%")
        except: pass
        print("\n  R=Refresh  Q=Quit")
        c = input("  Choice: ").strip().lower()
        if c == "q": break

if __name__ == "__main__":
    main()