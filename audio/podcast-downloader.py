#!/usr/bin/env python3
"""Vajra OS Podcast Directory - Indian podcasts (free, opens in browser)."""
import os

PODCASTS = [
    {"name": "All India Radio News", "url": "https://airnews.in/podcast"},
    {"name": "The Seen and the Unseen", "url": "https://seenunseen.in"},
    {"name": "Puliyabaazi (Hindi)", "url": "https://puliyabaazi.in"},
    {"name": "Pragyan Podcast", "url": "https://pragyan.org/podcast"},
    {"name": "Bhagavad Gita Daily", "url": "https://www.gitadaily.com"},
]

def main():
    print("=" * 50)
    print("  Vajra OS Podcast Directory")
    print("=" * 50)
    for i, p in enumerate(PODCASTS, 1):
        print(f"  {i}. {p['name']}")
    print(f"  {len(PODCASTS)+1}. Exit")
    choice = input("\n  Select podcast: ").strip()
    try:
        idx = int(choice) - 1
        if 0 <= idx < len(PODCASTS):
            p = PODCASTS[idx]
            print(f"\n  {p['name']}")
            print(f"  URL: {p['url']}")
            os.system(f"xdg-open {p['url']} 2>/dev/null")
    except (ValueError, IndexError):
        pass

if __name__ == "__main__":
    main()