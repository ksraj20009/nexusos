#!/bin/bash
# Vajra OS Python Environment Setup
set -e
echo "=== Vajra OS Python Environment ==="
echo "[*] Installing Python tools..."
apt-get install -y python3 python3-pip python3-venv python3-dev 2>/dev/null || true
pip3 install --user pipenv poetry black flake8 pylint mypy ipython jupyter 2>/dev/null || true
echo "[+] Python tools installed"
echo "  python3: $(python3 --version 2>&1)"
echo "  pip3: $(pip3 --version 2>&1)"
echo ""
echo "[*] Creating default virtualenv..."
python3 -m venv ~/vajra-venv
source ~/vajra-venv/bin/activate
pip install flask django fastapi uvicorn pandas numpy matplotlib
deactivate
echo "[+] Virtualenv created at ~/vajra-venv"