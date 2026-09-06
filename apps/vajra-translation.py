#!/usr/bin/env python3
"""Vajra OS Translation - Indian language translator (free Google API)."""
import urllib.request, urllib.parse, json

LANGUAGES = {
    "1": ("English", "en"), "2": ("Hindi", "hi"), "3": ("Bengali", "bn"),
    "4": ("Tamil", "ta"), "5": ("Telugu", "te"), "6": ("Marathi", "mr"),
    "7": ("Gujarati", "gu"), "8": ("Kannada", "kn"), "9": ("Malayalam", "ml"),
    "10": ("Punjabi", "pa"), "11": ("Urdu", "ur"), "12": ("Sanskrit", "sa"),
}

def translate(text, source, target):
    try:
        url = f"https://translate.googleapis.com/translate_a/single?client=gtx&sl={source}&tl={target}&dt=t&q={urllib.parse.quote(text)}"
        req = urllib.request.Request(url, headers={"User-Agent": "VajraOS/1.0"})
        with urllib.request.urlopen(req, timeout=10) as r:
            data = json.loads(r.read())
        return "".join(s[0] for s in data[0] if s[0])
    except Exception:
        return None

def main():
    print("=" * 50)
    print("  Vajra OS Translator")
    print("=" * 50)
    print("\n  Source language:")
    for k, (name, code) in LANGUAGES.items():
        print(f"    {k}. {name}")
    src = input("  Source [1]: ").strip() or "1"
    tgt = input("  Target [2]: ").strip() or "2"
    text = input("  Text to translate: ").strip()
    if not text: return
    src_lang = LANGUAGES.get(src, ("English", "en"))[1]
    tgt_lang = LANGUAGES.get(tgt, ("Hindi", "hi"))[1]
    result = translate(text, src_lang, tgt_lang)
    if result:
        print(f"\n  Translation: {result}")
    else:
        print("  [-] Translation failed. Check internet.")

if __name__ == "__main__":
    main()