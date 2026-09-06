# Vajra OS Packaging Infrastructure

This directory contains the complete Debian packaging infrastructure that makes
Vajra OS a real Linux distribution — not just a themed distro with scripts, but
a system with its own APT repository, signed packages, and proper dependency management.

## What This Does

Users can now install Vajra OS tools the same way they install any Linux software:

```bash
# Add the Vajra repository (one-time setup)
sudo apt install vajra-keyring vajra-sources
sudo apt update

# Install individual tools
sudo apt install vajra-security-center
sudo apt install vajra-control-center
sudo apt install vajra-buddhi-ai

# Or install the complete desktop experience
sudo apt install vajra-desktop
```

## Directory Structure

```
packaging/
├── repo-setup.sh                    # Set up APT repo with reprepro + GPG signing
├── build-package.sh                 # Build a single .deb package
├── build-all-packages.sh            # Build ALL vajra-* packages and add to repo
├── live-build-integration/
│   ├── vajra.list.chroot            # Package list for ISO build
│   └── 0200-vajra-repo.hook.chroot  # Hook to add Vajra repo during ISO build
├── vajra-core/                      # Core OS tools (8 managers)
│   └── debian/
│       ├── control                   # Package metadata + dependencies
│       ├── rules                     # Build rules
│       ├── changelog                 # Version history
│       ├── postinst                  # Post-install script
│       └── compat                    # Debhelper compatibility
├── vajra-keyring/                   # GPG signing key package
├── vajra-sources/                   # APT sources.list.d configuration
├── vajra-desktop/                   # Meta-package (installs everything)
├── vajra-security-center/           # Security Center
├── vajra-control-center/            # Control Center (12 settings sections)
├── vajra-buddhi-ai/                 # Buddhi AI assistant
├── vajra-package-manager/           # App Store
└── vajra-update-manager/            # Update Manager with rollback
```

## How to Build

### 1. Set up the repository (one-time, on a VPS)
```bash
sudo bash repo-setup.sh
```

### 2. Build all packages
```bash
sudo bash build-all-packages.sh
```

### 3. Build a single package
```bash
bash build-package.sh vajra-security-center
```

## Packages

| Package | Description | Dependencies |
|---------|-------------|-------------|
| vajra-core | 8 OS managers (boot, process, memory, filesystem, device, display, service, user) | python3, bash, systemd |
| vajra-keyring | GPG key for repo verification | gnupg |
| vajra-sources | APT sources.list.d entry | vajra-keyring |
| vajra-desktop | Meta-package (installs everything) | all vajra-* + GNOME + apps |
| vajra-security-center | Firewall, encryption, audit, antivirus | ufw, gnupg, apparmor |
| vajra-control-center | 12-section system settings | python3, network-manager |
| vajra-buddhi-ai | India-first AI assistant | python3, espeak-ng |
| vajra-package-manager | App store with 28 curated apps | python3, apt |
| vajra-update-manager | Updates with rollback snapshots | python3, apt, timeshift |

## Why This Matters

This is the single highest-leverage milestone for making Vajra OS a real
distribution. Before this, the 320+ scripts were just files in a GitHub repo.
Now they are proper Debian packages with:

- **Dependency resolution** — apt handles installing prerequisites
- **Automatic updates** — users run `apt upgrade` to get new versions
- **GPG signing** — packages are cryptographically verified
- **Clean uninstall** — `apt remove` removes everything cleanly
- **Repository control** — you control what gets installed and when

Every successful Linux distribution started here — Linux Mint, Pop!_OS,
elementary OS, Zorin OS all set up their own APT repository as step one.
