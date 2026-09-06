#!/usr/bin/env python3
"""Vajra OS Lightweight Spreadsheet - Simple CSV-based spreadsheet (local, free)."""
import csv
from pathlib import Path

SHEET_DIR = Path.home() / ".vajra" / "sheets"

def main():
    print("=" * 50)
    print("  Vajra OS Spreadsheet")
    print("=" * 50)
    SHEET_DIR.mkdir(parents=True, exist_ok=True)
    print("  1. New sheet  2. Open sheet  3. List sheets  4. Exit")
    c = input("  Choice: ").strip()
    if c == "1":
        name = input("  Sheet name: ").strip() or "untitled"
        path = SHEET_DIR / f"{name}.csv"
        rows = []
        print("  Enter rows (comma-separated). Empty line to finish.")
        while True:
            row = input("  > ").strip()
            if not row: break
            rows.append(row.split(","))
        with open(path, "w", newline="") as f:
            writer = csv.writer(f)
            writer.writerows(rows)
        print(f"  [+] Saved: {path}")
    elif c == "2":
        name = input("  Sheet name: ").strip()
        path = SHEET_DIR / f"{name}.csv"
        if path.exists():
            with open(path) as f:
                for row in csv.reader(f):
                    print("  " + " | ".join(row))
        else:
            print("  [-] Not found")
    elif c == "3":
        for f in SHEET_DIR.glob("*.csv"):
            print(f"  {f.stem}")

if __name__ == "__main__":
    main()