#!/usr/bin/env python3
"""
Vajra OS — Buddhi Task Scheduler
Schedule tasks to run automatically.
"""
import os, sys, json, time, threading, subprocess
from datetime import datetime, timedelta

SCHEDULE_FILE = "/var/lib/vajra/schedules.json"

class TaskScheduler:
    def __init__(self):
        self.schedules = []
        self.running = False
        self.load()

    def load(self):
        try:
            with open(SCHEDULE_FILE) as f:
                self.schedules = json.load(f)
        except:
            self.schedules = []

    def save(self):
        os.makedirs(os.path.dirname(SCHEDULE_FILE), exist_ok=True)
        with open(SCHEDULE_FILE, 'w') as f:
            json.dump(self.schedules, f, indent=2)

    def add(self, name, cron_time, command, recurring=True):
        task = {
            "id": len(self.schedules) + 1,
            "name": name,
            "schedule": cron_time,
            "command": command,
            "recurring": recurring,
            "last_run": None,
            "next_run": None,
            "enabled": True,
            "created": datetime.now().isoformat()
        }
        self.schedules.append(task)
        self.save()
        return f"Scheduled '{name}' for {cron_time}"

    def remove(self, task_id):
        self.schedules = [s for s in self.schedules if s["id"] != task_id]
        self.save()
        return f"Removed task {task_id}"

    def list(self):
        if not self.schedules:
            return "No scheduled tasks."
        lines = ["Scheduled Tasks:\n"]
        for s in self.schedules:
            status = "OK" if s["enabled"] else "OFF"
            lines.append(f"  [{s['id']}] {status} {s['name']}: {s['schedule']} -> {s['command']}")
            if s["last_run"]:
                lines.append(f"       Last run: {s['last_run']}")
        return "\n".join(lines)

    def execute(self, command):
        try:
            result = subprocess.run(command, shell=True, capture_output=True, text=True, timeout=300)
            return result.stdout.strip() or result.stderr.strip() or "Done"
        except Exception as e:
            return str(e)

    def check_and_run(self):
        now = datetime.now()
        for s in self.schedules:
            if not s["enabled"]:
                continue
            sched = s["schedule"].lower()
            should_run = False
            if sched == "hourly" and (s["last_run"] is None or self._hours_since(s["last_run"]) >= 1):
                should_run = True
            elif sched.startswith("daily"):
                hour = int(sched.split()[-1].split(":")[0]) if ":" in sched else 3
                if now.hour == hour and (s["last_run"] is None or self._hours_since(s["last_run"]) >= 23):
                    should_run = True
            elif sched.startswith("weekly"):
                if now.strftime("%A").lower() == sched.split()[1] and now.hour == int(sched.split()[-1].split(":")[0]):
                    should_run = True
            if should_run:
                print(f"[SCHEDULER] Running: {s['name']} -> {s['command']}")
                result = self.execute(s["command"])
                s["last_run"] = now.isoformat()
                print(f"[SCHEDULER] Result: {result[:200]}")
                self.save()

    def _hours_since(self, iso_str):
        try:
            dt = datetime.fromisoformat(iso_str)
            return (datetime.now() - dt).total_seconds() / 3600
        except:
            return 999

    def loop(self):
        print("Buddhi Task Scheduler started")
        while self.running:
            try:
                self.check_and_run()
            except Exception as e:
                print(f"Scheduler error: {e}")
            time.sleep(60)

    def start(self):
        self.running = True
        threading.Thread(target=self.loop, daemon=True).start()

if __name__ == "__main__":
    scheduler = TaskScheduler()
    if len(sys.argv) > 1:
        cmd = sys.argv[1]
        if cmd == "list":
            print(scheduler.list())
        elif cmd == "add":
            print(scheduler.add(sys.argv[2], sys.argv[3], sys.argv[4]))
        elif cmd == "remove":
            print(scheduler.remove(int(sys.argv[2])))
        else:
            print("Usage: scheduler.py [list|add <name> <schedule> <command>|remove <id>]")
    else:
        scheduler.start()
        scheduler.running = True
        scheduler.loop()
