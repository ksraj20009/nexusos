#!/usr/bin/env python3
"""Vajra OS Password Generator - Secure password creation (local, free)."""
import random, string

def generate(length=16, upper=True, lower=True, digits=True, symbols=True, no_ambiguous=True):
    chars = ""
    if upper: chars += string.ascii_uppercase
    if lower: chars += string.ascii_lowercase
    if digits: chars += string.digits
    if symbols: chars += "!@#$%^&*()-_=+[]{}|;:,.<>?"
    if no_ambiguous:
        chars = chars.replace("0", "").replace("O", "").replace("l", "").replace("1", "").replace("I", "")
    if not chars: chars = string.ascii_letters + string.digits
    return "".join(random.choice(chars) for _ in range(length))

def main():
    print("=" * 50)
    print("  Vajra OS Password Generator")
    print("=" * 50)
    length = input("  Length [16]: ").strip()
    try: length = int(length) if length else 16
    except: length = 16
    count = input("  How many passwords [5]: ").strip()
    try: count = int(count) if count else 5
    except: count = 5
    print()
    for i in range(count):
        pwd = generate(length=length)
        strength = "Strong" if length >= 16 else "Medium" if length >= 10 else "Weak"
        print(f"  {i+1}. {pwd}  [{strength}]")

if __name__ == "__main__":
    main()