# Vajra OS APT Repository

Add this repository to your Debian/Ubuntu system:

```bash
curl -fsSL https://ksraj20009.github.io/vajra-os/apt-repo/vajra-archive-keyring.asc | gpg --dearmor -o /usr/share/keyrings/vajra-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/vajra-archive-keyring.gpg] https://ksraj20009.github.io/vajra-os/apt-repo vajra main" | sudo tee /etc/apt/sources.list.d/vajra.list
sudo apt update
sudo apt install vajra-core vajra-buddhi-ai vajra-security-center vajra-control-center vajra-package-manager vajra-update-manager vajra-keyring vajra-desktop vajra-wallpapers
```

## Available Packages (9)
- vajra-core — 16 OS managers
- vajra-buddhi-ai — AI assistant
- vajra-security-center — Security center
- vajra-control-center — 12-section settings
- vajra-package-manager — App store
- vajra-update-manager — Update manager
- vajra-keyring — GPG key
- vajra-desktop — Desktop meta-package
- vajra-wallpapers — Wallpapers

GPG Key ID: 881FCB3110D97AFD
