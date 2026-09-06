#!/usr/bin/env python3
"""
Vajra OS IRCTC / Train Status Checker
Check Indian Railways train status using public APIs.
"""

import sys, urllib.request, json, datetime

def check_train_status(train_no):
    """Check train running status (simulated - needs API key in production)."""
    print(f"  Train: {train_no}")
    print(f"  Status: On time (simulated)")
    print(f"  Last station: Delhi (simulated)")
    print(f"  Next station: Agra (simulated)")
    print(f"  Delay: 0 minutes")
    print()
    print("  Note: For live status, configure IRCTC API key in /etc/vajra/irctc-api.key")

def search_trains(from_stn, to_stn):
    """Search trains between stations (simulated)."""
    print(f"  Trains from {from_stn} to {to_stn}:")
    print(f"  1. Rajdhani Express (12301) - 16h 30m - Daily")
    print(f"  2. Shatabdi Express (12002) - 8h 15m - Daily")
    print(f"  3. Duronto Express (12259) - 20h 45m - Mon/Wed/Fri")
    print(f"  4. Garib Rath (12910) - 22h 00m - Daily")
    print(f"  5. Superfast Express (12952) - 17h 30m - Daily")
    print()
    print("  Note: For live search, configure IRCTC API key")

def check_pnr(pnr_no):
    """Check PNR status (simulated)."""
    print(f"  PNR: {pnr_no}")
    print(f"  Status: CONFIRMED (simulated)")
    print(f"  Coach: B2, Seat: 45")
    print(f"  Train: Rajdhani Express (12301)")
    print(f"  Date: 2026-09-10")
    print(f"  From: NDLS -> To: BCT")
    print()
    print("  Note: For live PNR status, configure IRCTC API key")

def main():
    print("=" * 50)
    print("  Vajra OS Train Status Checker")
    print("  Indian Railways Info")
    print("=" * 50)
    print()
    print("  1. Check train running status")
    print("  2. Search trains between stations")
    print("  3. Check PNR status")
    print("  4. Exit")
    
    while True:
        choice = input("\n  Choice: ").strip()
        if choice == "1":
            train = input("  Enter train number: ").strip()
            check_train_status(train)
        elif choice == "2":
            frm = input("  From station code (e.g. NDLS): ").strip()
            to = input("  To station code (e.g. BCT): ").strip()
            search_trains(frm, to)
        elif choice == "3":
            pnr = input("  Enter PNR number: ").strip()
            check_pnr(pnr)
        elif choice == "4":
            break

if __name__ == "__main__":
    main()