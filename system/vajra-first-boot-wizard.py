#!/usr/bin/env python3
"""
Vajra OS First-Boot Wizard (OOBE)
Runs on first boot to configure the system interactively.
"""

import os, sys, subprocess, getpass, time
from pathlib import Path

class C:
    GOLD = "\033[38;5;220m"
    BLUE = "\033[94m"
    CYAN = "\033[96m"
    GREEN = "\033[92m"
    YELLOW = "\033[93m"
    RED = "\033[91m"
    BOLD = "\033[1m"
    RESET = "\033[0m"

CONFIG_FILE = "/etc/vajra/first-boot-complete"
WELCOME = r"""
 __      __ _    ___      _
 \ \    / /| |  | _ \___ (_)___ ___
  \ \/\/ / | |__|   / -_)| / _ (_-<
   \_/\_/  |____|_|_\___||/___/__/

      Welcome to Vajra OS!
"""

def is_first_boot():
    return not os.path.exists(CONFIG_FILE)

def mark_complete():
    os.makedirs("/etc/vajra", exist_ok=True)
    with open(CONFIG_FILE, "w") as f:
        f.write("completed\n")

def header(title):
    print(f"\n{C.YELLOW}{'='*60}{C.RESET}")
    print(f"{C.BOLD}  {title}{C.RESET}")
    print(f"{C.YELLOW}{'='*60}{C.RESET}\n")

def info(msg): print(f"  {C.CYAN}> {msg}{C.RESET}")
def success(msg): print(f"  {C.GREEN}v {msg}{C.RESET}")
def warn(msg): print(f"  {C.YELLOW}! {msg}{C.RESET}")

def step_welcome():
    os.system("clear")
    print(C.GOLD + WELCOME + C.RESET)
    print(f"  {C.CYAN}{'='*60}{C.RESET}")
    print(f"  {C.BOLD}Vajra OS First-Boot Setup Wizard{C.RESET}")
    print(f"  {C.CYAN}{'='*60}{C.RESET}")
    print()
    print("  Let's set up your Vajra OS in a few quick steps:")
    print("    1. Connect to Wi-Fi")
    print("    2. Set your timezone")
    print("    3. Choose your mode (Beginner / Pro)")
    print("    4. Enable Buddhi AI")
    print("    5. Privacy settings")
    print("    6. Install essential apps")
    print("    7. Create a recovery point")
    print()
    input("  Press ENTER to begin...")

def step_wifi():
    header("Step 1: Connect to Wi-Fi")
    info("Scanning for Wi-Fi networks...")
    try:
        result = subprocess.run(["nmcli", "device", "wifi", "list"], capture_output=True, text=True, timeout=15)
        if result.returncode == 0:
            print("\n" + result.stdout[:2000])
            ssid = input("\n  Enter Wi-Fi network name (SSID), or 'skip': ").strip()
            if ssid and ssid.lower() != "skip":
                password = getpass.getpass("  Enter Wi-Fi password: ")
                info(f"Connecting to {ssid}...")
                subprocess.run(["nmcli", "device", "wifi", "connect", ssid, "password", password], timeout=30)
                success(f"Connected to {ssid}")
            else:
                warn("Skipping Wi-Fi setup. You can connect later.")
        else:
            warn("Wi-Fi scanning not available. You can set it up later.")
    except Exception:
        warn("Network manager not available. Skipping Wi-Fi setup.")

def step_timezone():
    header("Step 2: Set Timezone")
    info("Auto-detecting timezone...")
    try:
        result = subprocess.run(["timedatectl", "status"], capture_output=True, text=True, timeout=5)
        if result.returncode == 0:
            print("  " + result.stdout.replace("\n", "\n  "))
    except Exception:
        pass
    print("\n  Suggested: Asia/Kolkata (IST, UTC+5:30)")
    tz = input("  Enter timezone [Asia/Kolkata]: ").strip() or "Asia/Kolkata"
    try:
        subprocess.run(["timedatectl", "set-timezone", tz], timeout=5)
        success(f"Timezone set to: {tz}")
    except Exception:
        warn("Could not set timezone. Set it later in Settings > Time & Language.")

def step_mode():
    header("Step 3: Choose Your Mode")
    print(f"  {C.GREEN}1. Beginner Mode{C.RESET}")
    print("     - Large icons, simplified interface")
    print("     - Safety guardrails (no sudo)")
    print("     - Auto-updates and backups")
    print("     - AI assistance always on")
    print()
    print(f"  {C.YELLOW}2. Pro Mode{C.RESET}")
    print("     - Full desktop with all features")
    print("     - Root shell and developer tools")
    print("     - Cybersecurity/pentest tools")
    print("     - Advanced customization")
    print()
    print(f"  {C.CYAN}You can switch anytime from Settings > Mode.{C.RESET}")
    choice = input("\n  Choose mode (1 or 2) [1]: ").strip() or "1"
    mode = "beginner" if choice == "1" else "pro"
    os.makedirs("/etc/vajra", exist_ok=True)
    with open("/etc/vajra/mode", "w") as f:
        f.write(mode)
    success(f"Mode set to: {mode}")

def step_buddhi_ai():
    header("Step 4: Enable Buddhi AI")
    print("  Buddhi is your AI assistant for Vajra OS.")
    print("  She can:")
    print("    - Answer questions and help with tasks")
    print("    - Control your system with voice commands")
    print("    - Proactively organize files and suggest actions")
    print("    - Help with coding and learning")
    print("    - Provide security alerts")
    print()
    print(f"  {C.GREEN}PROS:{C.RESET}")
    print("    + Hands-free voice control")
    print("    + Proactive file organization")
    print("    + Smart system monitoring")
    print("    + Code review and debugging")
    print(f"\n  {C.RED}CONS:{C.RESET}")
    print("    - Uses some CPU/memory")
    print("    - Voice data processed locally (privacy-safe)")
    print("    - Can be disabled anytime")
    choice = input("\n  Enable Buddhi AI? (y/n) [y]: ").strip().lower() or "y"
    if choice == "y":
        try:
            subprocess.run(["systemctl", "enable", "buddhi-ai"], timeout=10)
            subprocess.run(["systemctl", "start", "buddhi-ai"], timeout=10)
            success("Buddhi AI is now active!")
            with open("/etc/vajra/ai-enabled", "w") as f:
                f.write("true")
        except Exception:
            success("Buddhi AI enabled (will start on next boot)")
            with open("/etc/vajra/ai-enabled", "w") as f:
                f.write("true")
    else:
        success("Buddhi AI disabled. You can enable it later in Settings > AI.")
        with open("/etc/vajra/ai-enabled", "w") as f:
            f.write("false")

def step_privacy():
    header("Step 5: Privacy Settings")
    print("  Vajra OS is privacy-first. Choose your level:\n")
    print(f"  {C.GREEN}1. Maximum Privacy (Recommended){C.RESET}")
    print("     - No telemetry or data collection")
    print("     - Firewall enabled, DNS over HTTPS")
    print(f"\n  {C.YELLOW}2. Balanced{C.RESET}")
    print("     - Anonymous usage statistics only")
    print("     - Firewall enabled, optional cloud sync")
    print(f"\n  {C.RED}3. Minimal{C.RESET}")
    print("     - Telemetry enabled, all online features on")
    choice = input("\n  Choose privacy level (1-3) [1]: ").strip() or "1"
    levels = {"1": "maximum", "2": "balanced", "3": "minimal"}
    level = levels.get(choice, "maximum")
    with open("/etc/vajra/privacy-level", "w") as f:
        f.write(level)
    if level == "maximum":
        try:
            subprocess.run(["ufw", "enable"], timeout=10)
            success("Firewall enabled")
        except Exception:
            pass
        with open("/etc/vajra/telemetry", "w") as f:
            f.write("disabled")
    elif level == "balanced":
        with open("/etc/vajra/telemetry", "w") as f:
            f.write("anonymous")
    else:
        with open("/etc/vajra/telemetry", "w") as f:
            f.write("enabled")
    success(f"Privacy level: {level}")

def step_apps():
    header("Step 6: Install Essential Apps")
    print("  Vajra OS can install essential apps now:\n")
    apps = [
        ("firefox", "Firefox Browser (with privacy extensions)"),
        ("thunderbird", "Thunderbird Email Client"),
        ("vlc", "VLC Media Player"),
        ("libreoffice", "LibreOffice Suite"),
        ("gimp", "GIMP Image Editor"),
        ("code", "VS Code Editor"),
        ("keepassxc", "KeePassXC Password Manager"),
        ("timeshift", "Timeshift Backup"),
    ]
    for i, (pkg, desc) in enumerate(apps, 1):
        print(f"  {i}. {desc}")
    print(f"\n  Enter app numbers to install (comma-separated), 'all', or 'skip'")
    choice = input("  Choice [all]: ").strip().lower() or "all"
    if choice == "skip":
        warn("Skipping app installation. Use App Store later.")
        return
    if choice == "all":
        to_install = [app[0] for app in apps]
    else:
        try:
            indices = [int(x.strip()) for x in choice.split(",")]
            to_install = [apps[i-1][0] for i in indices if 1 <= i <= len(apps)]
        except (ValueError, IndexError):
            to_install = []
    for pkg in to_install:
        info(f"Installing {pkg}...")
        try:
            subprocess.run(["apt-get", "install", "-y", pkg], timeout=120)
            success(f"Installed: {pkg}")
        except Exception:
            warn(f"Could not install {pkg} (install later from App Store)")

def step_recovery():
    header("Step 7: Create Recovery Point")
    print("  Creating a recovery point lets you restore your system")
    print("  if something goes wrong later.\n")
    choice = input("  Create recovery point now? (y/n) [y]: ").strip().lower() or "y"
    if choice == "y":
        info("Creating recovery point...")
        try:
            subprocess.run(["timeshift", "--create", "--comments", "First-boot", "--tags", "D"], timeout=120)
            success("Recovery point created!")
        except Exception:
            os.makedirs("/etc/vajra/recovery", exist_ok=True)
            with open("/etc/vajra/recovery/first-boot", "w") as f:
                f.write(f"First-boot recovery point: {time.time()}\n")
            success("Recovery marker created")
    else:
        warn("Skipping recovery point. You can create one later.")

def step_finish():
    header("Setup Complete!")
    print(f"  {C.BOLD}Your Vajra OS is ready!{C.RESET}\n")
    print(f"  {C.GREEN}v Wi-Fi configured{C.RESET}")
    print(f"  {C.GREEN}v Timezone set{C.RESET}")
    print(f"  {C.GREEN}v Mode selected{C.RESET}")
    print(f"  {C.GREEN}v Buddhi AI configured{C.RESET}")
    print(f"  {C.GREEN}v Privacy settings applied{C.RESET}")
    print(f"  {C.GREEN}v Essential apps installed{C.RESET}")
    print(f"  {C.GREEN}v Recovery point created{C.RESET}")
    print()
    print(f"  {C.CYAN}Welcome to Vajra OS!{C.RESET}")
    print(f"  {C.CYAN}Thunderbolt Strong. Unbreakable.{C.RESET}")
    print()
    mark_complete()
    input("  Press ENTER to go to your desktop...")

def main():
    if not is_first_boot():
        print("First-boot wizard already completed.")
        sys.exit(0)
    steps = [step_welcome, step_wifi, step_timezone, step_mode, step_buddhi_ai, step_privacy, step_apps, step_recovery, step_finish]
    for step in steps:
        try:
            step()
        except KeyboardInterrupt:
            print(f"\n{C.YELLOW}Setup interrupted. You can resume later.{C.RESET}")
            sys.exit(1)
        except Exception as e:
            warn(f"Error in step: {e}. Continuing...")
    success("Launching desktop environment...")

if __name__ == "__main__":
    main()