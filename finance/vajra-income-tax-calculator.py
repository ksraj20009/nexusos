#!/usr/bin/env python3
"""Vajra OS Income Tax Calculator - New FY 2024-25 regime (local, free)."""

SLABS_NEW = [
    (300000, 0),
    (600000, 5),
    (900000, 10),
    (1200000, 15),
    (1500000, 20),
    (float('inf'), 30),
]

def calculate_tax(income):
    tax = 0
    prev_limit = 0
    for limit, rate in SLABS_NEW:
        if income > limit:
            tax += (limit - prev_limit) * rate / 100
            prev_limit = limit
        else:
            tax += (income - prev_limit) * rate / 100
            break
    cess = tax * 0.04  # Health and Education Cess 4%
    return tax + cess

def main():
    print("=" * 50)
    print("  Vajra OS Income Tax Calculator (New Regime FY 2024-25)")
    print("=" * 50)
    income = float(input("  Annual income (Rs): ") or "1000000")
    tax = calculate_tax(income)
    take_home = income - tax
    print(f"\n  Annual income: Rs {income:,.2f}")
    print(f"  Tax (incl 4% cess): Rs {tax:,.2f}")
    print(f"  Take home: Rs {take_home:,.2f}")
    print(f"  Effective rate: {tax*100/income:.1f}%")

if __name__ == "__main__":
    main()