#!/bin/bash
# Vajra OS Ansible Setup
set -e
echo "=== Vajra OS Ansible Setup ==="
echo "  1. Install Ansible (free, open source)"
echo "  2. Create inventory"
echo "  3. Run playbook"
echo "  4. Test connectivity"
echo "  5. Exit"
read -p "Choice: " choice
case "$choice" in
    1) apt-get install -y ansible 2>/dev/null; echo "[+] Ansible installed" ;;
    2) mkdir -p ~/ansible; echo "[local]" > ~/ansible/hosts; echo "localhost" >> ~/ansible/hosts; echo "[+] Inventory created" ;;
    3) read -p "Playbook file: " pb; ansible-playbook -i ~/ansible/hosts "$pb" 2>/dev/null; echo "[+] Playbook executed" ;;
    4) ansible all -i ~/ansible/hosts -m ping 2>/dev/null; echo "[+] Connectivity tested" ;;
    5) exit 0 ;;
esac