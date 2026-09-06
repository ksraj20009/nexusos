# वज्र OS (Vajra OS)

**India's Privacy-First AI-Powered Operating System**

वज्र OS is a complete, AI-powered operating system designed for India. Built with privacy at its core, it runs Buddhi AI (बुद्धि) locally — no cloud, no tracking, no telemetry.

## Features

### Buddhi AI (बुद्धि)
- Agentic AI assistant with voice control (18+ voice commands)
- Natural language terminal — type in plain English/Hindi
- AI app integration (alarms, search, system control)
- AI settings panel — toggle features on/off
- Privacy-first: all AI runs locally, no data leaves your machine

### Indian Features
- **Panchang** — Hindu calendar with tithi, nakshatra, yoga
- **GST Calculator** — CGST/SGST/IGST computation
- **IRCTC Train Status** — live Indian Railways train checker
- **News Aggregator** — 8 Indian news sources
- **Ayurveda Database** — 10 herbs, 10 remedies
- **Yoga Timer** — 8 asanas, 3 pranayama techniques
- **Vedic Math Trainer** — 6 ancient Indian math tricks
- **Festival Calendar** — 20 Indian festivals with dates and descriptions
- **Indic Keyboards** — 12 Indian languages
- **Rupee Symbol Input** — 4 methods to type ₹
- **Indian Date Format** — dd/mm/yyyy

### Security Suite (20+ tools)
- Pentest menu (nmap, metasploit, wireshark, john, sqlmap, etc.)
- Security dashboard with scoring
- Intrusion detection (fail2ban + AIDE)
- VPN manager (WireGuard + OpenVPN)
- Steganography tool
- Malware analysis sandbox
- Secure Boot configuration
- Social Engineering Toolkit (educational)
- Cyber Academy — 17 interactive ethical hacking lessons
- Indian IT Act 2000 sections included

### Privacy
- Encrypted cloud backup (rclone + GPG)
- Password manager (KeePassXC + Bitwarden)
- Secure file shredder (3-pass overwrite)
- Browser privacy setup (Firefox pre-configured)
- GPG/PGP email encryption
- Tor optional — 10 pros and 10 cons shown before enabling
- Every download shows app info, permissions, pros/cons before proceeding

### Built-in Apps
- Weather (15 Indian cities)
- Notes with tags and search
- System monitor (CPU, RAM, disk, battery)
- Calendar with Indian holidays
- File manager
- Email client setup (Gmail, Yahoo, Outlook)
- Screenshot tool (full screen, window, area, delayed)
- Battery monitor with low-battery alerts
- Disk usage analyzer with cleanup suggestions
- Task manager (process management)
- PDF reader (Evince, Okular, Zathura)
- Media converter (FFmpeg wrapper — 6 modes)

### Developer Tools
- VS Code setup with 8 extensions
- Git setup with SSH keys and aliases
- Docker setup with 7 pre-pulled images
- Python environment (pipenv, poetry, black, jupyter, Flask, Django, FastAPI)
- Node.js setup (nvm, Node 20 LTS, TypeScript, ESLint, PM2, Yarn, pnpm)
- IDE quickstart — 5 one-click profiles (Python, Web, C/C++, Java, Full Stack)
- Enhanced terminal (zsh + oh-my-zsh + 13 Vajra aliases)
- Debugger tools (pdb, GDB, strace, ltrace, valgrind, perf)

### Gaming
- Steam setup with Proton for Windows games
- RetroArch (NES, SNES, Genesis, GameBoy, PS1, N64)
- Wine for Windows app compatibility
- Heroic Games Launcher (Epic/GOG)
- Game mode — CPU performance optimizer

### System Management
- Backup manager (full system + home, rsync, scheduled cron)
- Update manager (check, install, full update, rollback)
- Service manager (systemd wrapper)
- Cron manager (view/add/remove scheduled tasks)
- Log viewer (system, auth, kernel, boot, Vajra logs)
- Package manager (search, install, remove, update, .deb)
- Disk manager (list, format, mount, unmount, swap, SMART)
- Boot manager (GRUB entries, default, timeout, reinstall)
- User manager (add, remove, passwords, sudo group)

### Unique Features
- **Vedic Math Trainer** — learn ancient Indian mental math
- **Festival Calendar** — all Indian festivals with descriptions
- **Startup Tips** — 20 tips shown on every login
- **Health Reminders** — 7 daily Ayurveda-based notifications
- **Enhanced Accessibility** — 10 options (screen reader, magnifier, sticky keys, etc.)
- **Kids Mode** — safe environment with blocked sites and time limits
- **Senior Mode** — large text 1.5x, high contrast, voice control
- **Productivity Mode** — focus mode (block social media), Pomodoro timer

### Network
- Network manager (Wi-Fi, hotspot, diagnostics, DNS, IP)
- Firewall configuration (UFW wrapper)
- Bandwidth monitor (real-time traffic)
- DNS cache flush
- Proxy setup (HTTP/HTTPS/SOCKS)

### Infrastructure
- ISO build script (live-build, bootable ISO)
- Docker support (Dockerfile + docker-compose with 3 services)
- CI/CD pipeline (GitHub Actions — syntax check, ISO build, Docker build)
- Installation script (8-step installer for Debian/Ubuntu)
- VM image creation (QEMU, VirtualBox, VMware)
- Live USB creator (dd with confirmation)
- Uninstall script (safely removes Vajra, keeps user data)
- Makefile (test, build-iso, build-docker, install, clean, usb, run-docker, run-qemu)
- Release notes

## Two Modes

### Beginner Mode
- Large icons, simple interface
- Safety guardrails — sudo blocked
- Only essential apps shown
- AI assistance always available

### Pro Mode
- Full system access
- Developer tools unlocked
- Root shell available
- All features visible

## Download & Install

### Option 1: ISO (Recommended)
1. Download `vajra-os-latest.iso` from Releases
2. Write to USB: `dd if=vajra-os.iso of=/dev/sdX bs=4M status=progress`
3. Boot from USB and follow installer

### Option 2: Docker
```bash
docker pull vajra/os:latest
docker run -it --rm -p 8080:8080 vajra/os:latest
```

### Option 3: Install Script (on existing Debian/Ubuntu)
```bash
sudo bash infrastructure/vajra-install-script.sh
```

## Quick Commands

| Command | Description |
|---------|-------------|
| `vj-ai` | Start Buddhi AI assistant |
| `vj-voice` | Start voice control |
| `vj-sec` | Security suite |
| `vj-weather` | Weather (15 Indian cities) |
| `vj-panchang` | Hindu calendar |
| `vj-gst` | GST calculator |
| `vj-train` | IRCTC train status |
| `vj-news` | Indian news headlines |
| `vj-yoga` | Yoga timer |
| `vj-ayurveda` | Ayurveda database |
| `vj-vedic` | Vedic math trainer |
| `vj-update` | System update |
| `vj-backup` | Backup manager |

## Repository Structure

```
nexusos/
├── ai/              # Buddhi AI engine, voice control, NLP terminal
├── apps/            # Weather, notes, calendar, GST, IRCTC, news, etc.
├── desktop/         # GTK theme, icons, wallpaper, window manager
├── developer/       # VS Code, Git, Docker, Python, Node.js, debugger
├── gaming/          # Steam, RetroArch, Wine, game mode
├── infrastructure/  # ISO build, Docker, CI/CD, install scripts
├── locale/          # Panchang, Ayurveda, yoga, keyboards, Indic input
├── network/         # Network manager, firewall, bandwidth, proxy
├── privacy/         # Encryption, password manager, shredder, browser
├── security/        # Pentest, IDS, VPN, steganography, malware sandbox
├── system/          # Backup, update, services, cron, logs, boot, users
└── unique/          # Vedic math, festivals, health, kids/senior/productivity
```

## Privacy First
- All AI runs locally — no cloud, no tracking
- Tor is OPTIONAL — 10 pros and 10 cons shown before enabling
- Every download/install shows app info, permissions, pros/cons
- No telemetry, no data collection
- Your data never leaves your machine

## License
Vajra OS is released under its own license. See LICENSE file.

## Built for India
वज्र OS is designed for Indian users first — with Indic keyboards, Indian festivals, GST calculator, IRCTC checker, Ayurveda database, Vedic math, and more.