#!/bin/bash
# Vajra OS — Parental Timer
# Problem: Parents want to limit screen time but existing tools are complex.
TIMER_FILE="/tmp/vajra-parental-timer"
case "${1:-help}" in
    start)
        MINUTES="${2:-60}"
        echo "  Screen time timer started: $MINUTES minutes"
        echo "  Screen will lock when time is up."
        (sleep $((MINUTES * 60)); gnome-screensaver-command -l 2>/dev/null || loginctl lock-session; rm -f "$TIMER_FILE"; echo "  TIME'S UP!") &
        echo "  Timer running (PID: $!)"
        ;;
    remaining)
        if [ -f "$TIMER_FILE" ]; then
            echo "  Time remaining: $(($(cat "$TIMER_FILE") / 60)) minutes"
        else
            echo "  No timer running."
        fi
        ;;
    stop)
        pkill -f "vajra-parental-timer" 2>/dev/null
        rm -f "$TIMER_FILE"
        echo "  Timer stopped."
        ;;
    help|*)
        echo "  Vajra OS - Parental Timer"
        echo "  Commands: start <minutes>, remaining, stop"
        ;;
esac
