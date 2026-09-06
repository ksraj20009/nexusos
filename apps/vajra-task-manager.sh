#!/bin/bash
# Vajra OS Task Manager (process management)
set -e
echo "=== Vajra OS Task Manager ==="
while true; do
    echo ""
    echo "  Top processes (by CPU):"
    ps aux --sort=-%cpu | head -15
    echo ""
    echo "  Top processes (by Memory):"
    ps aux --sort=-%mem | head -10
    echo ""
    echo "  Commands: kill <pid>, info <pid>, refresh, exit"
    read -p "vajra-tm> " cmd arg
    case "$cmd" in
        kill) kill "$arg" 2>/dev/null && echo "[+] Killed PID $arg" || echo "[-] Failed" ;;
        info) ps -p "$arg" -o pid,ppid,cmd,%cpu,%mem,etime 2>/dev/null || echo "Not found" ;;
        refresh) continue ;;
        exit|quit) break ;;
        *) echo "Unknown command" ;;
    esac
done