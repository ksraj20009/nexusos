#!/usr/bin/env python3
"""Vajra OS - Built-in System Monitor"""
import subprocess

def get_info():
    try:
        cpu = subprocess.check_output("top -bn1 | grep 'Cpu(s)'", shell=True, text=True).strip()
    except: cpu = "CPU info unavailable"
    try:
        mem = subprocess.check_output("free -h", shell=True, text=True).strip()
    except: mem = "Memory info unavailable"
    try:
        disk = subprocess.check_output("df -h /", shell=True, text=True).strip()
    except: disk = "Disk info unavailable"
    try:
        procs = subprocess.check_output("ps aux --sort=-%cpu | head -11", shell=True, text=True).strip()
    except: procs = "Process list unavailable"
    try:
        net = subprocess.check_output("ip -br addr", shell=True, text=True).strip()
    except: net = "Network info unavailable"
    try:
        up = subprocess.check_output("uptime -p", shell=True, text=True).strip()
    except: up = "unknown"
    print("  Vajra OS - System Monitor")
    print(f"  Uptime: {up}")
    print(f"\n  CPU:\n  {cpu}")
    print(f"\n  Memory:\n  {mem}")
    print(f"\n  Disk:\n  {disk}")
    print(f"\n  Network:\n  {net}")
    print(f"\n  Top Processes:\n  {procs}")

if __name__ == "__main__":
    get_info()
