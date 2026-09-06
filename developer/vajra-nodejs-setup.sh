#!/bin/bash
# Vajra OS Node.js Setup
set -e
echo "=== Vajra OS Node.js Setup ==="
apt-get install -y nodejs npm 2>/dev/null || true
echo "[*] Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh 2>/dev/null | bash || true
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
echo "[*] Installing Node 20 LTS..."
nvm install 20 2>/dev/null || true
nvm use 20 2>/dev/null || true
echo "[*] Installing global packages..."
npm install -g typescript ts-node eslint prettier nodemon pm2 yarn pnpm 2>/dev/null || true
echo "[+] Node.js setup complete"
echo "  node: $(node --version 2>&1)"
echo "  npm: $(npm --version 2>&1)"