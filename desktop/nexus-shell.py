#!/usr/bin/env python3
"""
NexusOS Desktop Shell
======================
A simplified, beginner-friendly desktop shell that runs on top of GNOME/Wayland.
Provides a phone-like app drawer, AI command bar, and voice integration.
"""

import gi
import os
import sys
import json
import subprocess
import urllib.request
import urllib.parse
import threading
import time

gi.require_version("Gtk", "3.0")
gi.require_version("Gdk", "3.0")
from gi.repository import Gtk, Gdk, GLib, GObject

# =====================================================================

NEXUS_AI_API = "http://127.0.0.1:5210"
CONFIG_DIR = os.path.expanduser("~/.config/nexusos")
CONFIG_FILE = os.path.join(CONFIG_DIR, "desktop.json")

# =====================================================================
#  APP DEFINITIONS
# ====================================================================

APPS = [
    {"id": "assistant",  "name": "AI Assistant",  "icon": "✦",  "command": "nexus-ai --cli",     "category": "system"},
    {"id": "terminal",  "name": "Terminal",       "icon": "⌘",  "command": "gnome-terminal",      "category": "system"},
    {"id": "browser",   "name": "Browser",        "icon": "🌐", "command": "firefox",             "category": "internet"},
    {"id": "tor",       "name": "Tor Browser",    "icon": "🧅", "command": "tor-browser-en",       "category": "internet"},
    {"id": "files",     "name": "Files",          "icon": "📁", "command": "nautilus",            "category": "system"},
    {"id": "editor",    "name": "Text Editor",    "icon": "📝", "command": "gedit",               "category": "office"},
    {"id": "code",      "name": "Code Editor",     "icon": "💻", "command": "code",               "category": "dev"},
    {"id": "calculator","name": "Calculator",     "icon": "🧮", "command": "gnome-calculator",    "category": "utility"},
    {"id": "notes",     "name": "Notes",           "icon": "🗒", "command": "gnome-notes",         "category": "office"},
    {"id": "clock",     "name": "Clock",           "icon": "🕐", "command": "gnome-clocks",       "category": "utility"},
    {"id": "music",     "name": "Music",           "icon": "🎵", "command": "rhythmbox",           "category": "media"},
    {"id": "monitor",   "name": "System Monitor", "icon": "📊", "command": "gnome-system-monitor", "category": "system"},
    {"id": "settings",  "name": "Settings",        "icon": "⚙",  "command": "gnome-control-center","category": "system"},
    {"id": "calendar",  "name": "Calendar",        "icon": "📅", "command": "gnome-calendar",      "category": "office"},
    {"id": "camera",    "name": "Camera",           "icon": "📷", "command": "cheese",             "category": "media"},
    {"id": "bleachbit", "name": "Privacy Cleaner", "icon": "🧹", "command": "bleachbit",           "category": "privacy"},
]

# ====================================================================
#  THEME
# ====================================================================

THEME = {
    "bg_primary": "#0a0e1a",
    "bg_secondary": "#131826",
    "bg_tertiary": "#1a2033",
    "accent": "#00d4ff",
    "accent_secondary": "#7b5cff",
    "text_primary": "#e8ecf1",
    "text_secondary": "#8892a6",
    "text_muted": "#5a6378",
    "border": "rgba(255,255,255,0.08)",
    "radius": "12px",
}