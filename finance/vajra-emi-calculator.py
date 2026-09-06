#!/usr/bin/env python3
"""Vajra OS EMI Calculator - Calculate loan EMI (local, free)."""

def calculate_emi(principal, rate, tenure):
    r = rate / 12 / 100
    n = tenure * 12
    if r == 0:
        return principal / n
    emi = principal * r * ((1 + r) ** n) / (((1 + r) ** n) - 1)
    return emi

def main():
    print("=" * 50)
    print("  Vajra OS EMI Calculator")
    print("=" * 50)
    principal = float(input("  Loan amount (Rs): ") or "500000")
    rate = float(input("  Interest rate (%): ") or "8.5")
    tenure = int(input("  Tenure (years): ") or "5")
    emi = calculate_emi(principal, rate, tenure)
    total = emi * tenure * 12
    interest = total - principal
    print(f"\n  Monthly EMI: Rs {emi:.2f}")
    print(f"  Total payment: Rs {total:.2f}")
    print(f"  Total interest: Rs {interest:.2f}")

if __name__ == "__main__":
    main()