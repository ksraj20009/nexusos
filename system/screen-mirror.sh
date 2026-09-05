#!/bin/bash
# Vajra OS — Screen Mirror
case "${1:-help}" in
    cast) echo "  Scanning for cast devices..."; sudo apt-get install -y mkchromecast 2>/dev/null; mkchromecast ;;
    mirror) xrandr --output "${2:-HDMI-1}" --auto --same-as eDP-1 2>/dev/null; echo "  Mirroring to ${2:-HDMI-1}" ;;
    help|*) echo "  Commands: cast, mirror <display>" ;;
esac
