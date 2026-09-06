#!/bin/bash
# Vajra OS CI Runner Setup (GitHub Actions / GitLab Runner)
set -e
echo "=== Vajra OS CI Runner Setup ==="
echo "  1. Install GitHub Actions runner (free)"
echo "  2. Install GitLab runner (free, open source)"
echo "  3. Register runner"
echo "  4. Start runner"
echo "  5. Exit"
read -p "Choice: " choice
case "$choice" in
    1) echo "[*] Download runner from GitHub repo Settings > Actions > Runners"
       echo "  Or: https://github.com/actions/runner/releases" ;;
    2) curl -L --output /usr/local/bin/gitlab-runner https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-linux-amd64 2>/dev/null
       chmod +x /usr/local/bin/gitlab-runner
       echo "[+] GitLab runner installed" ;;
    3) read -p "Registration token: " token; gitlab-runner register --registration-token "$token" 2>/dev/null; echo "[+] Runner registered" ;;
    4) gitlab-runner start 2>/dev/null; echo "[+] Runner started" ;;
    5) exit 0 ;;
esac