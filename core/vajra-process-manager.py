#!/usr/bin/env python3
"""Vajra OS Process Manager — process scheduling, signals, IPC, process states.
Like Windows Task Manager / Linux top+kill+signal system.
This is the fundamental process management layer of the OS."""
import os
import sys
import signal
import subprocess
import time
from pathlib import Path

PROC_DIR = Path("/proc")
LOG_DIR = Path("/var/log/vajra")
LOG_DIR.mkdir(parents=True, exist_ok=True)

# Process states (like Linux: R=running, S=sleeping, D=uninterruptible, Z=zombie, T=stopped)
PROC_STATES = {
    "R": "Running",
    "S": "Sleeping",
    "D": "Uninterruptible Sleep",
    "Z": "Zombie",
    "T": "Stopped",
    "I": "Idle",
}

# Signal definitions (like POSIX signals)
SIGNALS = {
    1: ("SIGHUP", "Hang up / reload config"),
    2: ("SIGINT", "Interrupt (Ctrl+C)"),
    3: ("SIGQUIT", "Quit (Ctrl+\\)"),
    9: ("SIGKILL", "Force kill (cannot be caught)"),
    15: ("SIGTERM", "Graceful terminate"),
    18: ("SIGCONT", "Continue execution"),
    19: ("SIGSTOP", "Stop execution (cannot be caught)"),
    20: ("SIGTSTP", "Stop (Ctrl+Z)"),
}

def get_all_processes():
    """Read /proc to get all running processes — the fundamental process listing."""
    procs = []
    if not PROC_DIR.exists():
        return procs
    for pid_dir in PROC_DIR.iterdir():
        if not pid_dir.name.isdigit():
            continue
        pid = int(pid_dir.name)
        try:
            with open(pid_dir / "stat") as f:
                stat = f.read().split()
            comm = stat[1].strip("()")
            state = stat[2]
            ppid = int(stat[3])
            with open(pid_dir / "statm") as f:
                mem = f.read().split()
            rss = int(mem[1]) * 4096 // 1024  # pages to KB
            try:
                with open(pid_dir / "cmdline") as f:
                    cmdline = f.read().replace("\x00", " ").strip()[:60]
            except:
                cmdline = comm
            procs.append({
                "pid": pid, "name": comm, "state": state, "ppid": ppid,
                "rss_kb": rss, "cmdline": cmdline or comm,
                "state_name": PROC_STATES.get(state, "Unknown"),
            })
        except (IOError, IndexError):
            continue
    procs.sort(key=lambda p: p["pid"])
    return procs

def get_process_tree(pid):
    """Build a process tree — parent/child relationships (like pstree)."""
    procs = get_all_processes()
    children = {}
    for p in procs:
        children.setdefault(p["ppid"], []).append(p)
    def _tree(ppid, depth=0):
        result = []
        for p in children.get(ppid, []):
            result.append(("  " * depth + f"├─ [{p['pid']}] {p['name']} ({p['state_name']})", p))
            result.extend(_tree(p["pid"], depth + 1))
        return result
    return _tree(pid)

def show_process_list():
    """Display all processes — like top/ps aux."""
    procs = get_all_processes()
    print(f"\n  {'PID':>7s}  {'PPID':>7s}  {'STATE':>12s}  {'RSS(KB)':>10s}  {'NAME':20s}  CMDLINE")
    print("  " + "-" * 90)
    for p in procs[:50]:
        print(f"  {p['pid']:>7d}  {p['ppid']:>7d}  {p['state_name']:>12s}  {p['rss_kb']:>10d}  {p['name']:20s}  {p['cmdline']}")
    if len(procs) > 50:
        print(f"  ... and {len(procs) - 50} more processes")

def show_process_details(pid):
    """Show detailed info about a single process — like /proc/PID/status."""
    pid_dir = PROC_DIR / str(pid)
    if not pid_dir.exists():
        print(f"  [-] Process {pid} not found")
        return
    print(f"\n  --- Process {pid} Details ---")
    try:
        with open(pid_dir / "status") as f:
            for line in f:
                key = line.split(":")[0]
                if key in ("Name", "State", "Pid", "PPid", "Uid", "Gid", "VmRSS", "VmSize", "Threads", "VmPeak"):
                    print(f"  {line.strip()}")
    except:
        pass
    try:
        with open(pid_dir / "cmdline") as f:
            print(f"  Command: {f.read().replace(chr(0), ' ').strip()}")
    except:
        pass
    print(f"\n  Process Tree:")
    for line, _ in get_process_tree(pid):
        print(f"  {line}")

def send_signal(pid, sig_num):
    """Send a signal to a process — fundamental IPC mechanism."""
    try:
        os.kill(pid, sig_num)
        sig_name, sig_desc = SIGNALS.get(sig_num, ("UNKNOWN", ""))
        print(f"  [+] Sent {sig_name} ({sig_desc}) to PID {pid}")
    except ProcessLookupError:
        print(f"  [-] Process {pid} does not exist")
    except PermissionError:
        print(f"  [-] Permission denied — try with sudo")
    except Exception as e:
        print(f"  [-] Error: {e}")

def kill_process():
    """Kill a process — with signal selection."""
    pid = input("  PID to signal: ").strip()
    try:
        pid = int(pid)
    except:
        print("  [-] Invalid PID")
        return
    print("  Available signals:")
    for num, (name, desc) in sorted(SIGNALS.items()):
        print(f"    {num:2d} = {name:10s} ({desc})")
    sig = input(f"  Signal number [15 (SIGTERM)]: ").strip()
    try:
        sig = int(sig) if sig else 15
    except:
        sig = 15
    send_signal(pid, sig)

def show_system_load():
    """Show system load average and CPU info — like uptime + /proc/loadavg."""
    try:
        with open("/proc/loadavg") as f:
            load = f.read().split()
        print(f"\n  Load average: {load[0]} (1min)  {load[1]} (5min)  {load[2]} (15min)")
        print(f"  Running processes: {load[3].split('/')[0]} / Total: {load[3].split('/')[1]}")
    except:
        pass
    try:
        with open("/proc/uptime") as f:
            uptime = float(f.read().split()[0])
        hours = int(uptime // 3600)
        mins = int((uptime % 3600) // 60)
        print(f"  Uptime: {hours}h {mins}m")
    except:
        pass
    try:
        with open("/proc/cpuinfo") as f:
            cores = sum(1 for line in f if line.startswith("processor"))
        print(f"  CPU cores: {cores}")
    except:
        pass
    procs = get_all_processes()
    states = {}
    for p in procs:
        states[p["state_name"]] = states.get(p["state_name"], 0) + 1
    print(f"  Process states: {', '.join(f'{v} {k}' for k, v in states.items())}")

def monitor_processes():
    """Live process monitor — like top."""
    print("  Live monitor (Ctrl+C to stop)\n")
    try:
        while True:
            procs = get_all_processes()
            os.system("clear 2>/dev/null")
            show_system_load()
            print(f"\n  {'PID':>7s}  {'STATE':>12s}  {'RSS(KB)':>10s}  {'NAME':20s}")
            print("  " + "-" * 55)
            for p in sorted(procs, key=lambda x: -x["rss_kb"])[:20]:
                print(f"  {p['pid']:>7d}  {p['state_name']:>12s}  {p['rss_kb']:>10d}  {p['name']:20s}")
            time.sleep(2)
    except KeyboardInterrupt:
        print("\n  [+] Monitor stopped")

def show_signals_reference():
    """Show all available signals — POSIX signal reference."""
    print("\n  --- POSIX Signal Reference ---")
    print(f"  {'NUM':>4s}  {'NAME':>10s}  DESCRIPTION")
    print("  " + "-" * 50)
    for num, (name, desc) in sorted(SIGNALS.items()):
        print(f"  {num:>4d}  {name:>10s}  {desc}")

def main():
    print("=" * 55)
    print("  Vajra OS Process Manager")
    print("  Process Scheduling | Signals | IPC | States")
    print("=" * 55)
    while True:
        print("\n  1. List all processes")
        print("  2. Process details (by PID)")
        print("  3. Kill / signal a process")
        print("  4. System load & CPU")
        print("  5. Live monitor (top)")
        print("  6. Process tree")
        print("  7. Signal reference")
        print("  8. Zombie processes")
        print("  0. Exit")
        c = input("  Choice: ").strip()
        if c == "1":
            show_process_list()
        elif c == "2":
            pid = input("  PID: ").strip()
            try:
                show_process_details(int(pid))
            except:
                print("  [-] Invalid PID")
        elif c == "3":
            kill_process()
        elif c == "4":
            show_system_load()
        elif c == "5":
            monitor_processes()
        elif c == "6":
            pid = input("  Root PID [1]: ").strip() or "1"
            try:
                for line, _ in get_process_tree(int(pid)):
                    print(f"  {line}")
            except:
                print("  [-] Invalid PID")
        elif c == "7":
            show_signals_reference()
        elif c == "8":
            zombies = [p for p in get_all_processes() if p["state"] == "Z"]
            if zombies:
                print(f"\n  {len(zombies)} Zombie process(es) found:")
                for z in zombies:
                    print(f"    PID {z['pid']}: {z['name']} (parent: {z['ppid']})")
                print("  Kill the parent to clean up zombies.")
            else:
                print("\n  [+] No zombie processes")
        elif c == "0":
            break

if __name__ == "__main__":
    main()
