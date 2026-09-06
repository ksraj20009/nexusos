Vajra OS 1.0 — Release Notes
==============================
Date: September 6, 2026

This is the first release of Vajra OS — India's Privacy-First AI-Powered Operating System.

Bootable ISO (37.5 MB, El Torito bootable)
==========================================
The ISO contains:
  - Linux Kernel 6.6.142 with 922 kernel modules
  - BusyBox with 396 Unix commands
  - 14 Vajra OS management tools
  - 279 utility scripts (GST, Panchang, Vedic math, Ayurveda, etc.)
  - Buddhi AI assistant (बुद्धि)
  - Disk installer (vajra-install)
  - Network support (DHCP)
  - Hardware detection
  - El Torito boot record (BIOS bootable)

Debian Packages (6, GPG-signed)
===============================
  vajra-core_1.0.0_all.deb              — 8 OS managers
  vajra-security-center_1.0.0_all.deb   — Security center
  vajra-control-center_1.0.0_all.deb    — 12-section settings
  vajra-package-manager_1.0.0_all.deb   — App store
  vajra-update-manager_1.0.0_all.deb    — Update manager
  vajra-wallpapers_1.0.0_all.deb        — Default wallpaper

GPG Key
=======
Key ID: 881FCB3110D97AFD
Purpose: Package signing for Vajra OS APT repository
Verify: gpg --import packaging/keys/vajra-archive-keyring.asc
        gpg --verify package.deb.sig package.deb

How to Boot
===========
1. Flash to USB:  dd if=vajra-os-1.0.iso of=/dev/sdX bs=4M status=progress
2. Boot from USB
3. Install to disk:  vajra-install
4. Or explore live:  vajra-help, vajra-tools, buddhi

Motto
=====
धर्मो रक्षति रक्षितः
Dharmo Rakshati Rakshitah
(Dharma protects those who protect it)
