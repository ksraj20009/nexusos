#!/usr/bin/env python3
"""
Vajra OS Voice Control Daemon
Speech-to-text + text-to-speech service for Buddhi AI.
"""

import os, sys, subprocess, json, time, threading
from pathlib import Path

class VoiceDaemon:
    def __init__(self):
        self.running = False
        self.commands = {
            "open terminal": lambda: self.cmd_open("terminal"),
            "open files": lambda: self.cmd_open("files"),
            "open browser": lambda: self.cmd_open("browser"),
            "open settings": lambda: self.cmd_open("settings"),
            "open calculator": lambda: self.cmd_open("calculator"),
            "open music": lambda: self.cmd_open("music"),
            "close": self.cmd_close,
            "search": self.cmd_search,
            "set volume": self.cmd_volume,
            "set brightness": self.cmd_brightness,
            "take screenshot": self.cmd_screenshot,
            "what time": self.cmd_time,
            "what date": self.cmd_date,
            "check wifi": self.cmd_wifi,
            "check battery": self.cmd_battery,
            "shutdown": self.cmd_shutdown,
            "restart": self.cmd_restart,
            "lock screen": self.cmd_lock,
        }
    
    def speak(self, text):
        try:
            subprocess.run(["espeak", "-v", "en-in", text], timeout=10)
        except Exception:
            print(f"[TTS] {text}")
    
    def listen(self):
        print("[Voice] Listening...")
        try:
            subprocess.run(["arecord", "-d", "5", "-f", "cd", "/tmp/vajra-voice.wav"], timeout=10)
            text = input("[Voice] Enter command: ").strip().lower()
            return text
        except Exception:
            return input("[Voice] Enter command: ").strip().lower()
    
    def cmd_open(self, app):
        apps = {"terminal":"gnome-terminal","files":"nautilus","browser":"firefox",
                "settings":"gnome-control-center","calculator":"python3 /opt/vajra/apps/vajra-calculator.py",
                "music":"bash /opt/vajra/apps/vajra-music-player.sh"}
        cmd = apps.get(app, app)
        subprocess.Popen(cmd, shell=True)
        self.speak(f"Opening {app}")
    
    def cmd_close(self, app):
        subprocess.run(["pkill", "-f", app], timeout=5)
        self.speak(f"Closing {app}")
    
    def cmd_search(self, query):
        subprocess.Popen(["firefox", f"https://www.google.com/search?q={query}"])
        self.speak(f"Searching for {query}")
    
    def cmd_volume(self, level=None):
        subprocess.run(["amixer", "set", "Master", "50%"], timeout=5)
        self.speak("Volume set to 50 percent")
    
    def cmd_brightness(self, level=None):
        subprocess.run(["xrandr", "--output", "eDP-1", "--brightness", "0.8"], timeout=5)
        self.speak("Brightness adjusted")
    
    def cmd_screenshot(self):
        subprocess.run(["gnome-screenshot"])
        self.speak("Screenshot taken")
    
    def cmd_time(self):
        from datetime import datetime
        self.speak(f"The time is {datetime.now().strftime('%I:%M %p')}")
    
    def cmd_date(self):
        from datetime import datetime
        self.speak(f"Today is {datetime.now().strftime('%A, %d %B %Y')}")
    
    def cmd_wifi(self):
        result = subprocess.run(["nmcli", "device", "status"], capture_output=True, text=True)
        print(result.stdout)
    
    def cmd_battery(self):
        try:
            with open("/sys/class/power_supply/BAT0/capacity") as f:
                self.speak(f"Battery at {f.read().strip()} percent")
        except Exception:
            self.speak("Battery not available")
    
    def cmd_shutdown(self):
        self.speak("Shutting down")
        time.sleep(3)
        subprocess.run(["shutdown", "now"])
    
    def cmd_restart(self):
        self.speak("Restarting")
        time.sleep(3)
        subprocess.run(["reboot"])
    
    def cmd_lock(self):
        subprocess.run(["gnome-screensaver-command", "-l"])
        self.speak("Screen locked")
    
    def process_command(self, text):
        if not text: return
        for trigger, handler in self.commands.items():
            if text.startswith(trigger):
                arg = text[len(trigger):].strip()
                try:
                    handler(arg) if arg else handler()
                except Exception as e:
                    self.speak(f"Error: {e}")
                return
        self.speak(f"Command not recognized: {text}")
    
    def run(self):
        self.running = True
        self.speak("Voice control started. Say a command.")
        while self.running:
            try:
                text = self.listen()
                if text in ["exit", "quit", "stop"]:
                    self.speak("Goodbye")
                    break
                self.process_command(text)
            except KeyboardInterrupt:
                break
            except Exception as e:
                print(f"[Error] {e}")

def main():
    VoiceDaemon().run()

if __name__ == "__main__":
    main()