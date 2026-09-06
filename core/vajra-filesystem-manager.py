#!/usr/bin/env python3
"""Vajra OS File System Manager — VFS, mount, permissions, journaling, disk layout.
Like Windows Disk Management + fsutil / Linux mount+fdisk+mkfs+chmod.
This is the fundamental file system layer of the OS."""
import os
import sys
import subprocess
import stat
import shutil
from pathlib import Path

# Supported filesystem types (like mkfs.ext4, mkfs.btrfs, etc.)
FS_TYPES = {
    "ext4": "Extended 4 (default, journaling)",
    "ext3": "Extended 3 (journaling)",
    "ext2": "Extended 2 (no journaling)",
    "btrfs": "Btrfs (copy-on-write, snapshots)",
    "xfs": "XFS (high performance, journaling)",
    "f2fs": "F2FS (flash-friendly)",
    "ntfs": "NTFS (Windows compatible)",
    "exfat": "exFAT (cross-platform, USB)",
    "fat32": "FAT32 (legacy, cross-platform)",
    "tmpfs": "tmpfs (RAM disk, temporary)",
}

# Permission bits
PERM_BITS = {
    stat.S_IRUSR: "r", stat.S_IWUSR: "w", stat.S_IXUSR: "x",
    stat.S_IRGRP: "r", stat.S_IWGRP: "w", stat.S_IXGRP: "x",
    stat.S_IROTH: "r", stat.S_IWOTH: "w", stat.S_IXOTH: "x",
}

def show_mounted_filesystems():
    """Show all mounted filesystems — like mount or df."""
    print("\n  --- Mounted Filesystems ---")
    print(f"  {'Device':20s}  {'Mount Point':25s}  {'Type':8s}  {'Options':30s}")
    print("  " + "-" * 90)
    try:
        with open("/proc/mounts") as f:
            for line in f:
                parts = line.split()
                if len(parts) >= 4:
                    dev, mount, fstype, opts = parts[0], parts[1], parts[2], parts[3]
                    print(f"  {dev:20s}  {mount:25s}  {fstype:8s}  {opts[:30]}")
    except:
        print("  Cannot read /proc/mounts")

def show_disk_usage():
    """Show disk usage — like df -h."""
    print("\n  --- Disk Usage ---")
    print(f"  {'Filesystem':25s}  {'Size':>10s}  {'Used':>10s}  {'Avail':>10s}  {'Use%':>6s}  {'Mount'}")
    print("  " + "-" * 80)
    usage = shutil.disk_usage("/")
    print(f"  {'root':25s}  {format_size(usage.total):>10s}  {format_size(usage.used):>10s}  {format_size(usage.free):>10s}  {usage.used*100//usage.total:>5d}%  /")
    try:
        result = subprocess.run(["df", "-h"], capture_output=True, text=True, timeout=5)
        for line in result.stdout.split("\n")[1:]:
            parts = line.split()
            if len(parts) >= 6 and parts[0] != "tmpfs" and parts[0] != "devtmpfs":
                print(f"  {parts[0]:25s}  {parts[1]:>10s}  {parts[2]:>10s}  {parts[3]:>10s}  {parts[4]:>6s}  {parts[5]}")
    except:
        pass

def format_size(bytes):
    if bytes >= 1099511627776:
        return f"{bytes/1099511627776:.1f}T"
    elif bytes >= 1073741824:
        return f"{bytes/1073741824:.1f}G"
    elif bytes >= 1048576:
        return f"{bytes/1048576:.1f}M"
    return f"{bytes/1024:.1f}K"

def show_block_devices():
    """Show block devices — like lsblk."""
    print("\n  --- Block Devices ---")
    print(f"  {'Name':12s}  {'Size':>10s}  {'Type':8s}  {'Mount':15s}  {'FS':8s}")
    print("  " + "-" * 60)
    try:
        result = subprocess.run(["lsblk", "-o", "NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE"],
                              capture_output=True, text=True, timeout=5)
        for line in result.stdout.split("\n")[1:]:
            if line.strip():
                print(f"  {line}")
    except:
        # Fallback: read from /proc/partitions
        try:
            with open("/proc/partitions") as f:
                for line in f.readlines()[2:]:
                    parts = line.split()
                    if len(parts) >= 4:
                        print(f"  {parts[3]:12s}  {format_size(int(parts[2])*1024):>10s}  {'disk':8s}")
        except:
            print("  Cannot read block devices")

def manage_permissions():
    """Manage file permissions — like chmod/chown."""
    path = input("  File/directory path: ").strip()
    if not os.path.exists(path):
        print(f"  [-] Path not found: {path}")
        return
    st = os.stat(path)
    mode = stat.S_IMODE(st.st_mode)
    print(f"  Current permissions: {oct(mode)[2:]} ({format_permissions(st.st_mode)})")
    print(f"  Owner: {st.st_uid}  Group: {st.st_gid}")
    print(f"  Size: {format_size(st.st_size)}")
    print(f"  Type: {'Directory' if stat.S_ISDIR(st.st_mode) else 'File'}")
    print()
    print("  1. Set permissions (octal, e.g. 755)")
    print("  2. Set permissions (symbolic, e.g. u+rwx,g+rx)")
    print("  3. Change owner")
    print("  4. Change group")
    print("  5. Make executable")
    print("  6. Make read-only")
    c = input("  Choice: ").strip()
    if c == "1":
        perm = input("  Octal permissions (e.g. 755): ").strip()
        try:
            os.chmod(path, int(perm, 8))
            print(f"  [+] Permissions set to {perm}")
        except:
            print("  [-] Invalid permissions")
    elif c == "2":
        perm = input("  Symbolic (e.g. u+rwx,g+rx,o+r): ").strip()
        os.system(f"chmod {perm} {path}")
        print(f"  [+] Permissions updated")
    elif c == "3":
        uid = input("  New owner UID: ").strip()
        os.system(f"sudo chown {uid} {path}")
        print(f"  [+] Owner changed")
    elif c == "4":
        gid = input("  New group GID: ").strip()
        os.system(f"sudo chgrp {gid} {path}")
        print(f"  [+] Group changed")
    elif c == "5":
        os.chmod(path, mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)
        print(f"  [+] Made executable")
    elif c == "6":
        os.chmod(path, mode & ~stat.S_IWUSR & ~stat.S_IWGRP & ~stat.S_IWOTH)
        print(f"  [+] Made read-only")

def format_permissions(mode):
    """Convert mode to rwx string."""
    result = ""
    perms = [("r", stat.S_IRUSR), ("w", stat.S_IWUSR), ("x", stat.S_IXUSR),
             ("r", stat.S_IRGRP), ("w", stat.S_IWGRP), ("x", stat.S_IXGRP),
             ("r", stat.S_IROTH), ("w", stat.S_IWOTH), ("x", stat.S_IXOTH)]
    for char, bit in perms:
        result += char if mode & bit else "-"
    return result

def mount_filesystem():
    """Mount a filesystem — like mount command."""
    print("\n  --- Mount Filesystem ---")
    dev = input("  Device (e.g. /dev/sdb1): ").strip()
    mountpoint = input("  Mount point (e.g. /mnt/usb): ").strip()
    fstype = input(f"  Filesystem type [auto]: ").strip()
    mkdir_cmd = f"sudo mkdir -p {mountpoint}"
    os.system(mkdir_cmd)
    if fstype:
        cmd = f"sudo mount -t {fstype} {dev} {mountpoint}"
    else:
        cmd = f"sudo mount {dev} {mountpoint}"
    os.system(cmd)
    print(f"  [+] Mounted {dev} at {mountpoint}")

def unmount_filesystem():
    """Unmount a filesystem."""
    mountpoint = input("  Mount point to unmount: ").strip()
    os.system(f"sudo umount {mountpoint}")
    print(f"  [+] Unmounted {mountpoint}")

def format_filesystem():
    """Format a device with a filesystem — like mkfs."""
    print("\n  --- Format Filesystem ---")
    print("  WARNING: This will DESTROY all data on the device!")
    dev = input("  Device to format (e.g. /dev/sdb1): ").strip()
    print("  Available filesystem types:")
    for fst, desc in FS_TYPES.items():
        print(f"    {fst:8s} - {desc}")
    fstype = input("  Filesystem type [ext4]: ").strip() or "ext4"
    confirm = input(f"  Type 'YES' to confirm formatting {dev} as {fstype}: ").strip()
    if confirm == "YES":
        cmd = f"sudo mkfs.{fstype} {dev}"
        os.system(cmd)
        print(f"  [+] Formatted {dev} as {fstype}")
    else:
        print("  [-] Cancelled")

def show_fstab():
    """Show /etc/fstab — persistent mount configuration."""
    print("\n  --- /etc/fstab (Persistent Mounts) ---")
    try:
        with open("/etc/fstab") as f:
            for line in f:
                if line.strip() and not line.startswith("#"):
                    print(f"  {line.strip()}")
    except:
        print("  Cannot read /etc/fstab")

def check_filesystem():
    """Check filesystem integrity — like fsck."""
    print("\n  --- Filesystem Check (fsck) ---")
    dev = input("  Device to check (e.g. /dev/sda1): ").strip()
    print("  Options:")
    print("    1. Check only (read-only)")
    print("    2. Check and repair")
    c = input("  Choice: ").strip()
    if c == "1":
        os.system(f"sudo fsck -n {dev}")
    elif c == "2":
        os.system(f"sudo fsck -y {dev}")
    print("  [+] Filesystem check complete")

def show_directory_tree():
    """Show directory tree of a path — like tree command."""
    path = input(f"  Path [.]:" ).strip() or "."
    if not os.path.exists(path):
        print(f"  [-] Path not found")
        return
    count = 0
    for root, dirs, files in os.walk(path):
        level = root.replace(path, "").count(os.sep)
        indent = "  " * (level + 2)
        print(f"{indent}{os.path.basename(root)}/")
        subindent = "  " * (level + 3)
        for f in files[:10]:
            print(f"{subindent}{f}")
        count += 1
        if count > 20:
            print(f"  ... (truncated, too many directories)")
            break

def main():
    print("=" * 55)
    print("  Vajra OS File System Manager")
    print("  VFS | Mount | Permissions | Journaling | Disk")
    print("=" * 55)
    while True:
        print("\n  1. Mounted filesystems")
        print("  2. Disk usage (df)")
        print("  3. Block devices (lsblk)")
        print("  4. Manage permissions (chmod/chown)")
        print("  5. Mount filesystem")
        print("  6. Unmount filesystem")
        print("  7. Format filesystem (mkfs)")
        print("  8. View /etc/fstab")
        print("  9. Check filesystem (fsck)")
        print("  10. Directory tree")
        print("  0. Exit")
        c = input("  Choice: ").strip()
        if c == "1": show_mounted_filesystems()
        elif c == "2": show_disk_usage()
        elif c == "3": show_block_devices()
        elif c == "4": manage_permissions()
        elif c == "5": mount_filesystem()
        elif c == "6": unmount_filesystem()
        elif c == "7": format_filesystem()
        elif c == "8": show_fstab()
        elif c == "9": check_filesystem()
        elif c == "10": show_directory_tree()
        elif c == "0": break

if __name__ == "__main__":
    main()
