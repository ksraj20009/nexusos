#!/bin/bash
# Vajra OS Disk Usage Analyzer
set -e
echo "=== Vajra OS Disk Usage Analyzer ==="
echo ""
echo "  Overall disk usage:"
df -h | grep -E "^/dev|^Filesystem"
echo ""
echo "  Top 20 largest directories in HOME:"
du -sh "$HOME"/* 2>/dev/null | sort -rh | head -20
echo ""
echo "  Top 20 largest files in HOME:"
find "$HOME" -type f -exec du -h {} + 2>/dev/null | sort -rh | head -20
echo ""
echo "  Cache sizes:"
du -sh "$HOME/.cache" 2>/dev/null
du -sh "/var/cache/apt" 2>/dev/null
du -sh "/tmp" 2>/dev/null
echo ""
echo "  Cleanup suggestions:"
echo "    sudo apt clean          - Clear apt cache"
echo "    sudo apt autoremove     - Remove unused packages"
echo "    rm -rf ~/.cache/*       - Clear user cache"
echo "    rm -rf /tmp/*           - Clear temp files"