#!/usr/bin/env python3
"""
Vajra OS AI App Integration
Buddhi AI can open apps, set alarms, search files, and control the system.
"""

import os, sys, subprocess, json, time, threading
from datetime import datetime, timedelta

class AIAppIntegration:
    def __init__(self):
        self.alarms = []
        self.running = True
    
    def open_app(self, app_name):
        apps = {
            "terminal": "gnome-terminal", "files": "nautilus", "browser": "firefox",
            "settings": "gnome-control-center",
            "calculator": "python3 /opt/vajra/apps/vajra-calculator.py",
            "music": "bash /opt/vajra/apps/vajra-music-player.sh",
            "editor": "python3 /opt/vajra/apps/vajra-text-editor.py",
            "calendar": "python3 /opt/vajra/apps/vajra-calendar.py",
            "weather": "python3 /opt/vajra/apps/vajra-weather.py",
            "notes": "python3 /opt/vajra/apps/vajra-notes.py",
            "monitor": "python3 /opt/vajra/apps/vajra-system-monitor.py",
            "app store": "bash /opt/vajra/apps/app-store.sh",
            "security": "bash /opt/vajra/security/security-suite.sh",
            "ai": "python3 /opt/vajra/ai/buddhi-ai.py",
        }
        cmd = apps.get(app_name.lower())
        if cmd:
            subprocess.Popen(cmd, shell=True)
            return f"Opened {app_name}"
        return f"App not found: {app_name}"
    
    def set_alarm(self, time_str):
        try:
            alarm_time = datetime.strptime(time_str, "%H:%M")
            now = datetime.now()
            alarm_today = now.replace(hour=alarm_time.hour, minute=alarm_time.minute, second=0)
            if alarm_today < now:
                alarm_today += timedelta(days=1)
            self.alarms.append(alarm_today)
            threading.Thread(target=self._alarm_thread, args=(alarm_today,), daemon=True).start()
            return f"Alarm set for {time_str}"
        except ValueError:
            return "Invalid time format. Use HH:MM"
    
    def _alarm_thread(self, alarm_time):
        while self.running:
            if datetime.now() >= alarm_time:
                subprocess.run(["notify-send", "Vajra Alarm", f"It is {alarm_time.strftime('%H:%M')}!"])
                break
            time.sleep(1)
    
    def search_files(self, query, directory="/home"):
        try:
            result = subprocess.run(
                ["find", directory, "-name", f"*{query}*", "-type", "f"],
                capture_output=True, text=True, timeout=10)
            files = result.stdout.strip().split("\n")[:20]
            return files if files[0] else []
        except Exception:
            return []
    
    def control_system(self, action):
        actions = {
            "volume up": "amixer set Master 10%+", "volume down": "amixer set Master 10%-",
            "volume mute": "amixer set Master toggle", "brightness up": "xbacklight +10",
            "brightness down": "xbacklight -10", "screenshot": "gnome-screenshot",
            "lock": "gnome-screensaver-command -l", "logout": "gnome-session-quit --logout --no-prompt",
            "reboot": "sudo reboot", "shutdown": "sudo shutdown now",
            "suspend": "systemctl suspend", "hibernate": "systemctl hibernate",
        }
        cmd = actions.get(action.lower())
        if cmd:
            os.system(cmd)
            return f"Executed: {action}"
        return f"Unknown action: {action}"
    
    def get_system_status(self):
        status = {}
        try:
            with open("/proc/loadavg") as f: status["load"] = f.read().strip()
        except: pass
        try:
            r = subprocess.run(["free", "-h"], capture_output=True, text=True)
            status["memory"] = r.stdout.strip()
        except: pass
        try:
            r = subprocess.run(["df", "-h", "/"], capture_output=True, text=True)
            status["disk"] = r.stdout.strip()
        except: pass
        try:
            with open("/sys/class/power_supply/BAT0/capacity") as f:
                status["battery"] = f.read().strip() + "%"
        except: status["battery"] = "N/A"
        return status

def main():
    ai = AIAppIntegration()
    print("AI App Integration loaded: open_app, set_alarm, search_files, control_system, get_system_status")

if __name__ == "__main__":
    main()