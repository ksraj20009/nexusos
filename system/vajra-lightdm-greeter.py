#!/usr/bin/env python3
"""
Vajra OS LightDM Greeter — Login Screen
Custom login screen for Vajra OS with branding.
"""

import os
import sys
import subprocess
import time
import getpass
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

LOGO = r"""
 __      __ _    ___      _
 \ \    / /| |  | _ \___ (_)___ ___
  \ \/\/ / | |__|   / -_)| / _ (_-<
   \_/\_/  |____|_|_\___||/___/__/
"""

def get_users():
    """Get list of login users."""
    users = []
    try:
        with open("/etc/passwd") as f:
            for line in f:
                parts = line.strip().split(":")
                if len(parts) >= 7:
                    username = parts[0]
                    uid = int(parts[2])
                    shell = parts[6]
                    home = parts[5]
                    if uid >= 1000 and "nologin" not in shell and "false" not in shell:
                        users.append((username, home))
    except Exception:
        pass
    return users

def get_hostname():
    """Get system hostname."""
    try:
        with open("/etc/hostname") as f:
            return f.read().strip()
    except Exception:
        return "vajra"

def get_time():
    """Get current time string."""
    return datetime.now().strftime("%A, %d %B %Y  %I:%M %p")

def show_login_screen():
    """Display the Vajra OS login screen."""
    os.system("clear")
    
    # Top bar
    print(f"  {C.CYAN}{'='*60}{C.RESET}")
    print(f"  {C.GOLD}{LOGO}{C.RESET}")
    print(f"  {C.CYAN}{'='*60}{C.RESET}")
    print()
    
    # Clock
    print(f"  {C.BOLD}{get_time()}{C.RESET}")
    print()
    
    hostname = get_hostname()
    print(f"  {C.CYAN}{hostname}{C.RESET}")
    print()
    
    # User list
    users = get_users()
    if users:
        print("  Select user:")
        for i, (user, _) in enumerate(users, 1):
            print(f"    {i}. {user}")
        print(f"    {len(users)+1}. Other...")
        
        choice = input(f"\n  Select (1-{len(users)+1}): ").strip()
        try:
            idx = int(choice) - 1
            if idx < len(users):
                username = users[idx][0]
            else:
                username = input("  Username: ").strip()
        except (ValueError, IndexError):
            username = input("  Username: ").strip()
    else:
        username = input("  Username: ").strip()
    
    password = getpass.getpass("  Password: ")
    
    # Session selection
    sessions = ["vajra-desktop", "vajra-beginner", "vajra-pro", "gnome", "plasma"]
    print(f"\n  Session:")
    print(f"    1. Vajra Desktop (Default)")
    print(f"    2. Vajra Beginner")
    print(f"    3. Vajra Pro")
    print(f"    4. GNOME")
    print(f"    5. KDE Plasma")
    
    session_choice = input("\n  Select session [1]: ").strip() or "1"
    session = sessions[int(session_choice)-1] if session_choice.isdigit() and 1 <= int(session_choice) <= 5 else "vajra-desktop"
    
    # Show boot message
    print(f"\n  {C.CYAN}Welcome to Vajra OS!{C.RESET}")
    print(f"  {C.CYAN}Starting {session}...{C.RESET}")
    
    # In production, authenticate via PAM and start session
    success = authenticate(username, password)
    if success:
        start_session(username, session)
    else:
        print(f"\n  {C.RED}Login failed. Check your credentials.{C.RESET}")
        time.sleep(2)
        show_login_screen()

def authenticate(username, password):
    """Authenticate user (simplified - production would use PAM)."""
    try:
        result = subprocess.run(["getent", "passwd", username],
                                capture_output=True, text=True, timeout=5)
        return result.returncode == 0
    except Exception:
        return False

def start_session(username, session):
    """Start the user's desktop session."""
    print(f"\n  {C.GREEN}Welcome, {username}!{C.RESET}")
    print(f"  {C.CYAN}Loading Vajra Desktop...{C.RESET}")
    
    for i in range(3):
        dots = "." * (i + 1)
        print(f"\r  {C.CYAN}Loading{dots}{C.RESET}", end="", flush=True)
        time.sleep(0.3)
    print()
    print(f"  {C.GREEN}Desktop ready!{C.RESET}")

def main():
    """Entry point for the greeter."""
    os.system("setterm -cursor off")
    try:
        show_login_screen()
    finally:
        os.system("setterm -cursor on")

if __name__ == "__main__":
    main()