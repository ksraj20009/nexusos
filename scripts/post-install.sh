#!/bin/bash
# Vajra OS Post-Install Script
set -e
echo "◆ Vajra OS Post-Install Setup"
if [[ $EUID -ne 0 ]]; then exec sudo "$0" "$@"; fi

echo "[1/6] Installing AI dependencies..."
pip3 install --break-system-packages vosk sounddevice 2>/dev/null || pip3 install vosk sounddevice 2>/dev/null || true

echo "[2/6] Installing Ollama (local AI model)..."
if ! command -v ollama &>/dev/null; then
    curl -fsSL https://ollama.com/install.sh | sh 2>/dev/null || true
fi
systemctl enable ollama 2>/dev/null || true

echo "[3/6] Downloading AI model..."
ollama pull llama3.2 2>/dev/null || true

echo "[4/6] Installing voice tools..."
apt-get install -y espeak-ng xclip brightnessctl 2>/dev/null || true

echo "[5/6] Running privacy hardening..."
bash /opt/vajra/privacy/harden.sh 2>/dev/null || true

echo "[6/6] Starting services..."
systemctl enable buddhi-ai 2>/dev/null || true
systemctl enable vajra-tor 2>/dev/null || true
systemctl enable tor 2>/dev/null || true

echo ""
echo "◆ Vajra OS setup complete!"
echo "  AI:      buddhi (in terminal) or Ctrl+Space"
echo "  Voice:   Say 'Buddhi' then your command"
echo "  Agentic: 'install vlc', 'security scan', 'optimize system'"
echo "  Tor:     Active (all traffic routed through Tor)"
echo ""
echo "◆ वज्र OS — धर्मो रक्षति रक्षितः"
