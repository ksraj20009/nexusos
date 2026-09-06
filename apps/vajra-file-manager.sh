#!/bin/bash
# Vajra OS File Manager Helper
set -e
echo "=== Vajra OS File Manager ==="
DIR="${1:-$HOME}"
echo "Current directory: $DIR"
echo ""
while true; do
    echo "--- Contents of $DIR ---"
    ls -la "$DIR" 2>/dev/null | head -30
    echo ""
    echo "Commands: cd <dir>, open <file>, back, home, exit"
    read -p "vajra-fm> " cmd arg
    case "$cmd" in
        cd) if [ -d "$DIR/$arg" ]; then DIR="$DIR/$arg"; else echo "Not a directory"; fi ;;
        open) xdg-open "$DIR/$arg" 2>/dev/null || echo "Cannot open" ;;
        back) DIR=$(dirname "$DIR") ;;
        home) DIR="$HOME" ;;
        exit|quit) break ;;
        *) echo "Unknown command" ;;
    esac
done