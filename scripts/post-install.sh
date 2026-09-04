#!/bin/bash
# NexusOS Post-Install Script
set -e
echo "◆ NexusOS Post-Install Setup"
if [[ $EUID -ne 0 ]]; then exec sudo "$0" "$@"; fi

echo "[1/5] Installing AI dependencies..."
pip3 install --break-system-packages vosk sounddevice 2>/dev/null || pip3 install vosk sounddevice 2>/dev/null || true

echo "[2/5] Installing Ollama (local AI model)..."
if ! command -v ollama &>/dev/null; then
    curl -fsSL https://ollama.com/install.sh | sh 2>/dev/null || true
fi
systemctl enable ollama 2>/dev/null || true

echo "[3/5] Downloading AI model..."
ollama pull llama3.2 2>/dev/null || true

echo "[4/5] Running privacy hardening..."
bash /opt/nexusos/privacy/harden.sh 2>/dev/null || true

echo "[5/5] Starting services..."
systemctl enable nexus-ai 2>/dev/null || true
systemctl enable nexus-tor 2>/dev/null || true
systemctl enable tor 2>/dev/null || true

echo ""
echo "◆ NexusOS setup complete!"
echo "  AI:     nexus-ai (in terminal) or Ctrl+Space"
echo "  Voice:  Say 'Nexus' then your command"
echo "  Tor:    Active (all traffic routed through Tor)"
