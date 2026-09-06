#!/usr/bin/env python3
"""Vajra OS Package Manager & App Store — install, remove, update, search.
Like Windows Store / apt+dpkg / macOS Homebrew.
This is the fundamental package management layer of the OS.
All apps show: info, pros, cons, permissions BEFORE installing (privacy-first)."""
import os
import sys
import subprocess
import json
from pathlib import Path

APP_DB_DIR = Path("/var/lib/vajra/app-store")
APP_DB_DIR.mkdir(parents=True, exist_ok=True)

# Vajra App Store database — all free and open source
APP_STORE = [
    # --- Productivity ---
    {"name": "LibreOffice", "pkg": "libreoffice", "category": "Office", "size": "350MB",
     "perms": "filesystem", "pros": "Full office suite, free, open source", "cons": "Large install",
     "desc": "Word processor, spreadsheet, presentations"},
    {"name": "OnlyOffice", "pkg": "onlyoffice-desktopeditors", "category": "Office", "size": "250MB",
     "perms": "filesystem, network", "pros": "MS Office compatible, free", "cons": "Large install",
     "desc": "MS Office-compatible editor"},
    {"name": "GIMP", "pkg": "gimp", "category": "Graphics", "size": "200MB",
     "perms": "filesystem", "pros": "Powerful image editor, free", "cons": "Steep learning curve",
     "desc": "Professional image editor (Photoshop alternative)"},
    {"name": "Inkscape", "pkg": "inkscape", "category": "Graphics", "size": "150MB",
     "perms": "filesystem", "pros": "Vector graphics, free", "cons": "Complex UI",
     "desc": "Vector graphics editor (Illustrator alternative)"},
    {"name": "Krita", "pkg": "krita", "category": "Graphics", "size": "180MB",
     "perms": "filesystem", "pros": "Digital painting, free", "cons": "Resource heavy",
     "desc": "Digital painting and illustration"},
    # --- Internet ---
    {"name": "Firefox", "pkg": "firefox-esr", "category": "Internet", "size": "55MB",
     "perms": "network, filesystem", "pros": "Privacy-focused, free, open source", "cons": "Uses RAM",
     "desc": "Privacy-focused web browser"},
    {"name": "Thunderbird", "pkg": "thunderbird", "category": "Internet", "size": "60MB",
     "perms": "network, filesystem", "pros": "Free email client, open source", "cons": "Basic UI",
     "desc": "Email client with calendar"},
    {"name": "Transmission", "pkg": "transmission-gtk", "category": "Internet", "size": "15MB",
     "perms": "network, filesystem", "pros": "Lightweight torrent client, free", "cons": "Basic features",
     "desc": "BitTorrent client"},
    {"name": "FileZilla", "pkg": "filezilla", "category": "Internet", "size": "20MB",
     "perms": "network, filesystem", "pros": "FTP/SFTP client, free", "cons": "UI dated",
     "desc": "FTP and SFTP file transfer"},
    # --- Media ---
    {"name": "VLC", "pkg": "vlc", "category": "Media", "size": "40MB",
     "perms": "audio, video, filesystem", "pros": "Plays everything, free", "cons": "Cluttered UI",
     "desc": "Media player (plays all formats)"},
    {"name": "OBS Studio", "pkg": "obs-studio", "category": "Media", "size": "120MB",
     "perms": "audio, video, display, network", "pros": "Screen recording, streaming, free", "cons": "Complex setup",
     "desc": "Screen recording and live streaming"},
    {"name": "Audacity", "pkg": "audacity", "category": "Media", "size": "30MB",
     "perms": "audio, filesystem", "pros": "Audio editing, free", "cons": "Old UI",
     "desc": "Audio editor and recorder"},
    {"name": "HandBrake", "pkg": "handbrake", "category": "Media", "size": "50MB",
     "perms": "filesystem", "pros": "Video converter, free", "cons": "Slow on large files",
     "desc": "Video transcoder"},
    # --- Developer ---
    {"name": "VS Code", "pkg": "code", "category": "Developer", "size": "80MB",
     "perms": "filesystem, network", "pros": "Best code editor, free", "cons": "Microsoft telemetry (can disable)",
     "desc": "Code editor with extensions"},
    {"name": "Git", "pkg": "git", "category": "Developer", "size": "35MB",
     "perms": "filesystem, network", "pros": "Version control, free", "cons": "CLI learning curve",
     "desc": "Version control system"},
    {"name": "Docker", "pkg": "docker.io", "category": "Developer", "size": "100MB",
     "perms": "network, filesystem, root", "pros": "Container platform, free", "cons": "Needs root",
     "desc": "Container management"},
    {"name": "Python3", "pkg": "python3 python3-pip", "category": "Developer", "size": "25MB",
     "perms": "filesystem, network", "pros": "Programming language, free", "cons": "None",
     "desc": "Python 3 runtime and pip"},
    {"name": "Node.js", "pkg": "nodejs npm", "category": "Developer", "size": "50MB",
     "perms": "filesystem, network", "pros": "JavaScript runtime, free", "cons": "None",
     "desc": "JavaScript runtime and npm"},
    # --- System ---
    {"name": "GParted", "pkg": "gparted", "category": "System", "size": "15MB",
     "perms": "filesystem, root", "pros": "Partition editor, free", "cons": "Needs root",
     "desc": "Disk partition editor"},
    {"name": "GDebi", "pkg": "gdebi", "category": "System", "size": "5MB",
     "perms": "filesystem, root", "pros": "Install .deb files easily", "cons": "Needs root",
     "desc": ".deb package installer"},
    {"name": "Timeshift", "pkg": "timeshift", "category": "System", "size": "10MB",
     "perms": "filesystem, root", "pros": "System backup snapshots, free", "cons": "Needs root",
     "desc": "System restore points"},
    # --- Security ---
    {"name": "ClamAV", "pkg": "clamav", "category": "Security", "size": "200MB",
     "perms": "filesystem, network", "pros": "Antivirus, free, open source", "cons": "Large DB",
     "desc": "Antivirus scanner"},
    {"name": "Wireshark", "pkg": "wireshark", "category": "Security", "size": "45MB",
     "perms": "network, root", "pros": "Network analyzer, free", "cons": "Needs root for capture",
     "desc": "Network protocol analyzer"},
    {"name": "Nmap", "pkg": "nmap", "category": "Security", "size": "15MB",
     "perms": "network", "pros": "Network scanner, free", "cons": "Can be misused",
     "desc": "Network discovery and security auditing"},
    # --- Communication ---
    {"name": "Telegram", "pkg": "telegram-desktop", "category": "Social", "size": "35MB",
     "perms": "network, contacts, filesystem", "pros": "Fast messaging, free", "cons": "Not E2E by default",
     "desc": "Messaging app"},
    {"name": "Signal", "pkg": "signal-desktop", "category": "Social", "size": "40MB",
     "perms": "network, contacts, filesystem", "pros": "E2E encrypted, free, open source", "cons": "Needs phone",
     "desc": "Encrypted messaging"},
    {"name": "Discord", "pkg": "discord", "category": "Social", "size": "80MB",
     "perms": "network, audio, filesystem", "pros": "Voice/text chat, free", "cons": "Not open source",
     "desc": "Voice and text chat for communities"},
    # --- Games ---
    {"name": "Steam", "pkg": "steam-installer", "category": "Gaming", "size": "200MB",
     "perms": "network, filesystem, GPU", "pros": "Game store, Proton for Windows games", "cons": "Proprietary",
     "desc": "Game platform with Windows game support"},
    {"name": "RetroArch", "pkg": "retroarch", "category": "Gaming", "size": "50MB",
     "perms": "filesystem, audio, video, input", "pros": "Emulate retro games, free", "cons": "Setup needed",
     "desc": "Retro game emulator (NES, SNES, etc.)"},
]

CATEGORIES = ["Office", "Graphics", "Internet", "Media", "Developer",
              "System", "Security", "Social", "Gaming"]

def list_apps(category=None):
    """List apps in the store, optionally filtered by category."""
    print(f"\n  {'#':>3s}  {'Name':25s}  {'Category':12s}  {'Size':>8s}  {'Installed'}")
    print("  " + "-" * 75)
    for i, app in enumerate(APP_STORE, 1):
        if category and app["category"] != category:
            continue
        installed = "Yes" if is_installed(app["pkg"].split()[0]) else "No"
        print(f"  {i:>3d}  {app['name']:25s}  {app['category']:12s}  {app['size']:>8s}  {installed}")

def is_installed(pkg):
    """Check if a package is installed."""
    try:
        result = subprocess.run(["dpkg", "-s", pkg], capture_output=True, text=True, timeout=5)
        return result.returncode == 0
    except:
        return False

def show_app_info(app):
    """Show app info — privacy-first: show pros/cons/permissions BEFORE install."""
    print(f"\n  ============================================")
    print(f"  {app['name']}")
    print(f"  ============================================")
    print(f"  Description:  {app['desc']}")
    print(f"  Category:     {app['category']}")
    print(f"  Package:      {app['pkg']}")
    print(f"  Size:         {app['size']}")
    print(f"  Permissions:  {app['perms']}")
    print(f"  Pros:         {app['pros']}")
    print(f"  Cons:         {app['cons']}")
    print(f"  License:      Free / Open Source")
    print(f"  ============================================")

def install_app(app):
    """Install an app — with privacy confirmation."""
    show_app_info(app)
    if is_installed(app["pkg"].split()[0]):
        print(f"  [+] {app['name']} is already installed")
        return
    print(f"\n  This will install: {app['name']}")
    print(f"  It requires: {app['perms']}")
    confirm = input(f"  Install {app['name']}? (yes/no): ").strip()
    if confirm != "yes":
        print("  [-] Installation cancelled")
        return
    print(f"\n  [*] Installing {app['name']}...")
    os.system(f"sudo apt-get update -qq 2>/dev/null")
    result = os.system(f"sudo apt-get install -y {app['pkg']} 2>&1 | tail -5")
    if result == 0:
        print(f"  [+] {app['name']} installed successfully!")
    else:
        print(f"  [-] Installation failed (package may not be in repositories)")

def remove_app(app):
    """Remove an app."""
    if not is_installed(app["pkg"].split()[0]):
        print(f"  [-] {app['name']} is not installed")
        return
    confirm = input(f"  Remove {app['name']}? (yes/no): ").strip()
    if confirm != "yes":
        print("  [-] Cancelled")
        return
    os.system(f"sudo apt-get remove -y {app['pkg']} 2>&1 | tail -3")
    print(f"  [+] {app['name']} removed")

def update_all():
    """Update all installed packages — like apt upgrade."""
    print("\n  [*] Checking for updates...")
    os.system("sudo apt-get update -qq 2>/dev/null")
    print("\n  Upgradable packages:")
    os.system("apt list --upgradable 2>/dev/null | head -20")
    confirm = input("\n  Update all packages? (yes/no): ").strip()
    if confirm == "yes":
        print("\n  [*] Updating all packages...")
        os.system("sudo apt-get upgrade -y 2>&1 | tail -5")
        print("  [+] All packages updated")

def search_apps():
    """Search for apps by name or keyword."""
    query = input("  Search: ").strip().lower()
    results = [a for a in APP_STORE if query in a["name"].lower() or query in a["desc"].lower() or query in a["category"].lower()]
    if results:
        print(f"\n  Found {len(results)} app(s):")
        for i, app in enumerate(results, 1):
            print(f"  {i}. {app['name']} ({app['category']}) — {app['desc']}")
    else:
        print("  No apps found. Try a different keyword.")

def show_installed():
    """Show all installed packages — like dpkg -l."""
    print("\n  --- Installed Packages ---")
    print(f"  {'Name':30s}  {'Version':15s}")
    print("  " + "-" * 50)
    try:
        result = subprocess.run(["dpkg-query", "-W", "-f=${Package}\t${Version}\n"],
                              capture_output=True, text=True, timeout=10)
        count = 0
        for line in result.stdout.split("\n")[:30]:
            parts = line.split("\t")
            if len(parts) >= 2:
                print(f"  {parts[0]:30s}  {parts[1]:15s}")
                count += 1
        print(f"\n  ... showing 30 of {len(result.stdout.split(chr(10)))} packages")
    except:
        print("  Cannot list packages")

def show_store_categories():
    """Browse by category — like app store categories."""
    print("\n  --- App Categories ---")
    for i, cat in enumerate(CATEGORIES, 1):
        count = sum(1 for a in APP_STORE if a["category"] == cat)
        print(f"  {i}. {cat:15s} ({count} apps)")
    c = input("\n  Browse category number: ").strip()
    try:
        cat = CATEGORIES[int(c) - 1]
        list_apps(cat)
    except:
        print("  Invalid category")

def main():
    print("=" * 55)
    print("  Vajra OS App Store & Package Manager")
    print("  Install | Remove | Update | Search")
    print("=" * 55)
    while True:
        print("\n  1. Browse all apps")
        print("  2. Browse by category")
        print("  3. Search apps")
        print("  4. Install an app")
        print("  5. Remove an app")
        print("  6. Update all packages")
        print("  7. Show installed packages")
        print("  8. System info")
        print("  0. Exit")
        c = input("  Choice: ").strip()
        if c == "1":
            list_apps()
            sel = input("\n  Install app number (0=skip): ").strip()
            try:
                if int(sel) > 0:
                    install_app(APP_STORE[int(sel) - 1])
            except:
                pass
        elif c == "2":
            show_store_categories()
        elif c == "3":
            search_apps()
        elif c == "4":
            list_apps()
            sel = input("\n  App number to install: ").strip()
            try:
                install_app(APP_STORE[int(sel) - 1])
            except:
                print("  Invalid selection")
        elif c == "5":
            installed_apps = [a for a in APP_STORE if is_installed(a["pkg"].split()[0])]
            if not installed_apps:
                print("  No store apps installed")
                continue
            print("\n  Installed store apps:")
            for i, app in enumerate(installed_apps, 1):
                print(f"  {i}. {app['name']}")
            sel = input("\n  App number to remove: ").strip()
            try:
                remove_app(installed_apps[int(sel) - 1])
            except:
                print("  Invalid selection")
        elif c == "6":
            update_all()
        elif c == "7":
            show_installed()
        elif c == "8":
            os.system("neofetch 2>/dev/null || uname -a")
        elif c == "0":
            break

if __name__ == "__main__":
    main()
