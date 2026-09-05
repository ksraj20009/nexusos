#!/bin/bash
# Vajra OS — Smart Cleanup
# Problem: Disk fills up with caches, old downloads, temp files.
case "${1:-scan}" in
    scan)
        echo "  Vajra OS - Smart Cleanup Scanner"
        echo "  Space that can be freed:"
        echo "    Package cache:  $(du -sh /var/cache/apt/archives/ 2>/dev/null | awk '{print $1}')"
        echo "    Thumbnail cache: $(du -sh ~/.cache/thumbnails/ 2>/dev/null | awk '{print $1}')"
        echo "    Temp files:     $(du -sh /tmp/ 2>/dev/null | awk '{print $1}')"
        echo "    Old downloads:  $(find ~/Downloads -type f -atime +30 2>/dev/null | wc -l) files >30d"
        echo "    System logs:    $(du -sh /var/log/ 2>/dev/null | awk '{print $1}')"
        echo "    Trash:          $(du -sh ~/.local/share/Trash/ 2>/dev/null | awk '{print $1}')"
        echo "    Firefox cache:  $(du -sh ~/.cache/mozilla/ 2>/dev/null | awk '{print $1}')"
        echo "  Run: vajra-cleanup clean (asks before removing anything)"
        ;;
    clean)
        read -p "  Clean package cache? (y/n): " r; [ "$r" = "y" ] && sudo apt-get clean && echo "  Cleaned"
        read -p "  Clean thumbnails? (y/n): " r; [ "$r" = "y" ] && rm -rf ~/.cache/thumbnails && echo "  Cleaned"
        read -p "  Clean temp files? (y/n): " r; [ "$r" = "y" ] && sudo rm -rf /tmp/vajra-* /tmp/*.tmp 2>/dev/null && echo "  Cleaned"
        read -p "  Clean old logs? (y/n): " r; [ "$r" = "y" ] && sudo journalctl --vacuum-size=50M && echo "  Cleaned"
        read -p "  Empty trash? (y/n): " r; [ "$r" = "y" ] && rm -rf ~/.local/share/Trash/* && echo "  Cleaned"
        read -p "  Clean browser cache? (y/n): " r; [ "$r" = "y" ] && rm -rf ~/.cache/mozilla/ 2>/dev/null && echo "  Cleaned"
        read -p "  Remove old downloads (>30d)? (y/n): " r; [ "$r" = "y" ] && find ~/Downloads -type f -atime +30 -delete 2>/dev/null && echo "  Cleaned"
        echo "  Cleanup complete!"; df -h /
        ;;
    help|*) echo "  Commands: scan, clean" ;;
esac
