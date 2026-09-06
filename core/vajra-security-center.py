#!/usr/bin/env python3
"""Vajra OS Security Core — firewall, permissions, encryption, access control, audit.
Like Windows Security Center / Linux PAM+AppArmor+UFW+auditd.
This is the fundamental security layer of the OS."""
import os
import sys
import subprocess
import time
from pathlib import Path

AUDIT_LOG = Path("/var/log/vajra/security-audit.log")
AUDIT_LOG.parent.mkdir(parents=True, exist_ok=True)

def log_audit(event, details=""):
    """Log a security audit event."""
    with open(AUDIT_LOG, "a") as f:
        f.write(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {event}: {details}\n")

def security_dashboard():
    """Security overview — like Windows Security Center dashboard."""
    print("\n  ============================================")
    print("  Vajra OS Security Dashboard")
    print("  ============================================")
    # Firewall
    fw = os.system("ufw status 2>/dev/null | grep -q 'Status: active'") == 0
    print(f"  Firewall:           {'PROTECTED' if fw else 'WARNING: OFF'}")

    # AppArmor
    aa = os.path.exists("/sys/kernel/security/apparmor")
    print(f"  AppArmor (MAC):     {'ACTIVE' if aa else 'INACTIVE'}")

    # Secure Boot
    sb = os.path.isdir("/sys/firmware/efi")
    print(f"  Secure Boot:        {'UEFI mode' if sb else 'Legacy BIOS'}")

    # Disk encryption
    enc = os.system("lsblk -o FSTYPE 2>/dev/null | grep -q crypt") == 0
    print(f"  Disk Encryption:    {'ENCRYPTED' if enc else 'Not encrypted'}")

    # SSH
    ssh = os.system("systemctl is-active sshd 2>/dev/null | grep -q active") == 0
    print(f"  SSH Server:         {'RUNNING' if ssh else 'Off'}")

    # Fail2ban
    f2b = os.system("systemctl is-active fail2ban 2>/dev/null | grep -q active") == 0
    print(f"  Intrusion Detect:   {'ACTIVE (fail2ban)' if f2b else 'OFF'}")

    # Antivirus
    av = os.system("command -v clamscan &>/dev/null") == 0
    print(f"  Antivirus (ClamAV): {'INSTALLED' if av else 'Not installed'}")

    # Tor
    tor = os.system("systemctl is-active tor 2>/dev/null | grep -q active") == 0
    print(f"  Tor (anonymity):    {'ENABLED' if tor else 'Disabled'}")

    # Password policy
    print(f"  Password policy:    Check with 'chage -l'")

    # Last login
    print(f"  Last login:")
    os.system("last -3 2>/dev/null | head -3")

    # Calculate score
    score = sum([fw, aa, f2b, av]) * 20 + (10 if sb else 0) + (10 if enc else 0)
    print(f"\n  Security Score: {score}/100")
    if score >= 80:
        print("  Status: WELL PROTECTED")
    elif score >= 50:
        print("  Status: MODERATE — consider enabling more protections")
    else:
        print("  Status: AT RISK — enable firewall and fail2ban!")
    print("  ============================================")
    log_audit("Dashboard viewed", f"Score: {score}")

def firewall_manager():
    """Firewall management — like UFW/iptables front-end."""
    print("\n  --- Firewall Manager ---")
    os.system("sudo ufw status verbose 2>/dev/null || echo 'UFW not installed'")
    print("\n  1. Enable firewall")
    print("  2. Disable firewall")
    print("  3. Allow port")
    print("  4. Deny port")
    print("  5. Allow service")
    print("  6. Reset firewall")
    print("  7. Show rules")
    c = input("  Choice: ").strip()
    if c == "1":
        os.system("sudo ufw --force enable && sudo ufw default deny incoming && sudo ufw default allow outgoing")
        print("  [+] Firewall enabled (deny incoming, allow outgoing)")
        log_audit("Firewall enabled")
    elif c == "2":
        os.system("sudo ufw disable")
        print("  [+] Firewall disabled")
        log_audit("Firewall disabled")
    elif c == "3":
        port = input("  Port number: ").strip()
        proto = input("  Protocol (tcp/udp/both) [tcp]: ").strip() or "tcp"
        if proto == "both":
            os.system(f"sudo ufw allow {port}/tcp && sudo ufw allow {port}/udp")
        else:
            os.system(f"sudo ufw allow {port}/{proto}")
        print(f"  [+] Port {port}/{proto} allowed")
        log_audit("Port allowed", f"{port}/{proto}")
    elif c == "4":
        port = input("  Port number: ").strip()
        os.system(f"sudo ufw deny {port}")
        print(f"  [+] Port {port} denied")
        log_audit("Port denied", port)
    elif c == "5":
        print("  Services: ssh, http, https, ftp, samba, vnc")
        svc = input("  Service name: ").strip()
        os.system(f"sudo ufw allow {svc}")
        print(f"  [+] Service {svc} allowed")
    elif c == "6":
        confirm = input("  Reset all firewall rules? (yes/no): ").strip()
        if confirm == "yes":
            os.system("sudo ufw --force reset")
            print("  [+] Firewall reset")
            log_audit("Firewall reset")
    elif c == "7":
        os.system("sudo ufw status numbered")

def manage_permissions():
    """File permission management — POSIX permissions."""
    print("\n  --- Permission Manager ---")
    path = input("  File/directory: ").strip()
    if not os.path.exists(path):
        print("  [-] Path not found")
        return
    os.system(f"ls -la {path}")
    print("\n  1. Set permissions (octal)")
    print("  2. Set owner")
    print("  3. Set group")
    print("  4. Make executable")
    print("  5. Make read-only")
    print("  6. Recursive chmod")
    c = input("  Choice: ").strip()
    if c == "1":
        perm = input("  Octal (e.g. 755): ").strip()
        os.system(f"chmod {perm} {path}")
        print(f"  [+] Permissions: {perm}")
    elif c == "2":
        owner = input("  Owner: ").strip()
        os.system(f"sudo chown {owner} {path}")
        print(f"  [+] Owner: {owner}")
    elif c == "3":
        group = input("  Group: ").strip()
        os.system(f"sudo chgrp {group} {path}")
        print(f"  [+] Group: {group}")
    elif c == "4":
        os.system(f"chmod +x {path}")
        print("  [+] Executable")
    elif c == "5":
        os.system(f"chmod a-w {path}")
        print("  [+] Read-only")
    elif c == "6":
        perm = input("  Octal: ").strip()
        os.system(f"chmod -R {perm} {path}")
        print(f"  [+] Recursive: {perm}")

def manage_encryption():
    """Disk/file encryption — LUKS, eCryptfs, GPG."""
    print("\n  --- Encryption Manager ---")
    print("  1. Encrypt a file (GPG)")
    print("  2. Decrypt a file (GPG)")
    print("  3. Create encrypted directory (eCryptfs)")
    print("  4. Check disk encryption status (LUKS)")
    print("  5. Generate GPG key pair")
    c = input("  Choice: ").strip()
    if c == "1":
        f = input("  File to encrypt: ").strip()
        os.system(f"gpg -c {f}")
        print(f"  [+] Encrypted: {f}.gpg")
        log_audit("File encrypted", f)
    elif c == "2":
        f = input("  File to decrypt: ").strip()
        os.system(f"gpg -d {f} > {f.replace('.gpg', '')}")
        print(f"  [+] Decrypted: {f.replace('.gpg', '')}")
    elif c == "3":
        d = input("  Directory: ").strip()
        os.system(f"sudo ecryptfs-setup-private -- {d} 2>/dev/null || echo 'Install ecryptfs-utils'")
    elif c == "4":
        os.system("lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT 2>/dev/null | grep -E 'crypt|NAME'")
        os.system("sudo cryptsetup status 2>/dev/null || echo 'No LUKS devices'")
    elif c == "5":
        os.system("gpg --gen-key")
        print("  [+] GPG key pair generated")
        log_audit("GPG key generated")

def access_control():
    """Access control — PAM, sudo, AppArmor profiles."""
    print("\n  --- Access Control ---")
    print("  1. View sudo users")
    print("  2. View AppArmor profiles")
    print("  3. View PAM configuration")
    print("  4. Sudo log")
    print("  5. Failed login attempts")
    c = input("  Choice: ").strip()
    if c == "1":
        os.system("getent group sudo")
    elif c == "2":
        os.system("sudo apparmor_status 2>/dev/null || aa-status 2>/dev/null || echo 'AppArmor not installed'")
    elif c == "3":
        os.system("cat /etc/pam.d/common-auth 2>/dev/null | head -20")
    elif c == "4":
        os.system("sudo grep sudo /var/log/auth.log 2>/dev/null | tail -10 || journalctl -t sudo -n 10 2>/dev/null")
    elif c == "5":
        os.system("sudo grep 'Failed password' /var/log/auth.log 2>/dev/null | tail -10 || journalctl -t sshd -n 10 2>/dev/null")
        log_audit("Failed logins checked")

def audit_log_viewer():
    """View security audit log."""
    print("\n  --- Security Audit Log ---")
    if AUDIT_LOG.exists():
        lines = AUDIT_LOG.read_text().strip().split("\n")
        for line in lines[-30:]:
            print(f"  {line}")
        if len(lines) > 30:
            print(f"  ... showing last 30 of {len(lines)} entries")
    else:
        print("  No audit log entries yet")

def run_antivirus_scan():
    """Run ClamAV antivirus scan."""
    print("\n  --- Antivirus Scan ---")
    if os.system("command -v clamscan &>/dev/null") != 0:
        print("  ClamAV not installed. Install: sudo apt install clamav")
        return
    path = input("  Path to scan [.]: ").strip() or "."
    print(f"  [*] Scanning {path} (this may take a while)...")
    os.system(f"clamscan -r --infected {path} 2>&1 | tail -10")
    log_audit("Antivirus scan", path)

def main():
    print("=" * 55)
    print("  Vajra OS Security Center")
    print("  Firewall | Permissions | Encryption | Audit")
    print("=" * 55)
    while True:
        print("\n  1. Security dashboard")
        print("  2. Firewall manager")
        print("  3. Permission manager")
        print("  4. Encryption manager")
        print("  5. Access control (PAM/sudo/AppArmor)")
        print("  6. Audit log")
        print("  7. Antivirus scan")
        print("  8. Security hardening (one-click)")
        print("  0. Exit")
        c = input("  Choice: ").strip()
        if c == "1": security_dashboard()
        elif c == "2": firewall_manager()
        elif c == "3": manage_permissions()
        elif c == "4": manage_encryption()
        elif c == "5": access_control()
        elif c == "6": audit_log_viewer()
        elif c == "7": run_antivirus_scan()
        elif c == "8":
            print("\n  [*] Running one-click security hardening...")
            os.system("sudo ufw --force enable 2>/dev/null")
            os.system("sudo ufw default deny incoming 2>/dev/null")
            os.system("sudo ufw default allow outgoing 2>/dev/null")
            os.system("sudo systemctl enable fail2ban 2>/dev/null && sudo systemctl start fail2ban 2>/dev/null")
            os.system("sudo systemctl enable apparmor 2>/dev/null && sudo systemctl start apparmor 2>/dev/null")
            print("  [+] Firewall enabled, fail2ban started, AppArmor started")
            log_audit("One-click hardening applied")
        elif c == "0": break

if __name__ == "__main__":
    main()
