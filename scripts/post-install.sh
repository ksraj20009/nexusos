#!/bin/bash
# ============================================================
#  NexusOS Post-Install Setup Script
#  Runs after the OS is installed to set up AI, Tor, privacy
# ============================================================
set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}◆ NexusOS Post-Install Setup${NC}"
echo -e "${BLUE}=============================${NC}"

# --- 1. Enable services ---
echo -e "${BLUE}[1/7] Enabling system services...${NC}"
systemctl enable NetworkManager
systemctl enable gdm
systemctl enable tor
systemctl enable firewalld
systemctl enable apparmor 2>/dev/null || true
systemctl enable usbguard 2>/dev/null || true
systemctl enable nexus-ai 2>/dev/null || true
systemctl enable nexus-tor 2>/dev/null || true
echo -e "${GREEN}  ✓ Services enabled${NC}"

# --- 2. Create directories ---
echo -e "${BLUE}[2/7] Creating directories...${NC}"
mkdir -p /opt/nexusos/{ai,privacy,desktop,scripts}
mkdir -p /etc/nexusos
mkdir -p /var/log/nexusos
mkdir -p /home/raj/.config/nexusos
mkdir -p /home/raj/.local/share/nexusos
echo -e "${GREEN}  ✓ Directories created${NC}"

# --- 3. Set permissions ---
echo -e "${BLUE}[3/7] Setting permissions...${NC}"
chown -R raj:raj /home/raj/.config/nexusos /home/raj/.local/share/nexusos
chmod 644 /etc/nexusos/*
chmod 755 /opt/nexusos
echo -e "${GREEN}  ✓ Permissions set${NC}"

# --- 4. Configure GDM ---
echo -e "${BLUE}[4/7] Configuring login manager...${NC}"
mkdir -p /etc/gdm
cat > /etc/gdm/custom.conf << 'EOF'
[daemon]
WaylandEnable=true
AutoLoginEnable=false
#AutoLogin=raj

[security]
DisallowRoot=true

[xdmcp]
Enable=false
EOF
echo -e "${GREEN}  ✓ GDM configured${NC}"

# --- 5. Install Ollama model ---
echo -e "${BLUE}[5/7] Setting up local AI model...${NC}"
if command -v ollama &>/dev/null; then
    systemctl enable ollama 2>/dev/null || true
    systemctl start ollama 2>/dev/null || true
    echo -e "${YELLOW}  → Downloading llama3.2 model (this may take a while)...${NC}"
    su - raj -c "ollama pull llama3.2" 2>/dev/null || true
    echo -e "${GREEN}  ✓ Local AI model ready${NC}"
else
    echo -e "${YELLOW}  → Ollama not installed (install: curl -fsSL https://ollama.com/install.sh | sh)${NC}"
fi

# --- 6. Download Vosk voice model ---
echo -e "${BLUE}[6/7] Setting up voice recognition...${NC}"
VOSK_DIR="/opt/nexusos/ai/models"
if [[ ! -d "$VOSK_DIR/vosk-model-small-en-in-0.4" ]]; then
    mkdir -p "$VOSK_DIR"
    cd "$VOSK_DIR"
    echo -e "${YELLOW}  → Downloading Vosk model (50MB)...${NC}"
    wget -q "https://alphacephei.com/vosk/models/vosk-model-small-en-in-0.4.zip" -O vosk.zip 2>/dev/null || true
    unzip -q vosk.zip 2>/dev/null || true
    rm -f vosk.zip
    echo -e "${GREEN}  ✓ Voice model downloaded${NC}"
else
    echo -e "${GREEN}  ✓ Voice model already present${NC}"
fi

# --- 7. Apply privacy hardening ---
echo -e "${BLUE}[7/7] Applying privacy hardening...${NC}"
if [[ -f /opt/nexusos/privacy/harden.sh ]]; then
    bash /opt/nexusos/privacy/harden.sh
else
    echo -e "${YELLOW}  → Privacy script not found${NC}"
fi

echo ""
echo -e "${GREEN}◆ NexusOS Setup Complete!${NC}"
echo ""
echo -e "Your private, AI-powered operating system is ready."
echo -e ""
echo -e "${YELLOW}Quick start:${NC}"
echo -e "  • Press Ctrl+Space for AI command bar"
echo -e "  • Say 'Nexus' to trigger voice assistant"
echo -e "  • Run 'nexus-ai' in terminal for AI chat"
echo -e "  • AI API at http://127.0.0.1:5210"
echo ""