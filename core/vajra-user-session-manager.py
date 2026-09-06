#!/usr/bin/env python3
"""Vajra OS User & Session Manager — login, accounts, PAM, sessions, groups.
Like Windows User Accounts / Linux login+passwd+PAM+loginctl.
This is the fundamental user/session management layer of the OS."""
import os
import sys
import subprocess
import time
from pathlib import Path

SESSION_LOG = Path("/var/log/vajra/sessions.log")
SESSION_LOG.parent.mkdir(parents=True, exist_ok=True)

def log_session(event, user="", details=""):
    with open(SESSION_LOG, "a") as f:
        f.write(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {event} user={user} {details}\n")

def show_users():
    """Show all user accounts — like passwd listing."""
    print("\n  --- User Accounts ---")
    print(f"  {'Username':15s}  {'UID':>6s}  {'GID':>6s}  {'Home':20s}  {'Shell':15s}")
    print("  " + "-" * 70)
    try:
        with open("/etc/passwd") as f:
            for line in f:
                parts = line.strip().split(":")
                if len(parts) >= 7:
                    username, _, uid, gid, _, home, shell = parts[:7]
                    if int(uid) >= 1000 and int(uid) < 65534:
                        print(f"  {username:15s}  {uid:>6s}  {gid:>6s}  {home:20s}  {shell:15s}")
    except:
        pass

def show_current_session():
    """Show current session info — like whoami + loginctl."""
    print("\n  --- Current Session ---")
    print(f"  Current user: {os.environ.get('USER', 'unknown')}")
    print(f"  UID: {os.getuid()}")
    print(f"  GID: {os.getgid()}")
    print(f"  Home: {os.environ.get('HOME', 'N/A')}")
    print(f"  Shell: {os.environ.get('SHELL', 'N/A')}")
    print(f"  Display: {os.environ.get('DISPLAY', os.environ.get('WAYLAND_DISPLAY', 'TTY'))}")
    print(f"  Terminal: {os.environ.get('TERM', 'N/A')}")
    print(f"  Session type: ", end="")
    os.system("echo $XDG_SESSION_TYPE 2>/dev/null || echo 'tty'")
    print(f"  Groups: ", end="")
    os.system(f"groups {os.environ.get('USER', '')} 2>/dev/null")

def show_active_sessions():
    """Show all active login sessions — like loginctl list-sessions."""
    print("\n  --- Active Sessions ---")
    try:
        result = subprocess.run(["loginctl", "list-sessions", "--no-pager"],
                              capture_output=True, text=True, timeout=5)
        for line in result.stdout.split("\n"):
            if line.strip():
                print(f"  {line}")
    except:
        # Fallback to 'who'
        os.system("who 2>/dev/null")

def show_groups():
    """Show all groups and their members."""
    print("\n  --- Groups ---")
    print(f"  {'Group':15s}  {'GID':>6s}  {'Members'}")
    print("  " + "-" * 50)
    try:
        with open("/etc/group") as f:
            for line in f:
                parts = line.strip().split(":")
                if len(parts) >= 4:
                    name, _, gid, members = parts[0], parts[1], parts[2], parts[3]
                    print(f"  {name:15s}  {gid:>6s}  {members}")
    except:
        pass

def add_user():
    """Add a new user account."""
    print("\n  --- Add User ---")
    username = input("  Username: ").strip()
    if not username:
        return
    full_name = input("  Full name (optional): ").strip()
    shell = input("  Shell [/bin/bash]: ").strip() or "/bin/bash"
    sudo_access = input("  Give sudo (admin) access? (yes/no) [no]: ").strip() or "no"

    cmd = f"sudo useradd -m -s {shell}"
    if full_name:
        cmd += f" -c '{full_name}'"
    cmd += f" {username}"
    os.system(cmd)
    os.system(f"sudo passwd {username}")
    if sudo_access == "yes":
        os.system(f"sudo usermod -aG sudo {username}")
        print(f"  [+] User {username} created with sudo access")
    else:
        print(f"  [+] User {username} created (no sudo)")
    log_session("User created", username)

def remove_user():
    """Remove a user account."""
    print("\n  --- Remove User ---")
    username = input("  Username to remove: ").strip()
    if not username:
        return
    confirm = input(f"  Remove {username} and their home directory? (yes/no): ").strip()
    if confirm == "yes":
        os.system(f"sudo userdel -r {username}")
        print(f"  [+] User {username} removed")
        log_session("User removed", username)
    else:
        print("  [-] Cancelled")

def change_password():
    """Change a user's password."""
    username = input("  Username: ").strip()
    if username:
        os.system(f"sudo passwd {username}")
        print(f"  [+] Password changed for {username}")
        log_session("Password changed", username)

def manage_groups():
    """Group management — create, delete, add/remove users."""
    print("\n  --- Group Management ---")
    print("  1. Create group")
    print("  2. Delete group")
    print("  3. Add user to group")
    print("  4. Remove user from group")
    c = input("  Choice: ").strip()
    if c == "1":
        name = input("  Group name: ").strip()
        if name:
            os.system(f"sudo groupadd {name}")
            print(f"  [+] Group {name} created")
    elif c == "2":
        name = input("  Group name: ").strip()
        if name:
            os.system(f"sudo groupdel {name}")
            print(f"  [+] Group {name} deleted")
    elif c == "3":
        user = input("  Username: ").strip()
        group = input("  Group: ").strip()
        if user and group:
            os.system(f"sudo usermod -aG {group} {user}")
            print(f"  [+] {user} added to {group}")
    elif c == "4":
        user = input("  Username: ").strip()
        group = input("  Group: ").strip()
        if user and group:
            os.system(f"sudo gpasswd -d {user} {group}")
            print(f"  [+] {user} removed from {group}")

def show_login_history():
    """Show login history — like last command."""
    print("\n  --- Login History ---")
    os.system("last -20 2>/dev/null || echo 'No login history'")

def show_failed_logins():
    """Show failed login attempts — security audit."""
    print("\n  --- Failed Login Attempts ---")
    os.system("sudo lastb -10 2>/dev/null || echo 'No failed login records'")
    os.system("sudo grep 'Failed password' /var/log/auth.log 2>/dev/null | tail -10 || journalctl -t sshd -n 10 2>/dev/null")

def lock_screen():
    """Lock the screen — like Windows Lock / Linux loginctl lock."""
    print("\n  [*] Locking screen...")
    if os.environ.get("WAYLAND_DISPLAY") or os.environ.get("DISPLAY"):
        os.system("gnome-screensaver-command --lock 2>/dev/null || "
                  "xdg-screensaver lock 2>/dev/null || "
                  "loginctl lock-session 2>/dev/null || "
                  "echo 'Press Ctrl+L in your terminal'")
    else:
        os.system("vlock 2>/dev/null || echo 'Install vlock for TTY lock'")

def switch_user():
    """Switch user — like Windows Fast User Switching."""
    print("\n  [*] Switching user...")
    os.system("dm-tool switch-to-greeter 2>/dev/null || "
              "loginctl lock-session 2>/dev/null || "
              "echo 'Use Ctrl+Alt+F2-F6 to switch TTY'")

def show_password_policy():
    """Show password policy and aging."""
    print("\n  --- Password Policy ---")
    username = input(f"  Username [{os.environ.get('USER', '')}]: ").strip() or os.environ.get("USER", "")
    if username:
        os.system(f"sudo chage -l {username} 2>/dev/null")

def session_log_viewer():
    """View session log."""
    print("\n  --- Session Log ---")
    if SESSION_LOG.exists():
        lines = SESSION_LOG.read_text().strip().split("\n")
        for line in lines[-20:]:
            print(f"  {line}")
    else:
        print("  No session log entries yet")

def main():
    print("=" * 55)
    print("  Vajra OS User & Session Manager")
    print("  Users | Groups | Sessions | Login | PAM")
    print("=" * 55)
    while True:
        print("\n  1. List users")
        print("  2. Current session")
        print("  3. Active sessions")
        print("  4. Groups")
        print("  5. Add user")
        print("  6. Remove user")
        print("  7. Change password")
        print("  8. Manage groups")
        print("  9. Login history")
        print("  10. Failed logins")
        print("  11. Lock screen")
        print("  12. Switch user")
        print("  13. Password policy")
        print("  14. Session log")
        print("  0. Exit")
        c = input("  Choice: ").strip()
        if c == "1": show_users()
        elif c == "2": show_current_session()
        elif c == "3": show_active_sessions()
        elif c == "4": show_groups()
        elif c == "5": add_user()
        elif c == "6": remove_user()
        elif c == "7": change_password()
        elif c == "8": manage_groups()
        elif c == "9": show_login_history()
        elif c == "10": show_failed_logins()
        elif c == "11": lock_screen()
        elif c == "12": switch_user()
        elif c == "13": show_password_policy()
        elif c == "14": session_log_viewer()
        elif c == "0": break

if __name__ == "__main__":
    main()
