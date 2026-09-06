#!/usr/bin/env python3
"""Vajra OS RSS Reader - Read Indian news feeds (free, no API key)."""
import urllib.request, xml.etree.ElementTree as ET

FEEDS = [
    ("Times of India", "https://timesofindia.indiatimes.com/rssfeeds/-2128936835.cms"),
    ("The Hindu", "https://www.thehindu.com/news/national/feeder/default.rss"),
    ("NDTV", "https://feeds.ndtv.com/ndtv/news/top-news"),
    ("Indian Express", "https://indianexpress.com/feed/"),
]

def fetch_feed(url):
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "VajraOS/1.0"})
        with urllib.request.urlopen(req, timeout=10) as r:
            tree = ET.parse(r)
        items = []
        for item in tree.findall(".//item")[:10]:
            title = item.findtext("title", "")
            link = item.findtext("link", "")
            items.append((title, link))
        return items
    except Exception:
        return None

def main():
    print("=" * 50)
    print("  Vajra OS RSS Reader")
    print("=" * 50)
    for i, (name, _) in enumerate(FEEDS, 1):
        print(f"  {i}. {name}")
    choice = input("\n  Select feed [1]: ").strip() or "1"
    try: idx = int(choice) - 1
    except: idx = 0
    if 0 <= idx < len(FEEDS):
        name, url = FEEDS[idx]
        print(f"\n  --- {name} ---")
        items = fetch_feed(url)
        if items:
            for j, (title, link) in enumerate(items, 1):
                print(f"  {j}. {title}")
        else:
            print("  [-] Could not fetch feed")

if __name__ == "__main__":
    main()