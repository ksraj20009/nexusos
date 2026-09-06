#!/usr/bin/env python3
"""Vajra OS Control Center — system settings like Windows Settings / macOS System Preferences.
This is the central configuration hub for the entire OS.
Categories: Display, Network, Sound, Users, Privacy, Security, Power, Language, Time, About."""
import os
import sys
import subprocess
import json
from pathlib import Path

SETTINGS_DIR = Path("/etc/vajra/settings")
SETTINGS_DIR.mkdir(parents=True, exist_ok=True)

def read_setting(key, default=""):
    """Read a setting from the settings file."""
    f = SETTINGS_DIR / "vajra.conf"
    if f.exists():
        try:
            data = json.loads(f.read_text())
            return data.get(key, default)
        except:
            return default
    return default

def write_setting(key, value):
    """Write a setting to the settings file."""
    f = SETTINGS_DIR / "vajra.conf"
    data = {}
    if f.exists():
        try:
            data = json.loads(f.read_text())
        except:
            pass
    data[key] = value
    f.write_text(json.dumps(data, indent=2))

def section_display():
    """Display settings — resolution, brightness, night light, scale."""
    print("\n  --- Display Settings ---")
    print(f"  Current resolution: ", end="")
    os.system("xrandr 2>/dev/null | grep ' connected' | head -1 | awk '{print $3}' || echo 'N/A'")
    print(f"  Display server: {'Wayland' if os.environ.get('WAYLAND_DISPLAY') else 'X11' if os.environ.get('DISPLAY') else 'TTY'}")
    print("\n  1. Set resolution")
    print("  2. Set brightness")
    print("  3. Toggle night light")
    print("  4. Set scale (100/125/150/200%)")
    print("  5. Set refresh rate")
    c = input("  Choice: ").strip()
    if c == "1":
        os.system("xrandr 2>/dev/null | grep -E 'connected|^[0-9]'" )
        os.system("sudo vajra-display 2>/dev/null || echo 'Run vajra-display-server.sh'")
    elif c == "2":
        if os.path.isdir("/sys/class/backlight"):
            for bl in os.listdir("/sys/class/backlight"):
                path = f"/sys/class/backlight/{bl}"
                mx = int(open(f"{path}/max_brightness").read())
                cur = int(open(f"{path}/brightness").read())
                print(f"  Current: {cur*100//mx}%")
                val = input(f"  New brightness (0-{mx}): ").strip()
                if val:
                    os.system(f"echo {val} | sudo tee {path}/brightness")
                    print("  [+] Brightness set")
        else:
            os.system("brightnessctl info 2>/dev/null || echo 'No brightness control'")
    elif c == "3":
        os.system("killall redshift 2>/dev/null; redshift -O 3500 &>/dev/null & echo 'Night light ON'")
    elif c == "4":
        s = input("  Scale (100/125/150/200): ").strip()
        dpi = {"100": 96, "125": 120, "150": 144, "200": 192}.get(s, 96)
        os.system(f"xrandr --dpi {dpi} 2>/dev/null")
        write_setting("display_scale", s)
        print(f"  [+] Scale set to {s}%")

def section_network():
    """Network settings — Wi-Fi, Ethernet, proxy, DNS."""
    print("\n  --- Network Settings ---")
    os.system("ip addr show 2>/dev/null | grep -E 'inet |state' | head -10")
    print("\n  1. Wi-Fi setup")
    print("  2. Ethernet setup")
    print("  3. Set DNS")
    print("  4. Set proxy")
    print("  5. Network diagnostics")
    c = input("  Choice: ").strip()
    if c == "1":
        os.system("nmcli device wifi list 2>/dev/null | head -15")
        ssid = input("  Wi-Fi network name: ").strip()
        pwd = input("  Password: ").strip()
        if ssid:
            os.system(f"nmcli device wifi connect '{ssid}' password '{pwd}' 2>/dev/null")
            print(f"  [+] Connecting to {ssid}")
    elif c == "2":
        os.system("nmcli device connect eth0 2>/dev/null || nmcli device connect enp0s3 2>/dev/null")
        print("  [+] Ethernet connected")
    elif c == "3":
        dns = input("  DNS server (e.g. 1.1.1.1): ").strip()
        if dns:
            os.system(f"echo 'nameserver {dns}' | sudo tee /etc/resolv.conf")
            write_setting("dns_server", dns)
            print(f"  [+] DNS set to {dns}")
    elif c == "4":
        proxy = input("  Proxy URL (e.g. http://proxy:8080): ").strip()
        if proxy:
            write_setting("proxy", proxy)
            print(f"  [+] Proxy set to {proxy}")
    elif c == "5":
        os.system("ping -c 3 google.com 2>/dev/null || echo 'No internet'")
        os.system("ip route show 2>/dev/null")

def section_sound():
    """Sound settings — volume, output device, input device."""
    print("\n  --- Sound Settings ---")
    if os.path.exists("/proc/asound"):
        os.system("amixer sget Master 2>/dev/null | grep -E 'Mono:|Front Left:|Front Right:' | head -3")
    print("\n  1. Set volume")
    print("  2. Mute/unmute")
    print("  3. Select output device")
    print("  4. Select input device")
    print("  5. Test sound")
    c = input("  Choice: ").strip()
    if c == "1":
        vol = input("  Volume (0-100): ").strip()
        if vol:
            os.system(f"amixer -q sset Master {vol}% 2>/dev/null || pactl set-sink-volume @DEFAULT_SINK@ {int(vol)}% 2>/dev/null")
            print(f"  [+] Volume set to {vol}%")
    elif c == "2":
        os.system("amixer -q sset Master toggle 2>/dev/null || pactl set-sink-mute @DEFAULT_SINK@ toggle 2>/dev/null")
        print("  [+] Mute toggled")
    elif c == "3":
        os.system("pactl list short sinks 2>/dev/null || aplay -l 2>/dev/null")
    elif c == "4":
        os.system("pactl list short sources 2>/dev/null || arecord -l 2>/dev/null")
    elif c == "5":
        os.system("speaker-test -c 2 -t sine -f 440 -l 1 2>/dev/null &")

def section_users():
    """User account management — like Windows Accounts / macOS Users & Groups."""
    print("\n  --- User Accounts ---")
    os.system("cut -d: -f1,3 /etc/passwd | awk -F: '$2 >= 1000 && $2 < 65534 {print \"  \"$1\" (UID: \"$2\")\"}'")
    print("\n  1. Add user")
    print("  2. Remove user")
    print("  3. Change password")
    print("  4. Add to sudo group")
    print("  5. Remove from sudo group")
    print("  6. User groups")
    c = input("  Choice: ").strip()
    if c == "1":
        name = input("  Username: ").strip()
        if name:
            os.system(f"sudo useradd -m -s /bin/bash {name}")
            os.system(f"sudo passwd {name}")
            print(f"  [+] User {name} created")
    elif c == "2":
        name = input("  Username to remove: ").strip()
        if name:
            confirm = input(f"  Remove {name} and their files? (yes/no): ").strip()
            if confirm == "yes":
                os.system(f"sudo userdel -r {name}")
                print(f"  [+] User {name} removed")
    elif c == "3":
        name = input("  Username: ").strip()
        if name:
            os.system(f"sudo passwd {name}")
            print(f"  [+] Password changed for {name}")
    elif c == "4":
        name = input("  Username: ").strip()
        if name:
            os.system(f"sudo usermod -aG sudo {name}")
            print(f"  [+] {name} added to sudo group")
    elif c == "5":
        name = input("  Username: ").strip()
        if name:
            os.system(f"sudo gpasswd -d {name} sudo")
            print(f"  [+] {name} removed from sudo group")
    elif c == "6":
        name = input("  Username: ").strip()
        if name:
            os.system(f"groups {name}")

def section_privacy():
    """Privacy settings — Tor, telemetry, tracking, data collection."""
    print("\n  --- Privacy Settings ---")
    tor_status = "Enabled" if os.system("systemctl is-active tor 2>/dev/null | grep -q active") == 0 else "Disabled"
    print(f"  Tor (anonymous browsing): {tor_status}")
    print(f"  Telemetry: Disabled (Vajra OS never collects data)")
    print(f"  Location services: Disabled by default")
    print(f"  Crash reports: Local only (never sent)")
    print("\n  1. Toggle Tor (show pros/cons first)")
    print("  2. Clear browser data")
    print("  3. Clear system logs")
    print("  4. Disable USB automount (security)")
    print("  5. MAC address randomization")
    c = input("  Choice: ").strip()
    if c == "1":
        print("\n  Tor PROS: Anonymous browsing, hidden IP, anti-censorship")
        print("  Tor CONS: Slower speed, some sites block Tor, exit nodes can see traffic")
        confirm = input("  Enable Tor? (yes/no): ").strip()
        if confirm == "yes":
            os.system("sudo systemctl enable tor && sudo systemctl start tor")
            print("  [+] Tor enabled")
        else:
            os.system("sudo systemctl stop tor 2>/dev/null")
            print("  [+] Tor disabled")
    elif c == "2":
        os.system("rm -rf ~/.cache/mozilla ~/.cache/google-chrome 2>/dev/null")
        print("  [+] Browser data cleared")
    elif c == "3":
        os.system("sudo journalctl --vacuum-time=1d 2>/dev/null")
        print("  [+] Old system logs cleared")
    elif c == "4":
        print("  USB automount is controlled by your file manager settings.")
    elif c == "5":
        os.system("sudo macchanger -e wlan0 2>/dev/null || echo 'Install macchanger: sudo apt install macchanger'")
        print("  [+] MAC randomized (if macchanger installed)")

def section_security():
    """Security settings — firewall, encryption, AppArmor, Secure Boot."""
    print("\n  --- Security Settings ---")
    fw = "Active" if os.system("systemctl is-active ufw 2>/dev/null | grep -q active") == 0 else "Inactive"
    aa = "Active" if os.path.exists("/sys/kernel/security/apparmor") else "Inactive"
    sb = "Enabled" if os.path.isdir("/sys/firmware/efi") and os.path.exists("/sys/firmware/efi/efivars/SecureBoot*") else "Disabled/N/A"
    print(f"  Firewall (UFW): {fw}")
    print(f"  AppArmor: {aa}")
    print(f"  Secure Boot: {sb}")
    print(f"  Disk encryption: ", end="")
    os.system("lsblk -o NAME,FSTYPE 2>/dev/null | grep -q crypt && echo 'Yes' || echo 'No'")
    print("\n  1. Enable/disable firewall")
    print("  2. Firewall rules")
    print("  3. Enable AppArmor")
    print("  4. Encrypt home directory")
    print("  5. Set password policy")
    print("  6. View login attempts")
    c = input("  Choice: ").strip()
    if c == "1":
        action = input("  Enable(1) or Disable(2): ").strip()
        if action == "1":
            os.system("sudo ufw enable && sudo ufw default deny incoming && sudo ufw default allow outgoing")
            print("  [+] Firewall enabled")
        else:
            os.system("sudo ufw disable")
            print("  [+] Firewall disabled")
    elif c == "2":
        os.system("sudo ufw status verbose")
    elif c == "3":
        os.system("sudo systemctl enable apparmor && sudo systemctl start apparmor")
        print("  [+] AppArmor enabled")
    elif c == "4":
        print("  Use: sudo apt install ecryptfs-utils && ecryptfs-migrate-home")
    elif c == "5":
        os.system("sudo chage -l $USER 2>/dev/null")
    elif c == "6":
        os.system("sudo last -10 2>/dev/null; echo '---'; sudo lastb -5 2>/dev/null")

def section_power():
    """Power settings — suspend, hibernate, battery, CPU governor."""
    print("\n  --- Power Settings ---")
    os.system("upower -i /org/freedesktop/UPower/devices/battery_BAT0 2>/dev/null | grep -E 'state|percentage|energy' || echo 'No battery'")
    print("\n  1. Set power profile (balanced/performance/powersave)")
    print("  2. Set screen blank timeout")
    print("  3. Set auto-suspend timeout")
    print("  4. CPU governor")
    print("  5. Lid close action (laptops)")
    c = input("  Choice: ").strip()
    if c == "1":
        p = input("  Profile (balanced/performance/powersave): ").strip()
        os.system(f"powerprofilesctl set {p} 2>/dev/null || echo 'Install power-profiles-daemon'")
        write_setting("power_profile", p)
        print(f"  [+] Power profile: {p}")
    elif c == "2":
        t = input("  Screen blank after (seconds): ").strip()
        os.system(f"gsettings set org.gnome.desktop.session idle-delay {t} 2>/dev/null")
        print(f"  [+] Screen blank: {t}s")
    elif c == "3":
        t = input("  Suspend after (seconds): ").strip()
        write_setting("suspend_timeout", t)
        print(f"  [+] Auto-suspend: {t}s")
    elif c == "4":
        g = input("  Governor (performance/powersave/ondemand): ").strip() or "ondemand"
        os.system(f"echo {g} | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor 2>/dev/null")
        print(f"  [+] CPU governor: {g}")
    elif c == "5":
        a = input("  Lid close (suspend/ignore/shutdown): ").strip() or "suspend"
        os.system(f"sudo sed -i 's/HandleLidSwitch=.*/HandleLidSwitch={a}/' /etc/systemd/logind.conf 2>/dev/null")
        print(f"  [+] Lid close: {a}")

def section_language():
    """Language & locale settings."""
    print("\n  --- Language & Region ---")
    os.system("locale 2>/dev/null | head -5")
    print("\n  1. Set system language")
    print("  2. Set timezone")
    print("  3. Set date format")
    print("  4. Set keyboard layout")
    c = input("  Choice: ").strip()
    if c == "1":
        print("  Available: en_IN, hi_IN, ta_IN, bn_IN, te_IN, mr_IN, gu_IN, kn_IN, ml_IN, pa_IN, as_IN, or_IN")
        lang = input("  Language code: ").strip()
        if lang:
            os.system(f"sudo update-locale LANG={lang}.UTF-8")
            write_setting("language", lang)
            print(f"  [+] Language set to {lang} (reboot to apply)")
    elif c == "2":
        os.system("timedatectl list-timezones 2>/dev/null | grep Asia | head -10")
        tz = input("  Timezone: ").strip() or "Asia/Kolkata"
        os.system(f"sudo timedatectl set-timezone {tz}")
        print(f"  [+] Timezone set to {tz}")
    elif c == "3":
        fmt = input("  Date format (dd/mm/yyyy or mm/dd/yyyy): ").strip() or "dd/mm/yyyy"
        write_setting("date_format", fmt)
        print(f"  [+] Date format: {fmt}")
    elif c == "4":
        os.system("localectl list-keymaps 2>/dev/null | head -20")
        kb = input("  Keyboard layout: ").strip()
        if kb:
            os.system(f"sudo localectl set-keymap {kb}")
            print(f"  [+] Keyboard: {kb}")

def section_time():
    """Time & date settings."""
    print("\n  --- Time & Date ---")
    os.system("timedatectl status 2>/dev/null")
    print("\n  1. Enable NTP (auto sync)")
    print("  2. Disable NTP (manual)")
    print("  3. Set date/time manually")
    c = input("  Choice: ").strip()
    if c == "1":
        os.system("sudo timedatectl set-ntp true")
        print("  [+] NTP enabled (auto time sync)")
    elif c == "2":
        os.system("sudo timedatectl set-ntp false")
        print("  [+] NTP disabled")
    elif c == "3":
        dt = input("  Date and time (YYYY-MM-DD HH:MM:SS): ").strip()
        if dt:
            os.system(f"sudo timedatectl set-time '{dt}'")
            print(f"  [+] Time set to {dt}")

def section_about():
    """System info — like Windows About / macOS About This Mac."""
    print("\n  ============================================")
    print("  About Vajra OS")
    print("  ============================================")
    print(f"  OS: Vajra OS (वज्र OS) 1.0")
    print(f"  Kernel: ", end="")
    os.system("uname -r")
    print(f"  Architecture: ", end="")
    os.system("uname -m")
    print(f"  Hostname: ", end="")
    os.system("hostname")
    print(f"  CPU: ", end="")
    os.system("grep -m1 'model name' /proc/cpuinfo | cut -d: -f2")
    print(f"  CPU cores: ", end="")
    os.system("nproc")
    print(f"  Memory: ", end="")
    os.system("free -h | grep Mem | awk '{print $2\" total, \"$3\" used, \"$7\" available\"}'")
    print(f"  Disk: ", end="")
    os.system("df -h / | tail -1 | awk '{print $2\" total, \"$3\" used, \"$4\" free\"}'")
    print(f"  Uptime: ", end="")
    os.system("uptime -p")
    print(f"  Display: {'Wayland' if os.environ.get('WAYLAND_DISPLAY') else 'X11' if os.environ.get('DISPLAY') else 'TTY'}")
    print(f"  Desktop: ", end="")
    os.system("echo $XDG_CURRENT_DESKTOP 2>/dev/null || echo 'Unknown'")
    print(f"  IP: ", end="")
    os.system("hostname -I 2>/dev/null | awk '{print $1}' || echo 'N/A'")
    print("  ============================================")
    print("  धर्मो रक्षति रक्षितः")
    print("  ============================================")

def main():
    print("=" * 55)
    print("  Vajra OS Control Center")
    print("  System Settings & Configuration")
    print("=" * 55)
    while True:
        print("\n  1.  Display          7.  Language & Region")
        print("  2.  Network          8.  Time & Date")
        print("  3.  Sound            9.  Users & Accounts")
        print("  4.  Privacy          10. Power & Battery")
        print("  5.  Security         11. Apps & Features")
        print("  6.  About            12. Accessibility")
        print("  0.  Exit")
        c = input("\n  Choice: ").strip()
        if c == "1": section_display()
        elif c == "2": section_network()
        elif c == "3": section_sound()
        elif c == "4": section_privacy()
        elif c == "5": section_security()
        elif c == "6": section_about()
        elif c == "7": section_language()
        elif c == "8": section_time()
        elif c == "9": section_users()
        elif c == "10": section_power()
        elif c == "11":
            os.system("sudo vajra-package-manager 2>/dev/null || echo 'Run vajra-package-manager.py'")
        elif c == "12":
            os.system("vajra-accessibility 2>/dev/null || echo 'Accessibility settings in settings/ directory'")
        elif c == "0": break

if __name__ == "__main__":
    main()
