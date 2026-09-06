#!/bin/bash
# Vajra OS IDE Quickstart - One-click dev environment
set -e
echo "=== Vajra OS IDE Quickstart ==="
echo "  1. Python Dev (VS Code + Python + venv)"
echo "  2. Web Dev (VS Code + Node.js + Docker)"
echo "  3. C/C++ Dev (VS Code + GCC + CMake)"
echo "  4. Java Dev (VS Code + JDK + Maven)"
echo "  5. Full Stack (Everything)"
echo "  6. Exit"
read -p "Choice: " choice
case "$choice" in
    1) bash /opt/vajra/developer/vajra-python-env.sh; bash /opt/vajra/developer/vajra-code-studio-setup.sh ;;
    2) bash /opt/vajra/developer/vajra-nodejs-setup.sh; bash /opt/vajra/developer/vajra-docker-setup.sh; bash /opt/vajra/developer/vajra-code-studio-setup.sh ;;
    3) apt-get install -y gcc g++ cmake gdb 2>/dev/null; bash /opt/vajra/developer/vajra-code-studio-setup.sh ;;
    4) apt-get install -y default-jdk maven 2>/dev/null; bash /opt/vajra/developer/vajra-code-studio-setup.sh ;;
    5) bash /opt/vajra/developer/vajra-python-env.sh; bash /opt/vajra/developer/vajra-nodejs-setup.sh; bash /opt/vajra/developer/vajra-docker-setup.sh; bash /opt/vajra/developer/vajra-code-studio-setup.sh; apt-get install -y gcc g++ cmake default-jdk maven 2>/dev/null; echo "[+] Full stack installed" ;;
    6) exit 0 ;;
esac