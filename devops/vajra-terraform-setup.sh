#!/bin/bash
# Vajra OS Terraform Setup
set -e
echo "=== Vajra OS Terraform Setup ==="
echo "  1. Install Terraform (free, open source)"
echo "  2. Initialize project"
echo "  3. Validate config"
echo "  4. Plan"
echo "  5. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y terraform 2>/dev/null || snap install terraform --classic 2>/dev/null
       echo "[+] Terraform installed" ;;
    2) read -p "Project directory: " dir; mkdir -p "$dir"; cd "$dir"; terraform init; echo "[+] Initialized" ;;
    3) terraform validate 2>/dev/null; echo "[+] Validated" ;;
    4) terraform plan 2>/dev/null; echo "[+] Plan generated" ;;
    5) exit 0 ;;
esac