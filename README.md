# ◆ वज्र OS — Vajra OS

**A privacy-first, AI-powered operating system. Built from the ground up.**

> धर्मो रक्षति रक्षितः — Dharma protects those who protect it.

## What Is Vajra OS?

Vajra OS (वज्र — the divine, indestructible thunderbolt of Indra) is a complete operating system with a custom-built hardened kernel, GNOME desktop, agentic AI assistant, and Tor privacy built in.

Vajra OS is its own operating system — with a custom kernel configuration, custom branding, custom AI engine, and a full suite of privacy and productivity tools. Every component is built and configured specifically for Vajra.

## 📥 Download & Install

### For Users (No Technical Knowledge Needed)

1. Go to [Releases](https://github.com/ksraj20009/nexusos/releases)
2. Download `vajra-os-1.0-amd64.iso`
3. Flash to USB drive:
   - **Windows**: Use [Rufus](https://rufus.ie/)
   - **Mac**: Use [Balena Etcher](https://etcher.balena.io/)
4. Boot from USB
5. Click "Install Vajra OS"

### System Requirements
- 2GB+ RAM (4GB recommended)
- 15GB+ disk space
- x86_64 processor
- 4GB+ USB drive

## 🤖 Buddhi AI — Agentic Assistant

Buddhi (बुद्धि — Supreme Intelligence) is the built-in AI that can:

### Agentic Tasks (Multi-step Autonomous)
- `install vlc` — Plans: checks → installs → verifies
- `update system` — Updates packages, cleans up
- `security scan` — Firewall, logins, ports, updates
- `clean up disk` — Cache, temp, trash, disk check
- `backup my files` — Creates tarball backup
- `optimize system` — Process analysis, cache clear
- `enable tor` — Starts Tor + configures transparent proxy

### Voice Control
- Wake word: **"Buddhi"** — Say it, then speak your command
- Continuous mode: No wake word needed
- Text-to-speech responses (espeak-ng)
- Fully offline (Vosk model)

### Natural Language Shell
- `execute show me disk usage` → translates to `df -h` via LLM
- `execute find large files` → translates to `find / -type f -size +100M`

### System Control
- Open/close apps: `open browser`, `close firefox`
- Run commands: `run df -h`
- File operations: `list files /home`, `read file /etc/hostname`
- Volume: `set volume to 50%`, `mute`, `unmute`
- Brightness: `set brightness to 80%`
- Screenshot, clipboard, lock screen
- Process management: `running processes`, `kill firefox`

### Web & Research
- `search for AI news` — DuckDuckGo + Wikipedia
- `alternatives for Notion` — Software alternatives
- `summarize quantum computing` — Multi-source summary

### Security Guardian
- Auto-monitors firewall, failed logins, open ports
- Auto-fixes issues (enables firewall if off)
- Full security scan on demand

### Local LLM (Ollama)
- Fully offline AI reasoning
- Natural language → shell command translation
- Context-aware conversations
- Model: llama3.2

### REST API
- `GET /status` — System + AI status
- `POST /query` — Send a command
- `POST /agentic` — Trigger multi-step task
- `POST /voice/start` — Start voice listening
- `POST /voice/continuous` — Enable continuous mode
- `POST /security/scan` — Run security scan
- `POST /install` — Install a package
- `POST /run` — Run a shell command
- `POST /search` — Web search

## 🛡 Privacy Suite

- **Tor transparent proxy** — All traffic routed through Tor
- **Encrypted DNS** — DoH/DoT, DNSSEC
- **MAC address randomization** — Every network connection
- **Firewall** — Drop zone (no incoming connections)
- **Firefox hardened** — No telemetry, fingerprinting resistance
- **Kernel hardening** — ASLR, kptr restrict, dmesg restrict
- **SSH hardening** — Key-only, root login disabled

## 🔧 Vajra Kernel

The Vajra kernel is a custom-hardened kernel built specifically for Vajra OS:
- Security: AppArmor, YAMA, lockdown, kernel ASLR, module signing
- Privacy: Network namespaces (Tor), strong crypto (AES, SHA512, XTS)
- Virtualization: Full Docker/container support (cgroups, namespaces, overlayfs)
- Filesystem: Btrfs, EXT4, F2FS, OverlayFS, SquashFS
- Branding: `vajra` hostname, custom version string

## 🎨 Desktop & Features

### Beginner / Pro Mode
- **Beginner Mode**: Large icons, simplified menus, safety guardrails (no dangerous commands, sudo blocked), Buddhi AI voice guidance
- **Pro Mode**: Full terminal access, advanced settings, developer tools, root shell

### Spotlight Search (Ctrl+Space)
- Search apps, files, web, and do math — all from one popup

### Task Manager
- View and kill processes like Windows Task Manager

### Control Center
- 18 categories of settings in one unified hub

### Window Tiling
- Snap windows left/right/top/bottom/fullscreen/grid

### App Store
- Curated categories: Browsers, Office, Media, Graphics, Development, Communication, Games
- One-click install via apt/flatpak/snap

### System Restore
- Create and restore system restore points

### Device Manager
- Hardware info, temperatures, SMART disk health, benchmarks

### Event Viewer
- System logs, errors, warnings, kernel events, auth logs

## 🧘 Unique Vajra Features

- **Vedic Calculator** — Ancient Indian math shortcuts (Urdhva Tiryagbhyam, Ekadhikena Purvena, digital root verification)
- **Ayurvedic Health Reminders** — Dinacharya (daily routine), yoga breaks, 20-20-20 eye care, water reminders, posture checks
- **Indian Festival Calendar** — All major festivals 2025-2026 with dates and descriptions
- **Night Light** — Blue light filter, auto ON at 8 PM, OFF at 6 AM
- **Clipboard Manager** — History of copied items (like Win+V)
- **Quick Launch** — Dock with favorites, search, recent documents
- **11 Indian Languages** — Hindi, Tamil, Bengali, Telugu, Kannada, Malayalam, Gujarati, Punjabi, Marathi, Odia, Sanskrit
- **Sanskrit Fonts** — Noto Sans Devanagari and more

## 📁 Repository Structure

```
nexusos/
├── kernel/
│   ├── configs/
│   │   └── vajra.config           # Custom kernel config (80+ settings)
│   └── patches/
│       └── 0001-vajra-branding.patch
├── ai/
│   ├── buddhi-ai.py                # Agentic AI engine (52KB)
│   ├── vedic-calculator.py          # Vedic math calculator
│   └── buddhi-ai.service           # Systemd service
├── privacy/
│   ├── torrc                        # Tor configuration
│   ├── setup-tor-proxy.sh           # Transparent Tor proxy
│   ├── harden.sh                    # 8-step privacy hardening
│   ├── privacy-dashboard.sh         # Live privacy monitoring
│   └── vajra-tor.service            # Systemd service
├── desktop/
│   ├── mode-switcher.sh             # Beginner/Pro mode switcher
│   ├── spotlight-search.sh          # Universal search (Ctrl+Space)
│   ├── task-manager.sh              # Process manager
│   ├── control-center.sh            # Unified settings hub
│   ├── startup-manager.sh           # Boot application manager
│   ├── clipboard-manager.sh        # Clipboard history
│   ├── window-tiler.sh              # Window snap/tiling
│   ├── quick-launch.sh              # App dock/launcher
│   ├── night-light.sh              # Blue light filter
│   ├── notification-daemon.sh       # System notifications
│   ├── color-picker.sh             # Screen color picker
│   └── desktop-suite.sh            # Desktop shortcuts & themes
├── system/
│   ├── system-restore.sh            # Restore point manager
│   ├── device-manager.sh            # Hardware device manager
│   ├── event-viewer.sh             # System event logs
│   ├── performance-suite.sh         # Benchmark & optimizer
│   ├── update-manager.sh            # Smart update manager
│   ├── backup-manager.sh            # Backup with encryption
│   ├── parental-controls.sh         # Screen time & app blocking
│   ├── container-manager.sh         # Docker/Podman manager
│   ├── font-manager.sh             # Font manager (Indic fonts)
│   ├── screen-recorder.sh          # Screen recording with audio
│   ├── printer-suite.sh            # Printer & scanner management
│   ├── power-manager.sh            # Battery & power profiles
│   ├── health-reminder.sh           # Ayurveda & yoga reminders
│   ├── boot-animation.sh            # Custom boot animation
│   ├── kiosk-mode.sh               # Single-app lockdown
│   └── system-suite.sh             # Restore points, disk, drivers
├── developer/
│   └── developer-suite.sh           # Dev tools & project scaffolding
├── network/
│   ├── bluetooth-suite.sh           # Bluetooth management
│   ├── network-suite.sh             # VPN, firewall, bandwidth
│   └── ...
├── apps/
│   ├── app-store.sh                 # Curated app store
│   └── app-suite.sh                # Flatpak, Vaultwarden, Firefox
├── locale/
│   ├── festival-calendar.py         # Indian festival calendar
│   └── locale-suite.sh             # 11 Indian languages
├── gaming/
│   └── gaming-suite.sh              # Steam, RetroArch, Jellyfin
├── security/
│   └── security-suite.sh            # Firejail, LUKS, DNS sinkhole
├── docker/
│   ├── Dockerfile                    # Vajra OS Docker image
│   └── docker-compose.yml           # Multi-service compose
├── .github/workflows/
│   └── build.yml                    # CI/CD: kernel + ISO build
└── README.md
```

## 🔄 How the Build Works

1. GitHub Actions builds the Vajra kernel with custom config
2. Applies Vajra OS patches (branding)
3. Applies custom kernel config (security, privacy, crypto)
4. Compiles the kernel (30-60 min)
5. Builds a bootable ISO
6. Publishes the ISO as a downloadable release

To trigger a build:
```bash
git tag v1.0
git push origin v1.0
```

Or go to Actions tab → "Build Vajra OS" → "Run workflow"

## 🎤 Voice Commands

| Say | What Happens |
|-----|-------------|
| "Buddhi open browser" | Opens Firefox |
| "Buddhi search for AI news" | Web search |
| "Buddhi system status" | Shows system info |
| "Buddhi install vlc" | Installs VLC |
| "Buddhi security scan" | Full security check |
| "Buddhi set volume to 50" | Adjusts volume |
| "Buddhi what time is it" | Tells the time |

## 📜 License

MIT License.

## ⚠️ Disclaimer

Tor routing may be illegal in some jurisdictions. Check local laws.

---

◆ वज्र OS — *Your OS. Your Rules. Your Privacy.*

धर्मो रक्षति रक्षितः
