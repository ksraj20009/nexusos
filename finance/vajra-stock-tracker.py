#!/usr/bin/env python3
"""Vajra OS Stock Tracker - Indian markets NSE/BSE (free, NSE website)."""
STOCKS = [
    ("RELIANCE", "Reliance Industries"),
    ("TCS", "Tata Consultancy Services"),
    ("INFY", "Infosys"),
    ("HDFCBANK", "HDFC Bank"),
    ("ICICIBANK", "ICICI Bank"),
    ("SBIN", "State Bank of India"),
    ("BHARTIARTL", "Bharti Airtel"),
    ("ITC", "ITC Limited"),
]

def main():
    print("=" * 55)
    print("  Vajra OS Stock Tracker - Indian Markets")
    print("=" * 55)
    print(f"\n  {'Symbol':12s} {'Company'}")
    print("  " + "-" * 55)
    for sym, name in STOCKS:
        print(f"  {sym:12s} {name}")
    print(f"\n  Note: Use 'xdg-open https://www.nseindia.com/get-quotes/equity?symbol=SYMBOL'")
    print(f"  for live prices, or install a stock ticker app.")
    sym = input("\n  Symbol to check: ").strip()
    if sym:
        import os
        os.system(f"xdg-open https://www.nseindia.com/get-quotes/equity?symbol={sym} 2>/dev/null")

if __name__ == "__main__":
    main()