# ◆ NexusOS

**A privacy-first, AI-powered Linux distribution that anyone can use.**

Built on Debian. Tor-routed. AI-assisted. Beginner-friendly.

---

## 📥 Download

### Option 1: Download the ISO (for installing on your computer)

1. Go to the [Releases page](https://github.com/ksraj20009/nexusos/releases)
2. Download `nexusos-1.0-amd64.iso`
3. Flash it to a USB drive (4GB+):
   - **Windows**: Use [Rufus](https://rufus.ie/) or [balenaEtcher](https://etcher.balena.io/)
   - **Mac**: `sudo dd if=nexusos-1.0-amd64.iso of=/dev/rdiskN bs=4m`
   - **Linux**: `sudo dd if=nexusos-1.0-amd64.iso of=/dev/sdX bs=4M status=progress`
4. Restart your computer and boot from the USB drive
5. Follow the on-screen installer (Calamares)

### Option 2: Try with Docker (no installation needed)

```bash
git clone https://github.com/ksraj20009/nexusos.git
cd nexusos
docker-compose -f docker/docker-compose.yml up
```

### Option 3: Build the ISO yourself (on Debian/Ubuntu)

```bash
git clone https://github.com/ksraj20009/nexusos.git
cd nexusos/live-build
sudo apt install live-build
lb config
sudo lb build
```

---

## ✨ What is NexusOS?

NexusOS is a complete operating system built on Debian Linux. It has three priorities:

### 🔒 Privacy First
- All network traffic routed through Tor by default
- Encrypted DNS (no one can see what websites you visit)
- MAC address randomization (your device can't be tracked)
- Strict firewall (no incoming connections)
- Zero telemetry — nothing about you is collected
- No cloud services — your data never leaves your machine

### ✦ AI Powered
- Built-in AI assistant (runs locally, no cloud AI)
- Voice control — say "Nexus" followed by your command
- Web search via DuckDuckGo + Wikipedia
- Find software alternatives ("alternatives for Notion")
- Control the OS ("open browser", "lock screen", "system status")
- Local LLM integration via Ollama (optional, for offline AI)

### 🖥️ Beginner Friendly
- GNOME desktop (same as Ubuntu, easy to use)
- Large touch-friendly icons
- Welcome screen with quick start guide
- Graphical installer (Calamares)
- Auto-login on live USB
- Desktop shortcuts for AI assistant and installer
- Works on old hardware (2GB RAM minimum)

---

## 🚀 Getting Started

### After booting NexusOS:

1. **Boot into NexusOS** — you'll see the GNOME desktop
2. **Press Ctrl+Space** — the AI command bar opens
3. **Type a question** — try "what time is it?" or "search for best laptops"
4. **Or use voice** — say "Nexus, what's the weather?"
5. **Open apps** — click "Activities" or press Super key
6. **Install** — double-click "Install NexusOS" on the desktop

### Quick keyboard shortcuts:
- **Ctrl+Space** — AI command bar
- **Ctrl+Alt+T** — Terminal
- **Super key** — Activities overview
- **Super + L** — Lock screen

---

## 📋 System Requirements

| Requirement | Minimum | Recommended |
|-------------|---------|-------------|
| RAM | 2GB | 4GB+ |
| Storage | 15GB | 32GB+ |
| CPU | x86_64, 1GHz | Dual-core 2GHz+ |
| USB drive | 4GB | 8GB+ |
| Boot mode | BIOS/UEFI | UEFI |

---

## 📁 Project Structure

```
nexusos/
├── .github/workflows/       # GitHub Actions (auto-builds ISO)
├── live-build/              # Debian live-build configuration
│   ├── auto/                # Build config script
│   ├── config/
│   │   ├── package-lists/   # Software packages to install
│   │   ├── hooks/           # Customization scripts
│   │   └── includes.chroot/ # Files to include in the ISO
│   └── ...
├── docker/                  # Docker image files
│   ├── Dockerfile
│   └── docker-compose.yml
└── README.md
```

---

## 🔧 How the ISO is built

NexusOS uses **Debian live-build** — the same tool used by Kali Linux and Parrot OS.

1. GitHub Actions triggers on a new tag (e.g., `v1.0`)
2. It installs `live-build` on a GitHub runner
3. `lb config` sets up the build
4. `lb build` downloads Debian packages and creates the ISO
5. The ISO is published as a GitHub Release

To trigger a build:
```bash
git tag v1.0
git push origin v1.0
# GitHub Actions builds and publishes the ISO automatically
```

---

## 🎤 AI Assistant Commands

| Command | Example |
|---------|---------|
| Search | "search for best laptops" |
| Alternatives | "alternatives for Notion" |
| Open app | "open browser" |
| Run command | "run df -h" |
| System info | "system status" |
| Time | "what time is it?" |
| Lock | "lock screen" |
| Install | "install nexusos" |

AI API: `curl http://127.0.0.1:5210/status`

---

## 📜 License

MIT License — free for everyone to use, modify, and distribute.

---

## ⚠️ Disclaimer

Tor routing may be illegal in some jurisdictions. Check your local laws. NexusOS is provided as-is without warranty.

---

◆ NexusOS — *Your OS. Your Rules. Your Privacy.*