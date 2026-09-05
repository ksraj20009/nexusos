#!/usr/bin/env python3
"""
Vajra OS — Vedic Calculator
Ancient Indian mathematical shortcuts
"""

import sys

def vedic_multiply(a, b):
    """Nikhilam multiplication (Vedic sutra)"""
    base = 1
    while base < max(a, b):
        base *= 10
    da = a - base
    db = b - base
    left = a + db
    right = da * db
    if base > 1:
        right_str = str(abs(right)).zfill(len(str(base)))
        if len(right_str) > len(str(base)):
            left += int(right_str[:-len(str(base))])
            right = int(right_str[-len(str(base)):])
    if right < 0:
        return left * base + right
    return left * base + right

def digit_sum(n):
    """Digital root — used in Vedic verification"""
    n = abs(n)
    while n >= 10:
        n = sum(int(d) for d in str(n))
    return n

def vedic_check(a, b, result):
    """Verify multiplication using digit sum (casting out nines)"""
    return digit_sum(a) * digit_sum(b) % 9 == digit_sum(result) % 9

def ekadhikena_purvena(n):
    """Square of numbers ending in 5 (Ekadhikena Purvena)"""
    if n % 10 != 5:
        return n * n
    prefix = n // 10
    return (prefix * (prefix + 1)) * 100 + 25

def urdhva_tiryagbhyam(a, b):
    """Vertically and Crosswise multiplication"""
    digits_a = [int(d) for d in str(a)]
    digits_b = [int(d) for d in str(b)]
    max_len = max(len(digits_a), len(digits_b))
    digits_a = [0] * (max_len - len(digits_a)) + digits_a
    digits_b = [0] * (max_len - len(digits_b)) + digits_b
    result = [0] * (2 * max_len - 1)
    for i in range(max_len):
        for j in range(max_len):
            result[i + j] += digits_a[i] * digits_b[j]
    carry = 0
    for i in range(len(result) - 1, -1, -1):
        result[i] += carry
        carry = result[i] // 10
        result[i] %= 10
    while len(result) > 1 and result[0] == 0:
        result.pop(0)
    return int(''.join(str(d) for d in result))

def show_menu():
    print("""
  ============================================
    Vajra OS - Vedic Calculator
    Ancient Indian Math
  ============================================

    1. Multiply (Urdhva Tiryagbhyam)
    2. Square (Ekadhikena Purvena)
    3. Digital Root (Navasesa)
    4. Verify Multiplication
    5. Nikhilam Multiply
    6. Quick Tricks
    0. Exit
""")

def main():
    if len(sys.argv) > 1 and sys.argv[1] != "--menu":
        cmd = sys.argv[1]
        if cmd == "multiply" and len(sys.argv) >= 4:
            a, b = int(sys.argv[2]), int(sys.argv[3])
            result = urdhva_tiryagbhyam(a, b)
            print(f"  Urdhva Tiryagbhyam: {a} x {b} = {result}")
            print(f"  Verify: {digit_sum(a)} x {digit_sum(b)} = {digit_sum(result)} (mod 9)")
        elif cmd == "square" and len(sys.argv) >= 3:
            n = int(sys.argv[2])
            print(f"  Ekadhikena Purvena: {n}^2 = {ekadhikena_purvena(n)}")
        elif cmd == "root" and len(sys.argv) >= 3:
            n = int(sys.argv[2])
            print(f"  Digital root of {n} = {digit_sum(n)}")
        elif cmd == "tricks":
            print("""
  Vedic Math Quick Tricks:

  1. Multiply by 11: Write sum of adjacent digits
     42 x 11 = 4(4+2)2 = 462

  2. Square numbers ending in 5:
     25^2 = 2x3|25 = 625
     75^2 = 7x8|25 = 5625

  3. Multiply near 100:
     98 x 97 = (98-3)|(2x3) = 95|06 = 9506

  4. Digital root (verify any calculation):
     23 x 45 = 1035 -> (2+3)x(4+5)=45 -> 4+5=9 -> 1+0+3+5=9
""")
        else:
            print("Usage: vajra-vedic {multiply <a> <b>|square <n>|root <n>|tricks}")
        return

    while True:
        show_menu()
        choice = input("  Select [0-6]: ").strip()
        if choice == "0":
            print("Namaste!")
            break
        elif choice == "1":
            a = int(input("  First number: "))
            b = int(input("  Second number: "))
            result = urdhva_tiryagbhyam(a, b)
            print(f"\n  {a} x {b} = {result}")
            print(f"  Verified: digital root = {digit_sum(result)}")
        elif choice == "2":
            n = int(input("  Number to square: "))
            print(f"\n  {n}^2 = {ekadhikena_purvena(n)}")
        elif choice == "3":
            n = int(input("  Number: "))
            print(f"\n  Digital root of {n} = {digit_sum(n)}")
        elif choice == "4":
            a = int(input("  First number: "))
            b = int(input("  Second number: "))
            r = int(input("  Result to verify: "))
            ok = vedic_check(a, b, r)
            print(f"\n  {'Correct!' if ok else 'Incorrect!'}")
        elif choice == "5":
            a = int(input("  First number: "))
            b = int(input("  Second number: "))
            print(f"\n  Nikhilam: {a} x {b} = {vedic_multiply(a, b)}")
        elif choice == "6":
            print("""
  Vedic Math Tricks:
  1. x 11: Write sum of adjacent digits (42 x 11 = 462)
  2. Square ending in 5: 25^2 = 2x3|25 = 625
  3. Near 100: 98 x 97 = 9506
  4. Digital root: sum digits until single digit
""")
        input("\n  Press Enter to continue...")

if __name__ == "__main__":
    main()
