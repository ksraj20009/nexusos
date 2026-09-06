#!/usr/bin/env python3
"""Vajra OS Currency Converter - INR to world currencies (free API)."""
import urllib.request, json

def get_rates():
    try:
        url = "https://api.exchangerate-api.com/v4/latest/INR"
        req = urllib.request.Request(url, headers={"User-Agent": "VajraOS/1.0"})
        with urllib.request.urlopen(req, timeout=10) as r:
            return json.loads(r.read()).get("rates", {})
    except Exception:
        return None

def main():
    print("=" * 50)
    print("  Vajra OS Currency Converter")
    print("=" * 50)
    rates = get_rates()
    if not rates:
        print("  [-] Could not fetch rates")
        return
    amount = float(input("  Amount in INR: ") or "0")
    print(f"\n  Rs {amount:.2f} equals:")
    for currency in ["USD", "EUR", "GBP", "JPY", "AUD", "CAD", "AED", "SGD", "CNY"]:
        if currency in rates:
            converted = amount * rates[currency]
            print(f"    {currency}: {converted:.2f}")

if __name__ == "__main__":
    main()