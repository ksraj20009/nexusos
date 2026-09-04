# ◆ NexusOS

**A privacy-first, AI-powered Linux operating system built on the real Linux kernel.**

## What This Is

NexusOS takes the **real Linux kernel** from [torvalds/linux](https://github.com/torvalds/linux), applies custom security/privacy patches, builds it with a custom configuration, and packages it into a complete bootable OS with GNOME desktop, AI assistant, and Tor privacy.

This is how real Linux distributions work — Ubuntu, Fedora, Kali Linux all do this. They don't fork 80,000 files; they take the upstream kernel and apply their customization layer on top.

## 📥 Download & Install

### For Users (No Technical Knowledge Needed)

1. Go to [Releases](https://github.com/ksraj20009/nexusos/releases)
2. Download `nexusos-1.0-amd64.iso`
3. Flash to USB drive:
   - **Windows**: Use [Rufus](https://rufus.ie/)
   - **Mac/Linux**: `sudo dd if=nexusos-1.0-amd64.iso of=/dev/sdX bs=4M`
4. Boot from USB
5. Click "Install NexusOS"

### System Requirements
- 2GB+ RAM (4GB recommended)
- 15GB+ disk space
- x86_64 processor
- 4GB+ USB drive

## 🔧 What's Inside

### Custom Linux Kernel
- Based on Linux v6.10 from torvalds/linux
- Security: AppArmor, YAMA, lockdown, kernel ASLR, module signing
- Privacy: network namespaces (Tor support), strong crypto
- Performance: CPU frequency scaling
- Filesystem: Btrfs, EXT4, F2FS, OverlayFS, SquashFS

### Privacy Suite
- Tor transparent proxy (all traffic through Tor)
- Encrypted DNS (DoH/DoT)
- MAC address randomization
- Firewall (drop zone — no incoming connections)
- Firefox hardened (no telemetry, fingerprinting resistance)
- Kernel hardening (ASLR, kptr restrict, dmesg restrict)

### AI Assistant
- Web search (DuckDuckGo + Wikipedia)
- Software alternatives finder
- OS control (open apps, run commands)
- Voice recognition (Vosk, offline)
- Local LLM (Ollama, fully offline)
- REST API on localhost:5210
- No cloud — everything runs locally

### Desktop
- GNOME (modern, beginner-friendly)
- Auto-login
- Desktop shortcuts
- Welcome screen

## 📁 Repository Structure

```
nexusos/
├── kernel/
│   ├── configs/
│   │   └── nexusos.config      # Custom kernel config (80+ settings)
│   └── patches/
│       └── 0001-nexusos-branding.patch
├── ai/
│   └── nexus-ai.py              # AI assistant (16KB, full features)
├── privacy/
│   ├── torrc                     # Tor configuration
│   ├── setup-tor-proxy.sh        # Transparent Tor proxy
│   └── harden.sh                 # 8-step privacy hardening
├── scripts/
│   ├── build-kernel.sh           # Clones Linux, applies patches, builds
│   └── build-iso.sh              # Full ISO builder
├── .github/workflows/
│   └── build.yml                 # GitHub Actions: auto-builds kernel + ISO
└── README.md
```

## 🔄 How the Build Works

1. GitHub Actions clones torvalds/linux (v6.10)
2. Applies NexusOS patches (branding, etc.)
3. Applies custom kernel config (security, privacy, crypto)
4. Compiles the kernel (30-60 min on GitHub runners)
5. Builds a Debian-based ISO with live-build
6. Publishes the ISO as a downloadable release

To trigger a build:
```bash
git tag v1.0
git push origin v1.0
```

## 🎤 AI Commands

| Command | Example |
|---------|---------|
| Search | "search for best laptops" |
| Alternatives | "alternatives for Notion" |
| Open app | "open browser" |
| Run | "run df -h" |
| System info | "system status" |
| Time | "what time is it?" |

API: `curl http://127.0.0.1:5210/status`

## 📜 License

MIT License. The Linux kernel remains under GPL v2.

## ⚠️ Disclaimer

Tor routing may be illegal in some jurisdictions. Check local laws.

---

◆ NexusOS — *Your OS. Your Rules. Your Privacy.*