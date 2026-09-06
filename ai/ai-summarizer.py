#!/usr/bin/env python3
"""Vajra OS AI Summarizer - Buddhi summarizes text (local, free, no API)."""
import re

def summarize(text, sentences=3):
    words = text.split()
    if len(words) < 20: return text
    freq = {}
    for w in words:
        w_clean = re.sub(r'[^a-zA-Z]', '', w.lower())
        if len(w_clean) > 3: freq[w_clean] = freq.get(w_clean, 0) + 1
    sents = text.split(". ")
    scored = []
    for s in sents:
        score = sum(freq.get(re.sub(r'[^a-zA-Z]', '', w.lower()), 0) for w in s.split())
        scored.append((score, s))
    scored.sort(reverse=True)
    return ". ".join(s for _, s in scored[:sentences])

def main():
    print("=" * 50)
    print("  Vajra OS AI Summarizer (Buddhi)")
    print("=" * 50)
    print("  Paste text to summarize (empty line to finish):")
    lines = []
    while True:
        line = input("  > ")
        if not line: break
        lines.append(line)
    text = " ".join(lines)
    if not text: return
    n = int(input("  Summary length (sentences) [3]: ") or "3")
    summary = summarize(text, n)
    print(f"\n  Summary:\n  {summary}")

if __name__ == "__main__":
    main()