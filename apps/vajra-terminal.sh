#!/bin/bash
# Vajra OS - Built-in Terminal Wrapper
case "${1:-help}" in
    open) gnome-terminal 2>/dev/null || xterm 2>/dev/null || echo "  No terminal found" ;;
    cmd) shift; eval "$@" ;;
    history) history 2>/dev/null || cat ~/.bash_history 2>/dev/null | tail -20 ;;
    help|*) echo "  Vajra OS - Terminal: open, cmd <command>, history" ;;
esac
