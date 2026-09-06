#!/bin/bash
# Vajra OS Git Setup with SSH keys
set -e
echo "=== Vajra OS Git Setup ==="
apt-get install -y git 2>/dev/null || true
read -p "Your name: " name
read -p "Your email: " email
git config --global user.name "$name"
git config --global user.email "$email"
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.editor nano
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage "reset HEAD --"
git config --global alias.last "log -1 HEAD"
echo "[+] Git configured"
echo "[*] Generate SSH key? (y/n)"
read -r ssh
if [ "$ssh" = "y" ]; then
    ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519 -N ""
    echo "[+] SSH key generated"
    echo "[*] Add this to GitHub/GitLab:"
    cat ~/.ssh/id_ed25519.pub
fi