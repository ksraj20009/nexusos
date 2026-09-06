#!/usr/bin/env python3
"""Vajra OS Presentation Maker - Simple slide creator with HTML export (local, free)."""
import json
from pathlib import Path

SLIDE_DIR = Path.home() / ".vajra" / "presentations"

def main():
    print("=" * 50)
    print("  Vajra OS Presentation Maker")
    print("=" * 50)
    SLIDE_DIR.mkdir(parents=True, exist_ok=True)
    print("  1. New presentation  2. View  3. List  4. Export to HTML  5. Exit")
    c = input("  Choice: ").strip()
    if c == "1":
        name = input("  Presentation name: ").strip() or "untitled"
        slides = []
        while True:
            title = input("  Slide title (empty to stop): ").strip()
            if not title: break
            content = input("  Slide content: ").strip()
            slides.append({"title": title, "content": content})
        path = SLIDE_DIR / f"{name}.json"
        with open(path, "w") as f:
            json.dump(slides, f, indent=2)
        print(f"  [+] {len(slides)} slides saved to {path}")
    elif c == "2":
        name = input("  Name: ").strip()
        path = SLIDE_DIR / f"{name}.json"
        if path.exists():
            with open(path) as f:
                slides = json.load(f)
            for i, s in enumerate(slides, 1):
                print(f"\n  --- Slide {i} ---")
                print(f"  {s['title']}")
                print(f"  {s['content']}")
        else:
            print("  [-] Not found")
    elif c == "3":
        for f in SLIDE_DIR.glob("*.json"):
            print(f"  {f.stem}")
    elif c == "4":
        name = input("  Name: ").strip()
        path = SLIDE_DIR / f"{name}.json"
        if path.exists():
            with open(path) as f:
                slides = json.load(f)
            html = "<html><body>"
            for s in slides:
                html += f"<h1>{s['title']}</h1><p>{s['content']}</p><hr>"
            html += "</body></html>"
            out = SLIDE_DIR / f"{name}.html"
            with open(out, "w") as f:
                f.write(html)
            print(f"  [+] Exported: {out}")

if __name__ == "__main__":
    main()