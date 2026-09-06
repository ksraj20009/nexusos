# वज्र OS — Vajra OS

**India's Privacy-First, AI-Powered Operating System**

धर्मो रक्षति रक्षितः · Dharmo Rakshati Rakshitah · Dharma protects those who protect it

[![Made in India](https://img.shields.io/badge/Made%20in-India-orange)](https://github.com/ksraj20009/vajra-os)
[![License: MIT](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Website](https://img.shields.io/badge/Website-Live-blue)](https://ksraj20009.github.io/vajra-os/)

## Download

- **Website**: https://ksraj20009.github.io/vajra-os/
- **Releases**: https://github.com/ksraj20009/vajra-os/releases
- **ISO**: 42 MB, bootable on BIOS + UEFI

## What is Vajra OS?

Vajra OS is a complete operating system built for India — privacy-first, AI-powered, and 100% free. No tracking, no telemetry, no cloud dependencies. Your data stays on your machine.

## Features

- **Privacy First** — No tracking, no telemetry. Tor integration for anonymous browsing.
- **Buddhi AI (बुद्धि)** — Built-in AI assistant with voice commands and agentic capabilities. Runs locally.
- **Indian at Core** — GST calculator, Panchang, Vedic mathematics, Ayurveda health tips, festival calendar, IRCTC train status.
- **Beginner & Pro Modes** — Safety guardrails for beginners, full access for advanced users.
- **10 Indian Languages** — Hindi, Tamil, Bengali, Gujarati, Punjabi, Kannada, Telugu, Malayalam, Marathi, Sanskrit.
- **Cybersecurity Tools** — Pentesting tools with ethical usage guides.
- **293+ Commands** — 14 core OS tools + 279 utility scripts + BusyBox 396 applets.

## Quick Start

```bash
# Flash ISO to USB and boot
dd if=vajra-os-1.0-amd64.iso of=/dev/sdX bs=4M status=progress

# Test in QEMU
qemu-system-x86_64 -cdrom vajra-os-1.0-amd64.iso -m 512

# Install Vajra packages on Debian/Ubuntu
curl -fsSL https://ksraj20009.github.io/vajra-os/apt-repo/vajra-archive-keyring.asc | gpg --dearmor -o /usr/share/keyrings/vajra-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/vajra-archive-keyring.gpg] https://ksraj20009.github.io/vajra-os/apt-repo vajra main" | sudo tee /etc/apt/sources.list.d/vajra.list
sudo apt update
sudo apt install vajra-core vajra-buddhi-ai vajra-security-center
```

## ISO Contents

| Component | Count | Size |
|-----------|-------|------|
| Linux Kernel | 6.6.142 | 10.4 MB |
| Kernel modules | 922 | 17 MB |
| BusyBox applets | 396 | 1.4 MB |
| Vajra core tools | 16 | 250 KB |
| Utility scripts | 279 | 2 MB |
| Buddhi AI | 1 | 49 KB |
| **Total ISO** | | **42 MB** |

## Repository Structure

```
vajra-os/
├── core/           — 16 OS management tools (process, memory, security, etc.)
├── packaging/      — Debian package builds + GPG key + APT repo
├── iso/            — ISO builder + QEMU test script
├── live-build/     — Full desktop ISO config (Xfce + Calamares)
├── installer/      — Calamares installer config
├── desktop/        — Xfce, LightDM, fontconfig, IBus configs
├── systemd/        — Service files (boot check, festival, Ayurveda timers)
├── polkit/         — Beginner/Pro mode safety rules
├── system/         — Network, audio, Xorg, motd configs
├── branding/       — GRUB theme, wallpaper
├── docker/         — Dockerfile + rootfs
├── web/            — Landing page (deployed on GitHub Pages)
├── apt-repo/       — APT repository (hosted on GitHub Pages)
└── docs/           — Installation guide
```

## Packages

| Package | Description |
|---------|-------------|
| vajra-core | 8 OS managers (process, memory, filesystem, device, etc.) |
| vajra-buddhi-ai | Buddhi AI assistant (बुद्धि) |
| vajra-security-center | Firewall, IDS, security audit |
| vajra-control-center | 12-section settings panel |
| vajra-package-manager | App store with permission review |
| vajra-update-manager | System update manager with rollback |
| vajra-keyring | GPG key for package verification |
| vajra-desktop | Xfce desktop meta-package |
| vajra-wallpapers | Default wallpaper pack |

## Building from Source

See [BUILD.md](BUILD.md) for complete instructions.

## License

MIT License — Free forever.

## Links

- **Website**: https://ksraj20009.github.io/vajra-os/
- **GitHub**: https://github.com/ksraj20009/vajra-os
- **Issues**: https://github.com/ksraj20009/vajra-os/issues

---

(c) 2026 Vajra OS Project · Made in India
