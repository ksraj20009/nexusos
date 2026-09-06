#!/usr/bin/env python3
"""Vajra OS Memory Manager — virtual memory, swap, OOM, memory maps.
Like Windows Memory Manager / Linux mm subsystem.
This is the fundamental memory management layer of the OS."""
import os
import sys
import time
from pathlib import Path

PROC_DIR = Path("/proc")

def read_meminfo():
    """Read /proc/meminfo — the fundamental memory status of the system."""
    info = {}
    try:
        with open("/proc/meminfo") as f:
            for line in f:
                parts = line.split(":")
                if len(parts) == 2:
                    key = parts[0].strip()
                    val = parts[1].strip().split()[0]
                    info[key] = int(val)
    except:
        pass
    return info

def format_kb(kb):
    """Format KB to human readable."""
    if kb >= 1048576:
        return f"{kb / 1048576:.1f} GB"
    elif kb >= 1024:
        return f"{kb / 1024:.1f} MB"
    return f"{kb} KB"

def show_memory_overview():
    """Show total/used/free memory — like free -h but with more detail."""
    m = read_meminfo()
    total = m.get("MemTotal", 0)
    free = m.get("MemFree", 0)
    available = m.get("MemAvailable", 0)
    buffers = m.get("Buffers", 0)
    cached = m.get("Cached", 0)
    swap_total = m.get("SwapTotal", 0)
    swap_free = m.get("SwapFree", 0)
    used = total - free - buffers - cached
    swap_used = swap_total - swap_free

    print("\n  --- Memory Overview ---")
    print(f"  Total RAM:     {format_kb(total):>12s}")
    print(f"  Used:          {format_kb(used):>12s}  ({used*100//total if total else 0}%)")
    print(f"  Free:          {format_kb(free):>12s}")
    print(f"  Available:     {format_kb(available):>12s}")
    print(f"  Buffers:       {format_kb(buffers):>12s}")
    print(f"  Cached:        {format_kb(cached):>12s}")
    print()
    print(f"  Swap Total:    {format_kb(swap_total):>12s}")
    print(f"  Swap Used:     {format_kb(swap_used):>12s}")
    print(f"  Swap Free:     {format_kb(swap_free):>12s}")
    print()

    # Memory pressure assessment
    if total > 0:
        pct = used * 100 // total
        if pct > 90:
            print("  [!] CRITICAL: Memory usage above 90%!")
        elif pct > 75:
            print("  [!] WARNING: Memory usage above 75%")
        else:
            print("  [+] Memory usage is healthy")

def show_top_memory_consumers():
    """Show top processes by memory — like top sorted by RES."""
    procs = []
    for pid_dir in PROC_DIR.iterdir():
        if not pid_dir.name.isdigit():
            continue
        try:
            with open(pid_dir / "statm") as f:
                mem = f.read().split()
            rss = int(mem[1]) * 4096 // 1024  # pages to KB
            with open(pid_dir / "stat") as f:
                stat = f.read().split()
            name = stat[1].strip("()")
            procs.append((int(pid_dir.name), name, rss))
        except:
            continue
    procs.sort(key=lambda x: -x[2])
    print(f"\n  {'PID':>7s}  {'RSS':>12s}  {'NAME':25s}")
    print("  " + "-" * 50)
    for pid, name, rss in procs[:25]:
        print(f"  {pid:>7d}  {format_kb(rss):>12s}  {name:25s}")

def show_memory_maps(pid):
    """Show memory maps for a process — like /proc/PID/maps or pmap."""
    pid_dir = PROC_DIR / str(pid)
    if not pid_dir.exists():
        print(f"  [-] Process {pid} not found")
        return
    print(f"\n  --- Memory Maps for PID {pid} ---")
    try:
        with open(pid_dir / "maps") as f:
            maps = f.readlines()
        print(f"  {'Address Range':30s}  {'Perms':6s}  {'Size':>10s}  {'Mapping'}")
        print("  " + "-" * 70)
        for line in maps[:40]:
            parts = line.split()
            addr = parts[0]
            perms = parts[1] if len(parts) > 1 else ""
            mapping = parts[-1] if len(parts) > 5 else "[anonymous]"
            addr_start, addr_end = addr.split("-")
            size = int(addr_end, 16) - int(addr_start, 16)
            size_str = format_kb(size // 1024) if size > 1024 else f"{size} B"
            print(f"  {addr:30s}  {perms:6s}  {size_str:>10s}  {mapping}")
        if len(maps) > 40:
            print(f"  ... and {len(maps) - 40} more mappings")
    except:
        print("  [-] Cannot read memory maps")

def manage_swap():
    """Manage swap space — like swapon/swapoff."""
    print("\n  --- Swap Management ---")
    try:
        with open("/proc/swaps") as f:
            print("  Current swap devices:")
            for line in f:
                print(f"    {line.strip()}")
    except:
        print("  No swap configured")
    print()
    print("  1. Create swap file")
    print("  2. Enable swap file")
    print("  3. Disable swap file")
    print("  4. Set swappiness")
    print("  5. View current swappiness")
    c = input("  Choice: ").strip()
    if c == "1":
        size = input("  Swap file size (GB) [4]: ").strip() or "4"
        path = input("  Path [/swapfile]: ").strip() or "/swapfile"
        os.system(f"sudo fallocate -l {size}G {path} 2>/dev/null || sudo dd if=/dev/zero of={path} bs=1M count={int(size)*1024}")
        os.system(f"sudo chmod 600 {path}")
        os.system(f"sudo mkswap {path}")
        print(f"  [+] Swap file created at {path}")
    elif c == "2":
        path = input("  Path [/swapfile]: ").strip() or "/swapfile"
        os.system(f"sudo swapon {path}")
        print(f"  [+] Swap enabled: {path}")
    elif c == "3":
        path = input("  Path [/swapfile]: ").strip() or "/swapfile"
        os.system(f"sudo swapoff {path}")
        print(f"  [+] Swap disabled: {path}")
    elif c == "4":
        val = input("  Swappiness (0-100) [60]: ").strip() or "60"
        os.system(f"sudo sysctl vm.swappiness={val}")
        print(f"  [+] Swappiness set to {val}")
    elif c == "5":
        try:
            with open("/proc/sys/vm/swappiness") as f:
                print(f"  Current swappiness: {f.read().strip()}")
        except:
            print("  Cannot read swappiness")

def show_oom_info():
    """Show OOM (Out-Of-Memory) killer settings and scores."""
    print("\n  --- OOM Killer Configuration ---")
    try:
        with open("/proc/sys/vm/overcommit_memory") as f:
            mode = int(f.read().strip())
            modes = {0: "Heuristic (default)", 1: "Always allow", 2: "Don't allow overcommit"}
            print(f"  Overcommit mode: {modes.get(mode, 'Unknown')}")
    except:
        pass
    try:
        with open("/proc/sys/vm/panic_on_oom") as f:
            panic = f.read().strip()
            print(f"  Panic on OOM: {'Yes' if panic == '1' else 'No (kill process instead)'}")
    except:
        pass
    # Show top OOM-scored processes (most likely to be killed)
    print("\n  Top OOM scores (highest = most likely to be killed):")
    scores = []
    for pid_dir in PROC_DIR.iterdir():
        if not pid_dir.name.isdigit():
            continue
        try:
            with open(pid_dir / "oom_score") as f:
                score = int(f.read().strip())
            with open(pid_dir / "stat") as f:
                name = f.read().split()[1].strip("()")
            scores.append((int(pid_dir.name), name, score))
        except:
            continue
    scores.sort(key=lambda x: -x[2])
    print(f"  {'PID':>7s}  {'SCORE':>8s}  {'NAME':25s}")
    print("  " + "-" * 45)
    for pid, name, score in scores[:15]:
        print(f"  {pid:>7d}  {score:>8d}  {name:25s}")

def show_hugepages():
    """Show huge page configuration — for performance tuning."""
    print("\n  --- Huge Pages ---")
    m = read_meminfo()
    print(f"  HugePages Total:  {m.get('HugePages_Total', 0)}")
    print(f"  HugePages Free:   {m.get('HugePages_Free', 0)}")
    print(f"  HugePages Rsvd:   {m.get('HugePages_Rsvd', 0)}")
    print(f"  HugePages Surp:   {m.get('HugePages_Surp', 0)}")
    print(f"  Hugepagesize:     {format_kb(m.get('Hugepagesize', 0))}")

def memory_monitor():
    """Live memory monitor — like watch free -h."""
    print("  Live memory monitor (Ctrl+C to stop)\n")
    try:
        while True:
            m = read_meminfo()
            total = m.get("MemTotal", 0)
            available = m.get("MemAvailable", 0)
            used = total - available
            pct = used * 100 // total if total else 0
            os.system("clear 2>/dev/null")
            print(f"\n  Vajra OS Memory Monitor — {time.strftime('%H:%M:%S')}")
            print(f"  {'[' + '#' * (pct // 5) + ' ' * (20 - pct // 5) + ']'} {pct}% used")
            print(f"  Used: {format_kb(used)} / Total: {format_kb(total)}")
            print(f"  Available: {format_kb(available)}")
            swap_total = m.get("SwapTotal", 0)
            if swap_total > 0:
                swap_used = swap_total - m.get("SwapFree", 0)
                print(f"  Swap: {format_kb(swap_used)} / {format_kb(swap_total)}")
            time.sleep(2)
    except KeyboardInterrupt:
        print("\n  [+] Monitor stopped")

def main():
    print("=" * 55)
    print("  Vajra OS Memory Manager")
    print("  Virtual Memory | Swap | OOM | Memory Maps")
    print("=" * 55)
    while True:
        print("\n  1. Memory overview")
        print("  2. Top memory consumers")
        print("  3. Process memory maps (pmap)")
        print("  4. Swap management")
        print("  5. OOM killer info")
        print("  6. Huge pages")
        print("  7. Live monitor")
        print("  0. Exit")
        c = input("  Choice: ").strip()
        if c == "1":
            show_memory_overview()
        elif c == "2":
            show_top_memory_consumers()
        elif c == "3":
            pid = input("  PID: ").strip()
            try:
                show_memory_maps(int(pid))
            except:
                print("  [-] Invalid PID")
        elif c == "4":
            manage_swap()
        elif c == "5":
            show_oom_info()
        elif c == "6":
            show_hugepages()
        elif c == "7":
            memory_monitor()
        elif c == "0":
            break

if __name__ == "__main__":
    main()
