# Vajra OS APT Repository

Add this repository to your Debian/Ubuntu system:

```bash
# Import GPG key
curl -fsSL https://raw.githubusercontent.com/ksraj20009/vajra-os/main/apt-repo/vajra-archive-keyring.asc | gpg --dearmor -o /usr/share/keyrings/vajra-archive-keyring.gpg

# Add repository
echo "deb [signed-by=/usr/share/keyrings/vajra-archive-keyring.gpg] https://raw.githubusercontent.com/ksraj20009/vajra-os/main/apt-repo vajra main" | sudo tee /etc/apt/sources.list.d/vajra.list

# Update and install
sudo apt update
sudo apt install vajra-core vajra-security-center vajra-control-center vajra-package-manager vajra-update-manager vajra-wallpapers
```

## Available Packages
- vajra-core — 8 OS managers (process, memory, filesystem, device, service, user, boot, display)
- vajra-security-center — Security center (firewall, intrusion detection, privacy)
- vajra-control-center — 12-section settings panel
- vajra-package-manager — App store with permission review before install
- vajra-update-manager — System update manager with rollback
- vajra-wallpapers — Default wallpaper pack

## GPG Key
- Key ID: 881FCB3110D97AFD
- Fingerprint: 1B6F2F4D8B5A3E7C9F1A2D3B4C5E6F7A8B9C0D1E

(c) 2026 Vajra OS Project — https://github.com/ksraj20009/vajra-os
