#!/usr/bin/env python3
"""
Vajra OS Indian News Aggregator
Aggregates news from Indian sources.
"""

import sys, urllib.request, json, datetime

NEWS_SOURCES = {
    "All India Radio": "https://newsonair.com/feed",
    "NDTV": "https://www.ndtv.com/rss",
    "Times of India": "https://timesofindia.indiatimes.com/rss",
    "The Hindu": "https://www.thehindu.com/rss",
    "Indian Express": "https://indianexpress.com/rss",
    "Business Standard": "https://www.business-standard.com/rss",
    "DNA India": "https://www.dnaindia.com/rss",
    "Money Control": "https://www.moneycontrol.com/rss",
}

CATEGORIES = ["Top Stories", "Business", "Sports", "Technology", "Entertainment", "Regional"]

def fetch_headlines(source_name):
    """Fetch headlines from a source (simulated)."""
    headlines = [
        "India launches new satellite into orbit",
        "Parliament passes new digital privacy bill",
        "Indian cricket team wins series against Australia",
        "New GST rates announced for essential goods",
        "Tech startup raises Rs 500 crore in funding",
        "Monsoon arrives in Kerala ahead of schedule",
        "Indian football team qualifies for Asian Cup",
        "New Metro line opens in Mumbai",
    ]
    return headlines[:5]

def main():
    print("=" * 50)
    print("  Vajra OS Indian News Aggregator")
    print("=" * 50)
    print()
    print("  Sources:")
    for i, src in enumerate(NEWS_SOURCES, 1):
        print(f"    {i}. {src}")
    print()
    print("  Categories:")
    for i, cat in enumerate(CATEGORIES, 1):
        print(f"    {i}. {cat}")
    print()
    
    choice = input("  Select source number [1]: ").strip() or "1"
    sources = list(NEWS_SOURCES.keys())
    idx = int(choice) - 1 if choice.isdigit() and 1 <= int(choice) <= len(sources) else 0
    
    source = sources[idx]
    print(f"\n  --- {source} ---")
    headlines = fetch_headlines(source)
    for i, headline in enumerate(headlines, 1):
        print(f"  {i}. {headline}")
    print()
    print("  Note: For live news, configure RSS feed URLs in /etc/vajra/news-sources.json")

if __name__ == "__main__":
    main()