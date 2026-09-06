#!/usr/bin/env python3
"""Vajra OS Update Manager — check, install, rollback, snapshots.
Like Windows Update / Linux apt+timeshift.
This is the fundamental update and rollback layer of the OS."""
import os
import sys
import subprocess
import time
from pathlib import Path

SNAPSHOT_DIR = Path("/var/lib/vajra/update-snapshots")
SNAPSHOT_DIR.mkdir(parents=True, exist_ok=True)
UPDATE_LOG = Path("/var/log/vajra/update.log")
UPDATE_LOG.parent.mkdir(parents=True, exist_ok=True)

def log_update(event, details=""):
    with open(UPDATE_LOG, "a") as f:
        f.write(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {event}: {details}\n")

def check_updates():
    """Check for available updates — like apt update."""
    print("\n  [*] Checking for updates...")
    os.system("sudo apt-get update -qq 2>/dev/null")
    print("\n  Available updates:")
    result = subprocess.run(["apt", "list", "--upgradable"], capture_output=True, text=True, timeout=30)
    updates = [l for l in result.stdout.split("\n") if "upgradable" in l]
    if updates:
        for u in updates:
            parts = u.split()
            print(f"  {parts[0]:30s}  {parts[1]:>15s} -> {parts[5] if len(parts)>5 else '?'}")
        print(f"\n  Total: {len(updates)} package(s) to update")
    else:
        print("  [+] System is up to date!")
    log_update("Check updates", f"{len(updates)} updates available")
    return len(updates)

def create_pre_update_snapshot():
    """Create a snapshot before updating — for rollback."""
    timestamp = time.strftime("%Y%m%d-%H%M%S")
    snap_dir = SNAPSHOT_DIR / f"pre-update-{timestamp}"
    snap_dir.mkdir(parents=True, exist_ok=True)
    # Save package list
    os.system(f"dpkg-query -W -f='${{Package}}=${{Version}}\n' > {snap_dir}/packages.list 2>/dev/null")
    # Save key config files
    for f in ["/etc/default/grub", "/etc/fstab", "/etc/hostname", "/etc/passwd", "/etc/group"]:
        if os.path.exists(f):
            os.system(f"cp {f} {snap_dir}/ 2>/dev/null")
    # Try timeshift if available
    if os.system("command -v timeshift &>/dev/null") == 0:
        os.system(f"sudo timeshift --create --comments 'pre-update-{timestamp}' --tags D 2>/dev/null")
    print(f"  [+] Pre-update snapshot saved: {snap_dir}")
    log_update("Snapshot created", str(snap_dir))
    return snap_dir

def install_updates():
    """Install all available updates — with snapshot first."""
    count = check_updates()
    if count == 0:
        print("  Nothing to update.")
        return
    print(f"\n  {count} packages will be updated.")
    confirm = input("  Create snapshot and install updates? (yes/no): ").strip()
    if confirm != "yes":
        print("  [-] Cancelled")
        return
    # Create snapshot first
    print("\n  [1/3] Creating pre-update snapshot...")
    create_pre_update_snapshot()
    # Install updates
    print("\n  [2/3] Installing updates...")
    os.system("sudo apt-get upgrade -y 2>&1 | tail -10")
    os.system("sudo apt-get dist-upgrade -y 2>&1 | tail -5")
    # Clean up
    print("\n  [3/3] Cleaning up...")
    os.system("sudo apt-get autoremove -y 2>/dev/null")
    os.system("sudo apt-get autoclean 2>/dev/null")
    print("\n  [+] All updates installed successfully!")
    log_update("Updates installed", f"{count} packages")

def rollback_update():
    """Rollback to a previous state — using snapshots."""
    print("\n  --- Rollback / Restore ---")
    snapshots = sorted(SNAPSHOT_DIR.iterdir()) if SNAPSHOT_DIR.exists() else []
    if not snapshots:
        print("  No snapshots available")
        return
    print("  Available snapshots:")
    for i, snap in enumerate(snapshots, 1):
        print(f"  {i}. {snap.name}")
    c = input("\n  Select snapshot to restore: ").strip()
    try:
        snap = snapshots[int(c) - 1]
    except:
        print("  [-] Invalid selection")
        return
    confirm = input(f"  Restore from {snap.name}? (yes/no): ").strip()
    if confirm != "yes":
        print("  [-] Cancelled")
        return
    # Restore package list
    pkg_list = snap / "packages.list"
    if pkg_list.exists():
        print("  [*] Restoring package list...")
        os.system(f"sudo dpkg --set-selections < {pkg_list} 2>/dev/null")
        os.system("sudo apt-get dselect-upgrade -y 2>/dev/null")
    # Try timeshift restore
    if os.system("command -v timeshift &>/dev/null") == 0:
        print("  [*] Restoring system files via timeshift...")
        os.system(f"sudo timeshift --restore --snapshot '{snap.name}' 2>/dev/null || echo 'Use timeshift GUI to restore'")
    print(f"  [+] Rollback from {snap.name} complete")
    log_update("Rollback", snap.name)

def update_kernel():
    """Update the kernel specifically."""
    print("\n  --- Kernel Update ---")
    os.system("uname -r")
    print("\n  Available kernels:")
    os.system("apt list --upgradable 2>/dev/null | grep -i linux-image || echo 'No kernel updates'")
    confirm = input("\n  Update kernel? (yes/no): ").strip()
    if confirm == "yes":
        create_pre_update_snapshot()
        os.system("sudo apt-get install -y linux-image-amd64 linux-headers-amd64 2>&1 | tail -5")
        print("  [+] Kernel updated. Reboot to apply.")
        log_update("Kernel updated")

def show_update_history():
    """Show update history from log."""
    print("\n  --- Update History ---")
    if UPDATE_LOG.exists():
        lines = UPDATE_LOG.read_text().strip().split("\n")
        for line in lines[-20:]:
            print(f"  {line}")
    else:
        print("  No update history yet")

def auto_update_settings():
    """Configure automatic updates."""
    print("\n  --- Automatic Update Settings ---")
    print("  1. Enable automatic security updates")
    print("  2. Disable automatic updates")
    print("  3. Enable automatic full updates")
    print("  4. Set update schedule")
    c = input("  Choice: ").strip()
    if c == "1":
        os.system("sudo apt install -y unattended-upgrades 2>/dev/null")
        os.system("sudo dpkg-reconfigure -plow unattended-upgrades 2>/dev/null")
        print("  [+] Automatic security updates enabled")
        log_update("Auto security updates enabled")
    elif c == "2":
        os.system("sudo systemctl disable apt-daily-upgrade.timer 2>/dev/null")
        print("  [+] Automatic updates disabled")
        log_update("Auto updates disabled")
    elif c == "3":
        os.system("sudo apt install -y unattended-upgrades 2>/dev/null")
        config = Path("/etc/apt/apt.conf.d/50unattended-upgrades")
        if config.exists():
            os.system(f"sudo sed -i 's|//\"o=Debian,a=stable\";|\"o=Debian,a=stable\";|' {config}")
        print("  [+] Automatic full updates enabled")
    elif c == "4":
        print("  Update schedule is managed by systemd timers:")
        os.system("systemctl list-timers apt-daily apt-daily-upgrade 2>/dev/null")

def clean_system():
    """Clean unused packages and cache."""
    print("\n  --- System Cleanup ---")
    print("  [*] Removing unused packages...")
    os.system("sudo apt-get autoremove -y 2>&1 | tail -3")
    print("  [*] Cleaning package cache...")
    os.system("sudo apt-get autoclean 2>/dev/null")
    os.system("sudo apt-get clean 2>/dev/null")
    print("  [*] Cleaning journal logs older than 7 days...")
    os.system("sudo journalctl --vacuum-time=7d 2>/dev/null")
    print("  [*] Cleaning thumbnail cache...")
    os.system("rm -rf ~/.cache/thumbnails 2>/dev/null")
    print("  [+] System cleaned!")
    log_update("System cleanup")

def main():
    print("=" * 55)
    print("  Vajra OS Update Manager")
    print("  Check | Install | Rollback | Auto-Update")
    print("=" * 55)
    while True:
        print("\n  1. Check for updates")
        print("  2. Install updates (with snapshot)")
        print("  3. Rollback to previous state")
        print("  4. Update kernel")
        print("  5. Update history")
        print("  6. Automatic update settings")
        print("  7. System cleanup")
        print("  8. Create snapshot manually")
        print("  0. Exit")
        c = input("  Choice: ").strip()
        if c == "1": check_updates()
        elif c == "2": install_updates()
        elif c == "3": rollback_update()
        elif c == "4": update_kernel()
        elif c == "5": show_update_history()
        elif c == "6": auto_update_settings()
        elif c == "7": clean_system()
        elif c == "8": create_pre_update_snapshot()
        elif c == "0": break

if __name__ == "__main__":
    main()
