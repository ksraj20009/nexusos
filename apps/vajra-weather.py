#!/usr/bin/env python3
"""Vajra OS - Built-in Weather App (using wttr.in)"""
import urllib.request, sys

def get_weather(location=""):
    try:
        url = f"https://wttr.in/{location}?format=3"
        req = urllib.request.Request(url, headers={"User-Agent": "curl/7.68.0"})
        with urllib.request.urlopen(req, timeout=10) as r:
            data = r.read().decode('utf-8').strip()
        print(f"  Vajra Weather: {data}")
        url2 = f"https://wttr.in/{location}?0"
        req2 = urllib.request.Request(url2, headers={"User-Agent": "curl/7.68.0"})
        with urllib.request.urlopen(req2, timeout=10) as r:
            print(r.read().decode('utf-8'))
    except Exception as e:
        print(f"  Weather unavailable: {e}")

if __name__ == "__main__":
    loc = " ".join(sys.argv[1:]) if len(sys.argv) > 1 else ""
    get_weather(loc)
