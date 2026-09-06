#!/usr/bin/env python3
"""Vajra OS AI Translator - Buddhi translates between languages (free Google API)."""
import urllib.request, urllib.parse, json

LANGS = {"1": "en", "2": "hi", "3": "bn", "4": "ta", "5": "te", "6": "mr", "7": "gu", "8": "kn", "9": "ml", "10": "pa", "11": "ur", "12": "sa"}
LANG_NAMES = {"en": "English", "hi": "Hindi", "bn": "Bengali", "ta": "Tamil", "te": "Telugu", "mr": "Marathi", "gu": "Gujarati", "kn": "Kannada", "ml": "Malayalam", "pa": "Punjabi", "ur": "Urdu", "sa": "Sanskrit"}

def translate(text, src, tgt):
    try:
        url = f"https://translate.googleapis.com/translate_a/single?client=gtx&sl={src}&tl={tgt}&dt=t&q={urllib.parse.quote(text)}"
        req = urllib.request.Request(url, headers={"User-Agent": "VajraOS/1.0"})
        with urllib.request.urlopen(req, timeout=10) as r:
            data = json.loads(r.read())
        return "".join(s[0] for s in data[0] if s[0])
    except: return None

def main():
    print("=" * 50)
    print("  Vajra OS AI Translator (Buddhi)")
    print("=" * 50)
    text = input("  Text to translate: ").strip()
    if not text: return
    print("\n  From:")
    for k, v in LANGS.items(): print(f"    {k}. {LANG_NAMES[v]}")
    src = LANGS.get(input("  Source [1]: ").strip() or "1", "en")
    tgt = LANGS.get(input("  Target [2]: ").strip() or "2", "hi")
    result = translate(text, src, tgt)
    if result:
        print(f"\n  {LANG_NAMES[src]} -> {LANG_NAMES[tgt]}:")
        print(f"  {result}")
    else:
        print("  [-] Translation failed")

if __name__ == "__main__":
    main()