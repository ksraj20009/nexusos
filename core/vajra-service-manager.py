#!/usr/bin/env python3
"""Vajra OS Init & Service Manager — systemd wrapper, service control, targets, sockets.
Like Windows Services Manager (services.msc) / Linux systemctl.
This is the fundamental init/service management layer of the OS."""
import os
import sys
import subprocess
from pathlib import Path

SYSTEMD_DIR = Path("/etc/systemd/system")

def show_all_services():
    """List all services — like systemctl list-units."""
    print("\n  --- All Services ---")
    print(f"  {'NAME':40s}  {'LOAD':6s}  {'ACTIVE':10s}  {'SUB':10s}")
    print("  " + "-" * 75)
    try:
        result = subprocess.run(["systemctl", "list-units", "--type=service", "--all", "--no-pager"],
                              capture_output=True, text=True, timeout=10)
        for line in result.stdout.split("\n"):
            if ".service" in line and "LOAD" not in line:
                parts = line.split()
                if len(parts) >= 4:
                    print(f"  {parts[0]:40s}  {parts[1]:6s}  {parts[2]:10s}  {parts[3]:10s}")
    except:
        print("  systemctl not available")

def show_active_services():
    """List only active/running services."""
    print("\n  --- Active (Running) Services ---")
    try:
        result = subprocess.run(["systemctl", "list-units", "--type=service", "--state=running", "--no-pager"],
                              capture_output=True, text=True, timeout=10)
        for line in result.stdout.split("\n"):
            if ".service" in line and "LOAD" not in line:
                parts = line.split()
                if len(parts) >= 1:
                    print(f"  {parts[0]}")
    except:
        print("  systemctl not available")

def show_failed_services():
    """Show failed services — like systemctl --failed."""
    print("\n  --- Failed Services ---")
    result = subprocess.run(["systemctl", "--failed", "--no-pager"], capture_output=True, text=True, timeout=10)
    if "0 loaded" in result.stdout or "0 failed" in result.stdout:
        print("  [+] No failed services!")
    else:
        for line in result.stdout.split("\n"):
            if line.strip() and "loaded" not in line and "UNIT" not in line:
                print(f"  {line}")

def service_control():
    """Start/stop/restart/reload a service."""
    svc = input("  Service name (e.g. sshd, tor, ufw): ").strip()
    if not svc:
        return
    print(f"\n  1. Start  2. Stop  3. Restart  4. Reload  5. Status  6. Enable  7. Disable")
    c = input("  Action: ").strip()
    actions = {"1": "start", "2": "stop", "3": "restart", "4": "reload", "5": "status", "6": "enable", "7": "disable"}
    action = actions.get(c, "")
    if action:
        os.system(f"sudo systemctl {action} {svc} 2>/dev/null")
        print(f"  [+] {action.capitalize()} {svc}")
        if action == "status":
            os.system(f"systemctl status {svc} 2>/dev/null | head -15")

def show_service_details():
    """Show detailed info about a service."""
    svc = input("  Service name: ").strip()
    if svc:
        os.system(f"systemctl status {svc} 2>/dev/null")
        print()
        os.system(f"systemctl cat {svc} 2>/dev/null")

def show_targets():
    """Show systemd targets — like runlevels."""
    print("\n  --- Systemd Targets (Runlevels) ---")
    print("  Current default target:", end=" ")
    os.system("systemctl get-default 2>/dev/null")
    print()
    print("  Available targets:")
    targets = [
        ("multi-user.target", "Multi-user (text mode, no GUI) — like runlevel 3"),
        ("graphical.target", "Graphical (GUI mode) — like runlevel 5"),
        ("rescue.target", "Rescue mode (single user, root only)"),
        ("emergency.target", "Emergency mode (minimal, no services)"),
        ("reboot.target", "Reboot the system"),
        ("poweroff.target", "Power off the system"),
        ("halt.target", "Halt the system"),
    ]
    for t, desc in targets:
        active = "*" if os.system(f"systemctl is-active {t} 2>/dev/null | grep -q active") == 0 else " "
        print(f"  [{active}] {t:25s}  {desc}")

def set_target():
    """Set the default boot target — like changing runlevel."""
    print("\n  --- Set Default Target ---")
    print("  1. Graphical (GUI, default)")
    print("  2. Multi-user (text mode only)")
    print("  3. Rescue mode")
    c = input("  Choice: ").strip()
    targets = {"1": "graphical.target", "2": "multi-user.target", "3": "rescue.target"}
    target = targets.get(c)
    if target:
        os.system(f"sudo systemctl set-default {target}")
        print(f"  [+] Default target set to {target}")
        if c == "2":
            print("  Note: GUI will not start on next boot. Use 'startx' for manual GUI.")

def show_timers():
    """Show systemd timers — scheduled tasks."""
    print("\n  --- Systemd Timers (Scheduled Tasks) ---")
    try:
        result = subprocess.run(["systemctl", "list-timers", "--all", "--no-pager"],
                              capture_output=True, text=True, timeout=10)
        for line in result.stdout.split("\n"):
            if line.strip() and "NEXT" not in line and "timers listed" not in line:
                print(f"  {line}")
    except:
        print("  systemctl not available")

def show_sockets():
    """Show systemd sockets — IPC and network sockets."""
    print("\n  --- Systemd Sockets ---")
    try:
        result = subprocess.run(["systemctl", "list-sockets", "--no-pager"],
                              capture_output=True, text=True, timeout=10)
        for line in result.stdout.split("\n")[:20]:
            if line.strip():
                print(f"  {line}")
    except:
        print("  systemctl not available")

def show_system_state():
    """Show overall system state — like systemctl status."""
    print("\n  --- System State ---")
    print(f"  Hostname: ", end="")
    os.system("hostname")
    print(f"  Kernel: ", end="")
    os.system("uname -r")
    print(f"  Architecture: ", end="")
    os.system("uname -m")
    print(f"  Boot time: ", end="")
    os.system("systemctl show -p KernelTimestamp --value 2>/dev/null || uptime -s")
    print(f"  Uptime: ", end="")
    os.system("uptime -p")
    print(f"  Default target: ", end="")
    os.system("systemctl get-default 2>/dev/null")
    print(f"  Active services: ", end="")
    os.system("systemctl list-units --type=service --state=running --no-pager 2>/dev/null | grep -c active || echo 0")
    print(f"  Failed services: ", end="")
    os.system("systemctl --failed --no-pager 2>/dev/null | grep -c failed || echo 0")
    print(f"  Total services: ", end="")
    os.system("systemctl list-units --type=service --all --no-pager 2>/dev/null | grep -c service || echo 0")

def create_service():
    """Create a new systemd service file."""
    print("\n  --- Create New Service ---")
    name = input("  Service name (e.g. myapp): ").strip()
    if not name:
        return
    desc = input("  Description: ").strip() or "Vajra OS custom service"
    exec_start = input("  ExecStart (command to run): ").strip()
    if not exec_start:
        print("  [-] ExecStart is required")
        return
    user = input("  Run as user [root]: ").strip() or "root"
    restart = input("  Restart on failure? (yes/no) [yes]: ").strip() or "yes"
    restart_val = "always" if restart == "yes" else "no"

    service_content = f"""[Unit]
Description={desc}
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User={user}
ExecStart={exec_start}
Restart={restart_val}
RestartSec=5

[Install]
WantedBy=multi-user.target
"""
    path = SYSTEMD_DIR / f"{name}.service"
    try:
        path.write_text(service_content)
        os.system("sudo systemctl daemon-reload")
        print(f"  [+] Service created: {path}")
        print(f"  [+] Enable with: sudo systemctl enable {name}")
        print(f"  [+] Start with: sudo systemctl start {name}")
    except PermissionError:
        print(f"  [-] Permission denied. Run with sudo.")

def main():
    print("=" * 55)
    print("  Vajra OS Init & Service Manager")
    print("  Services | Targets | Timers | Sockets")
    print("=" * 55)
    while True:
        print("\n  1. All services")
        print("  2. Active services")
        print("  3. Failed services")
        print("  4. Control a service (start/stop/restart)")
        print("  5. Service details")
        print("  6. System targets (runlevels)")
        print("  7. Set default target")
        print("  8. Timers (scheduled tasks)")
        print("  9. Sockets")
        print("  10. System state")
        print("  11. Create new service")
        print("  0. Exit")
        c = input("  Choice: ").strip()
        if c == "1": show_all_services()
        elif c == "2": show_active_services()
        elif c == "3": show_failed_services()
        elif c == "4": service_control()
        elif c == "5": show_service_details()
        elif c == "6": show_targets()
        elif c == "7": set_target()
        elif c == "8": show_timers()
        elif c == "9": show_sockets()
        elif c == "10": show_system_state()
        elif c == "11": create_service()
        elif c == "0": break

if __name__ == "__main__":
    main()
