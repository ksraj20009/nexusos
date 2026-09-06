#!/usr/bin/env python3
"""Vajra OS Expense Tracker - Track daily expenses in INR (local, free, offline)."""
import json, datetime
from pathlib import Path

DATA_FILE = Path.home() / ".vajra" / "expenses.json"

def load():
    if DATA_FILE.exists():
        with open(DATA_FILE) as f: return json.load(f)
    return []

def save(data):
    DATA_FILE.parent.mkdir(parents=True, exist_ok=True)
    with open(DATA_FILE, "w") as f: json.dump(data, f, indent=2)

def main():
    print("=" * 50)
    print("  Vajra OS Expense Tracker")
    print("=" * 50)
    expenses = load()
    while True:
        print(f"\n  Total entries: {len(expenses)}")
        print("  1. Add expense  2. View all  3. Summary  4. Exit")
        c = input("  Choice: ").strip()
        if c == "1":
            amount = float(input("  Amount (Rs): ") or "0")
            category = input("  Category (food/transport/bills/etc): ").strip()
            desc = input("  Description: ").strip()
            expenses.append({"amount": amount, "category": category, "desc": desc, "date": datetime.date.today().isoformat()})
            save(expenses)
            print("  [+] Expense added")
        elif c == "2":
            for e in expenses:
                print(f"  {e['date']} | Rs {e['amount']:>8.2f} | {e['category']:15s} | {e['desc']}")
        elif c == "3":
            total = sum(e["amount"] for e in expenses)
            print(f"  Total: Rs {total:.2f}")
            cats = {}
            for e in expenses:
                cats[e["category"]] = cats.get(e["category"], 0) + e["amount"]
            for cat, amt in sorted(cats.items(), key=lambda x: -x[1]):
                print(f"    {cat:15s}: Rs {amt:.2f}")
        elif c == "4":
            break

if __name__ == "__main__":
    main()