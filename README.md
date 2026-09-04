# ◆ वज्र OS — Vajra OS

**A privacy-first, AI-powered Linux operating system built on the real Linux kernel.**

> धर्मो रक्षति रक्षितः — Dharma protects those who protect it.

## What Is Vajra OS?

Vajra OS (वज्र — the divine, indestructible thunderbolt of Indra) takes the **real Linux kernel** from [torvalds/linux](https://github.com/torvalds/linux), applies custom security/privacy patches, builds it with a hardened configuration, and packages it into a complete bootable OS with GNOME desktop, agentic AI assistant, and Tor privacy.

This is how real Linux distributions work — Ubuntu, Fedora, Kali Linux all do this. They take the upstream kernel and apply their customization layer on top.

## 📥 Download & Install

### For Users (No Technical Knowledge Needed)

1. Go to [Releases](https://github.com/ksraj20009/nexusos/releases)
2. Download `vajra-os-1.0-amd64.iso`
3. Flash to USB drive:
   - **Windows**: Use [Rufus](https://rufus.ie/)
   - **Mac/Linux**: `sudo dd if=vajra-os-1.0-amd64.iso of=/dev/sdX bs=4M`
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

## 🔧 Custom Linux Kernel

Based on Linux v6.10 from torvalds/linux:
- Security: AppArmor, YAMA, lockdown, kernel ASLR, module signing
- Privacy: Network namespaces (Tor), strong crypto (AES, SHA512, XTS)
- Virtualization: Full Docker/container support (cgroups, namespaces, overlayfs)
- Filesystem: Btrfs, EXT4, F2FS, OverlayFS, SquashFS
- Branding: `vajra` hostname, custom version string

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
│   └── buddhi-ai.service           # Systemd service
├── privacy/
│   ├── torrc                        # Tor configuration
│   ├── setup-tor-proxy.sh           # Transparent Tor proxy
│   ├── harden.sh                    # 8-step privacy hardening
│   └── vajra-tor.service            # Systemd service
├── scripts/
│   ├── build-kernel.sh              # Clones torvalds/linux, builds
│   ├── build-iso.sh                 # Full ISO builder
│   ├── post-install.sh              # AI deps, Ollama, privacy
│   ├── setup.sh                     # Installer launcher
│   ├── welcome.sh                   # Welcome screen
│   └── welcome.service              # Systemd service
├── .github/workflows/
│   └── build.yml                    # CI/CD: kernel + ISO build
└── README.md
```

## 🔄 How the Build Works

1. GitHub Actions clones torvalds/linux (v6.10)
2. Applies Vajra OS patches (branding)
3. Applies custom kernel config (security, privacy, crypto)
4. Compiles the kernel (30-60 min)
5. Builds a Debian-based ISO with live-build
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

MIT License. The Linux kernel remains under GPL v2.

## ⚠️ Disclaimer

Tor routing may be illegal in some jurisdictions. Check local laws.

---

◆ वज्र OS — *Your OS. Your Rules. Your Privacy.*

धर्मो रक्षति रक्षितः