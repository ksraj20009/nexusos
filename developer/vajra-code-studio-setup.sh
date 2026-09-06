#!/bin/bash
# Vajra OS Code Studio Setup - VS Code + extensions
set -e
echo "=== Vajra OS Code Studio Setup ==="
echo "[*] Installing VS Code..."
apt-get install -y code 2>/dev/null || snap install code --classic 2>/dev/null || echo "Install VS Code manually"
echo "[*] Installing essential extensions..."
code --install-extension ms-python.python 2>/dev/null || true
code --install-extension ms-vscode.cpptools 2>/dev/null || true
code --install-extension esbenp.prettier-vscode 2>/dev/null || true
code --install-extension dbaeumer.vscode-eslint 2>/dev/null || true
code --install-extension redhat.vscode-yaml 2>/dev/null || true
code --install-extension ms-azuretools.vscode-docker 2>/dev/null || true
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools 2>/dev/null || true
code --install-extension github.copilot 2>/dev/null || true
echo "[+] VS Code + extensions installed"
echo "[*] Configuring settings..."
mkdir -p ~/.config/Code/User
cat > ~/.config/Code/User/settings.json << 'SETTINGS'
{
    "editor.fontSize": 14,
    "editor.tabSize": 4,
    "editor.wordWrap": "on",
    "editor.formatOnSave": true,
    "editor.minimap.enabled": false,
    "workbench.colorTheme": "Dark+ (default dark)",
    "files.autoSave": "afterDelay",
    "terminal.integrated.fontSize": 13,
    "python.linting.enabled": true,
    "python.linting.pylintEnabled": true
}
SETTINGS
echo "[+] Settings configured"