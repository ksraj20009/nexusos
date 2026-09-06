#!/usr/bin/env python3
"""Vajra OS AI Sentiment Analyzer - Analyze text emotion (local, free, no API)."""

POSITIVE = ["good", "great", "excellent", "happy", "love", "wonderful", "amazing", "fantastic", "best", "beautiful", "nice", "awesome", "perfect", "superb", "brilliant"]
NEGATIVE = ["bad", "terrible", "hate", "awful", "worst", "sad", "angry", "horrible", "disgusting", "poor", "fail", "stupid", "boring", "ugly", "disappointed"]

def analyze(text):
    text_lower = text.lower()
    pos = sum(1 for w in POSITIVE if w in text_lower)
    neg = sum(1 for w in NEGATIVE if w in text_lower)
    if pos > neg: return "Positive", pos, neg
    elif neg > pos: return "Negative", pos, neg
    else: return "Neutral", pos, neg

def main():
    print("=" * 50)
    print("  Vajra OS AI Sentiment Analyzer (Buddhi)")
    print("=" * 50)
    text = input("  Enter text to analyze: ").strip()
    if not text: return
    sentiment, pos, neg = analyze(text)
    print(f"\n  Sentiment: {sentiment}")
    print(f"  Positive words: {pos}")
    print(f"  Negative words: {neg}")

if __name__ == "__main__":
    main()