#!/usr/bin/env python3
"""
Vajra OS — Buddhi Proactive Monitor
Runs in background, detects issues before user asks.
Notifies about: low disk, high CPU, high temp, failed services,
Tor drops, security issues, available updates, RAM pressure.
"""
import os, sys, time, subprocess, json, threading
from datetime import datetime

class ProactiveMonitor:
    def __init__(self):
        self.running = False
        self.interval = 60
        self.thresholds = {
            "disk_warning_gb": 5,
            "disk_critical_gb": 1,
            "cpu_warning_pct": 85,
            "ram_warning_pct": 85,
            "temp_warning_c": 80,
        }
        self.last_alerts = {}
        self.alert_cooldown = 300

    def notify(self, title, msg, urgency="normal"):
        cmd = ["notify-send", "-u", urgency, "-t", "10000", title, msg]
        subprocess.run(cmd, capture_output=True, timeout=5)
        print(f"[ALERT] {title}: {msg}")
        with open("/var/log/buddhi-proactive.log", "a") as f:
            f.write(f"[{datetime.now().isoformat()}] {title}: {msg}\n")

    def check_disk(self):
        try:
            st = os.statvfs("/")
            free_gb = (st.f_bavail * st.f_frsize) // (1024**3)
            if free_gb < self.thresholds["disk_critical_gb"]:
                self.alert("Disk Space Critical", f"Only {free_gb}GB free! Run: buddhi clean up disk")
            elif free_gb < self.thresholds["disk_warning_gb"]:
                self.alert("Disk Space Low", f"Only {free_gb}GB free. Consider cleaning up.")
        except:
            pass

    def check_cpu(self):
        try:
            with open("/proc/loadavg") as f:
                load = f.read().split()[0]
            cores = os.cpu_count() or 1
            pct = (float(load) / cores) * 100
            if pct > self.thresholds["cpu_warning_pct"]:
                self.alert("High CPU Usage", f"CPU at {pct:.0f}%")
        except:
            pass

    def check_ram(self):
        try:
            with open("/proc/meminfo") as f:
                lines = f.readlines()
            total = int([l for l in lines if l.startswith("MemTotal")][0].split()[1])
            avail = int([l for l in lines if l.startswith("MemAvailable")][0].split()[1])
            used_pct = ((total - avail) / total) * 100
            if used_pct > self.thresholds["ram_warning_pct"]:
                self.alert("High RAM Usage", f"RAM at {used_pct:.0f}%. Close unused apps.")
        except:
            pass

    def check_temperature(self):
        try:
            for zone in ["/sys/class/thermal/thermal_zone0/temp", "/sys/class/thermal/thermal_zone1/temp"]:
                if os.path.exists(zone):
                    with open(zone) as f:
                        temp = int(f.read().strip()) / 1000
                    if temp > self.thresholds["temp_warning_c"]:
                        self.alert("High Temperature", f"CPU at {temp:.0f}C. Check cooling.")
                    break
        except:
            pass

    def check_failed_services(self):
        try:
            result = subprocess.run(["systemctl", "--failed", "--no-legend"], capture_output=True, text=True, timeout=5)
            if result.stdout.strip():
                failed = result.stdout.strip().split("\n")
                self.alert("Failed Services", f"{len(failed)} service(s) failed: {failed[0].split()[0] if failed else 'unknown'}")
        except:
            pass

    def check_tor(self):
        try:
            result = subprocess.run(["systemctl", "is-active", "tor"], capture_output=True, text=True, timeout=5)
            if result.stdout.strip() != "active":
                self.alert("Tor Not Running", "Tor is not active! Traffic is NOT anonymized. Run: buddhi enable tor")
        except:
            pass

    def check_updates(self):
        try:
            result = subprocess.run(["apt", "list", "--upgradable"], capture_output=True, text=True, timeout=10)
            count = len([l for l in result.stdout.split("\n") if "upgradable" in l])
            if count > 0:
                self.alert("Updates Available", f"{count} packages need updating. Run: buddhi update system")
        except:
            pass

    def check_firewall(self):
        try:
            result = subprocess.run(["ufw", "status"], capture_output=True, text=True, timeout=5)
            if "inactive" in result.stdout.lower():
                self.alert("Firewall Off", "Firewall disabled! Run: sudo ufw enable")
        except:
            try:
                result = subprocess.run(["firewall-cmd", "--state"], capture_output=True, text=True, timeout=5)
                if "not running" in result.stdout.lower() or "error" in result.stderr.lower():
                    self.alert("Firewall Off", "Firewall disabled! Run: sudo systemctl start firewalld")
            except:
                pass

    def alert(self, title, msg):
        key = title
        now = time.time()
        if key in self.last_alerts and (now - self.last_alerts[key]) < self.alert_cooldown:
            return
        self.last_alerts[key] = now
        self.notify(title, msg)

    def run_check(self):
        self.check_disk()
        self.check_cpu()
        self.check_ram()
        self.check_temperature()
        self.check_failed_services()
        self.check_tor()
        self.check_updates()
        self.check_firewall()

    def loop(self):
        print(f"Buddhi Proactive Monitor started (interval: {self.interval}s)")
        while self.running:
            try:
                self.run_check()
            except Exception as e:
                print(f"Monitor error: {e}")
            time.sleep(self.interval)

    def start(self):
        self.running = True
        threading.Thread(target=self.loop, daemon=True).start()
        return "Proactive monitoring started"

    def stop(self):
        self.running = False
        return "Proactive monitoring stopped"

if __name__ == "__main__":
    monitor = ProactiveMonitor()
    monitor.running = True
    monitor.loop()
