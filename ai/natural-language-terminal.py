#!/usr/bin/env python3
"""
Vajra OS Natural Language Terminal
Type English, get commands executed.
"""

import os, sys, subprocess, re

NL_MAP = [
    (r"check.*(wifi|internet|network)", "nmcli device status"),
    (r"check.*(battery|power)", "cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 'No battery'"),
    (r"check.*(disk|space|storage)", "df -h"),
    (r"check.*(memory|ram)", "free -h"),
    (r"check.*(cpu|processor)", "lscpu | head -20"),
    (r"check.*(ip|address)", "ip addr show"),
    (r"list.*(file|files).*in\s+(\S+)", "ls -la {dir}"),
    (r"find\s+(\S+)", "find / -name '*{pattern}*' 2>/dev/null | head -20"),
    (r"(install|add).*package\s+(\S+)", "sudo apt install -y {pkg}"),
    (r"(remove|uninstall).*package\s+(\S+)", "sudo apt remove -y {pkg}"),
    (r"(update|upgrade).*system", "sudo apt update && sudo apt upgrade -y"),
    (r"clean.*system", "sudo apt autoremove -y && sudo apt clean"),
    (r"show.*(process|running)", "ps aux | head -30"),
    (r"kill.*process\s+(\S+)", "pkill -f {proc}"),
    (r"show.*(kernel|version)", "uname -a"),
    (r"(start|enable).*(firewall|ufw)", "sudo ufw enable"),
    (r"(stop|disable).*(firewall|ufw)", "sudo ufw disable"),
    (r"check.*(firewall|ufw)", "sudo ufw status"),
    (r"open\s+(\S+)", "xdg-open {app} 2>/dev/null || {app} &"),
    (r"(reboot|restart).*system", "sudo reboot"),
    (r"shut.?down", "sudo shutdown now"),
    (r"what.*(time|clock)", "date '+%I:%M %p'"),
    (r"what.*(date|today)", "date '+%A, %d %B %Y'"),
    (r"who.*am.*i", "whoami"),
    (r"where.*am.*i", "pwd"),
    (r"clear.*screen", "clear"),
    (r"check.*(security|vulnerab)", "bash /opt/vajra/security/security-suite.sh"),
    (r"backup.*system", "bash /opt/vajra/system/backup-manager.sh"),
    (r"scan.*network", "bash /opt/vajra/security/network-scanner.sh"),
]

def parse_command(text):
    text_lower = text.lower().strip()
    for pattern, template in NL_MAP:
        match = re.search(pattern, text_lower)
        if match:
            if "{dir}" in template:
                return template.format(dir=match.group(2) if match.lastindex >= 2 else ".")
            elif "{pattern}" in template:
                return template.format(pattern=match.group(1))
            elif "{pkg}" in template:
                return template.format(pkg=match.group(2))
            elif "{proc}" in template:
                return template.format(proc=match.group(1))
            elif "{app}" in template:
                return template.format(app=match.group(1))
            return template
    return None

def main():
    print("=" * 60)
    print("  Vajra OS Natural Language Terminal")
    print("  Type in plain English -- Buddhi translates to commands")
    print("=" * 60)
    while True:
        try:
            user_input = input("vajra> ").strip()
            if not user_input: continue
            if user_input.lower() in ["exit", "quit", "bye"]:
                print("Goodbye!")
                break
            cmd = parse_command(user_input)
            if cmd:
                print(f"  -> Running: {cmd}")
                confirm = input("  Execute? (y/n) [y]: ").strip().lower() or "y"
                if confirm == "y":
                    os.system(cmd)
            else:
                print(f"  Try: 'check wifi', 'check disk', 'install package firefox', 'what time'")
        except KeyboardInterrupt:
            print("\nGoodbye!")
            break
        except Exception as e:
            print(f"  Error: {e}")

if __name__ == "__main__":
    main()