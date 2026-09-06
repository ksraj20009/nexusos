#!/usr/bin/env python3
"""
Vajra OS AI Settings Panel
Toggle Buddhi AI features on/off.
"""

import os, sys, json
from pathlib import Path

CONFIG_DIR = Path("/etc/vajra")
AI_CONFIG = CONFIG_DIR / "ai-config.json"

DEFAULT_CONFIG = {
    "ai_enabled": True, "voice_enabled": True, "proactive_enabled": True,
    "voice_wake_word": "buddhi", "voice_language": "en-IN",
    "proactive_file_organizer": True, "proactive_log_analyzer": True,
    "proactive_monitor": True, "code_review_enabled": True,
    "security_alerts": True, "learning_assistance": True,
    "auto_suggest": True, "privacy_mode": "local-only", "model": "buddhi-local",
}

def load_config():
    if AI_CONFIG.exists():
        with open(AI_CONFIG) as f:
            return json.load(f)
    return DEFAULT_CONFIG.copy()

def save_config(config):
    CONFIG_DIR.mkdir(parents=True, exist_ok=True)
    with open(AI_CONFIG, "w") as f:
        json.dump(config, f, indent=2)

def show_panel():
    config = load_config()
    print("=" * 50)
    print("  Buddhi AI Settings Panel")
    print("=" * 50)
    options = [
        ("ai_enabled", "Buddhi AI Enabled"),
        ("voice_enabled", "Voice Control Enabled"),
        ("proactive_enabled", "Proactive Features Enabled"),
        ("proactive_file_organizer", "Auto File Organizer"),
        ("proactive_log_analyzer", "Log Analyzer"),
        ("proactive_monitor", "System Monitor"),
        ("code_review_enabled", "AI Code Review"),
        ("security_alerts", "Security Alerts"),
        ("learning_assistance", "Learning Assistance"),
        ("auto_suggest", "Auto Suggestions"),
    ]
    for i, (key, label) in enumerate(options, 1):
        status = "ON" if config.get(key, True) else "OFF"
        print(f"  {i:2d}. [{status}] {label}")
    print(f"\n  Voice Wake Word: {config.get('voice_wake_word', 'buddhi')}")
    print(f"  Voice Language:  {config.get('voice_language', 'en-IN')}")
    print(f"  Privacy Mode:    {config.get('privacy_mode', 'local-only')}")
    print("\n  T. Toggle  W. Wake word  L. Language  R. Reset  Q. Quit")
    
    choice = input("\n  Choice: ").strip().lower()
    if choice == "t":
        idx = int(input("  Setting number: ")) - 1
        if 0 <= idx < len(options):
            key = options[idx][0]
            config[key] = not config.get(key, True)
            save_config(config)
            print(f"  Toggled: {options[idx][1]} = {'ON' if config[key] else 'OFF'}")
    elif choice == "w":
        word = input("  Enter wake word: ").strip()
        if word:
            config["voice_wake_word"] = word
            save_config(config)
            print(f"  Wake word set to: {word}")
    elif choice == "l":
        langs = ["en-IN","hi-IN","ta-IN","bn-IN","te-IN","mr-IN","kn-IN","ml-IN","gu-IN","pa-IN"]
        print("  Languages:", ", ".join(langs))
        lang = input("  Enter language code: ").strip()
        if lang in langs:
            config["voice_language"] = lang
            save_config(config)
    elif choice == "r":
        save_config(DEFAULT_CONFIG.copy())
        print("  Reset to defaults")

def main():
    while True:
        show_panel()
        if input("\n  Continue? (y/n): ").strip().lower() != "y":
            break

if __name__ == "__main__":
    main()