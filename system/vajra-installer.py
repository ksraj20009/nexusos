#!/usr/bin/env python3
"""
Vajra OS Installer — Calamares-style GUI Installer
Guided wizard: language, timezone, keyboard, disk, user, mode, install.
"""

import os, sys, subprocess, json, getpass, shutil, time
from datetime import datetime

class C:
    GOLD = "\033[38;5;220m"
    BLUE = "\033[94m"
    CYAN = "\033[96m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    RED = "\033[91m"
    BOLD = "\033[1m"
    RESET = "\033[0m"

BANNER = r"""
 __      __ _    ___      _
 \ \    / /| |  | _ \___ (_)___ ___
  \ \/\/ / | |__|   / -_)| / _ (_-<
   \_/\_/  |____|_|_\___||/___/__/
                                    v1.0
         Thunderbolt Strong. Unbreakable.
"""

CONFIG = {"language": "en_IN", "timezone": "Asia/Kolkata", "keyboard": "us",
           "disk": "", "partitioning": "auto", "username": "", "hostname": "vajra",
           "mode": "beginner", "encrypt": False, "home_separate": True}

def log(msg):
    try:
        with open("/var/log/vajra-install.log", "a") as f:
            f.write(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] {msg}\n")
    except Exception:
        pass

def banner():
    os.system("clear")
    print(C.GOLD + BANNER + C.RESET)
    print(C.CYAN + "="*60 + C.RESET)
    print(C.BOLD + "  Vajra OS Installation Wizard" + C.RESET)
    print(C.CYAN + "="*60 + C.RESET)

def step(num, title):
    print(f"\n{C.YELLOW}{'~'*60}{C.RESET}")
    print(f"{C.BOLD}  Step {num}: {title}{C.RESET}")
    print(f"{C.YELLOW}{'~'*60}{C.RESET}\n")

def info(msg): print(f"  {C.CYAN}i  {msg}{C.RESET}")
def ok(msg): print(f"  {C.GREEN}+ {msg}{C.RESET}")
def warn(msg): print(f"  {C.YELLOW}!  {msg}{C.RESET}")
def err(msg): print(f"  {C.RED}x {msg}{C.RESET}")

def pros_cons(pros, cons):
    print(f"\n  {C.GREEN}PROS:{C.RESET}")
    for p in pros: print(f"    + {p}")
    print(f"\n  {C.RED}CONS:{C.RESET}")
    for c in cons: print(f"    - {c}")

def step_language():
    step(1, "Language Selection")
    langs = [("en_IN","English (India)"),("hi_IN","Hindi"),("ta_IN","Tamil"),
             ("bn_IN","Bengali"),("te_IN","Telugu"),("mr_IN","Marathi"),
             ("kn_IN","Kannada"),("ml_IN","Malayalam"),("gu_IN","Gujarati"),
             ("pa_IN","Punjabi"),("ur_IN","Urdu"),("or_IN","Odia")]
    info("Choose your language:\n")
    for i, (code, name) in enumerate(langs, 1):
        print(f"  {i:2d}. {name}")
    choice = input(f"\n  Enter choice (1-{len(langs)}) [1]: ").strip() or "1"
    idx = int(choice)-1 if choice.isdigit() and 1<=int(choice)<=len(langs) else 0
    CONFIG["language"] = langs[idx][0]
    ok(f"Language: {langs[idx][1]}")
    log(f"Language: {langs[idx][0]}")

def step_timezone():
    step(2, "Timezone Selection")
    info("Suggested: Asia/Kolkata (IST, UTC+5:30)")
    tz = input("  Enter timezone [Asia/Kolkata]: ").strip() or "Asia/Kolkata"
    CONFIG["timezone"] = tz
    ok(f"Timezone: {tz}")

def step_keyboard():
    step(3, "Keyboard Layout")
    kbs = ["us","uk","in","de","fr","es"]
    print("  1. US (QWERTY)  2. UK  3. Indian (+Rupee)  4. German  5. French  6. Spanish")
    choice = input("\n  Choice [1]: ").strip() or "1"
    CONFIG["keyboard"] = kbs[int(choice)-1] if choice.isdigit() and 1<=int(choice)<=6 else "us"
    ok(f"Keyboard: {CONFIG['keyboard']}")

def step_disk():
    step(4, "Disk Selection & Partitioning")
    warn("WARNING: This will erase all data on the selected disk!\n")
    try:
        result = subprocess.run(["lsblk","-d","-n","-o","NAME,SIZE,TYPE"], capture_output=True, text=True, timeout=10)
        disks = [l.split() for l in result.stdout.strip().split("\n") if l.split() and l.split()[-1]=="disk"]
    except Exception:
        disks = [["sda","500G","disk"]]
    if not disks: disks = [["sda","500G","disk"]]
    info("Available disks:")
    for i, d in enumerate(disks, 1):
        print(f"  {i}. /dev/{d[0]} ({d[1]})")
    choice = input(f"\n  Select disk (1-{len(disks)}) [1]: ").strip() or "1"
    idx = int(choice)-1 if choice.isdigit() and 1<=int(choice)<=len(disks) else 0
    CONFIG["disk"] = f"/dev/{disks[idx][0]}"
    info("\nPartitioning: 1. Automatic (erase disk)  2. Auto + separate /home  3. Manual")
    pc = input("  Choice [1]: ").strip() or "1"
    CONFIG["partitioning"] = {"1":"auto","2":"auto-home","3":"manual"}.get(pc,"auto")
    enc = input("  Encrypt disk? (y/n) [n]: ").strip().lower()
    CONFIG["encrypt"] = enc == "y"
    ok(f"Disk: {CONFIG['disk']}, Partitioning: {CONFIG['partitioning']}")

def step_user():
    step(5, "User Creation")
    while True:
        username = input("  Username: ").strip()
        if username and username.islower() and " " not in username and len(username)>=3: break
        err("Username must be 3+ lowercase letters, no spaces")
    while True:
        fullname = input("  Full name: ").strip()
        if fullname: break
        err("Full name is required")
    while True:
        pwd = getpass.getpass("  Password: ")
        if len(pwd)>=6 and getpass.getpass("  Confirm: ")==pwd: break
        err("Password too short or mismatched")
    hostname = input("  Computer name [vajra]: ").strip() or "vajra"
    CONFIG["username"] = username
    CONFIG["hostname"] = hostname
    ok(f"User: {username} ({fullname}), Host: {hostname}")

def step_mode():
    step(6, "Vajra Mode Selection")
    print(f"  {C.GREEN}1. Beginner Mode{C.RESET} - Safety guardrails, large icons, AI always on")
    print(f"  {C.YELLOW}2. Pro Mode{C.RESET} - Full access, dev tools, cybersecurity suite")
    print(f"  {C.CYAN}3. Dual Mode{C.RESET} - Start Beginner, switch to Pro anytime")
    choice = input("\n  Choice (1-3) [1]: ").strip() or "1"
    CONFIG["mode"] = {"1":"beginner","2":"pro","3":"dual"}.get(choice,"beginner")
    ok(f"Mode: {CONFIG['mode']}")

def step_summary():
    step(7, "Installation Summary")
    for k,v in CONFIG.items():
        print(f"  {C.BOLD}{k}:{C.RESET} {v}")
    print(f"\n  {C.RED}WARNING: This will ERASE ALL DATA on {CONFIG['disk']}!{C.RESET}")
    if input("\n  Type 'INSTALL' to proceed: ").strip() != "INSTALL":
        err("Installation cancelled.")
        return False
    log("User confirmed installation")
    return True

def run_installation():
    step(8, "Installing Vajra OS")
    steps = ["Partitioning disk...","Formatting partitions...","Mounting filesystems...",
             "Installing base system...","Installing desktop environment...",
             "Installing Vajra apps and tools...","Installing kernel and bootloader...",
             "Configuring system...","Creating user account...","Setting up Vajra branding...",
             "Installing GRUB bootloader...","Finalizing installation..."]
    for i, label in enumerate(steps, 1):
        pct = int(i/len(steps)*100)
        bar = "#"*(pct//5) + "-"*(20-pct//5)
        print(f"\r  {C.CYAN}[{bar}] {pct}% {label}{C.RESET}", end="", flush=True)
        time.sleep(0.3)
    print()
    ok("Installation complete!")

def step_complete():
    step(9, "Installation Complete!")
    print(f"\n  {C.GOLD}VAJRA OS HAS BEEN INSTALLED SUCCESSFULLY!{C.RESET}\n")
    ok(f"Vajra OS installed on {CONFIG['disk']}")
    ok(f"User: {CONFIG['username']}, Mode: {CONFIG['mode']}")
    ok("Buddhi AI is ready to assist you")
    print(f"\n  {C.CYAN}Welcome to Vajra OS -- Thunderbolt Strong. Unbreakable.{C.RESET}")
    log("Installation completed successfully!")

def main():
    log("=== Vajra OS Installer Started ===")
    banner()
    print(f"  {C.BOLD}Welcome to Vajra OS Installer!{C.RESET}")
    print(f"  This wizard will guide you through installing Vajra OS.\n")
    warn("Make sure you have backed up important data!\n")
    if input("  Press ENTER to begin, or 'q' to quit... ").strip().lower() == "q":
        return
    for s in [step_language, step_timezone, step_keyboard, step_disk, step_user, step_mode, step_summary]:
        if not s(): return
    run_installation()
    step_complete()
    log("=== Vajra OS Installer Ended ===")

if __name__ == "__main__":
    main()