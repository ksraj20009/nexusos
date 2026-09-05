#!/usr/bin/env python3
"""Vajra OS - Built-in Calculator with Vedic Math mode"""
import sys

def vedic_multiply(a, b):
    """Vedic multiplication using Nikhilam method (base-100)"""
    base = 100
    d1 = a - base
    d2 = b - base
    left = a + d2
    right = d1 * d2
    if d1 < 0 and d2 < 0:
        right = abs(right)
    elif (d1 < 0) != (d2 < 0):
        left = base + right
        right = a * b - left * base
    return left * base + right

def main():
    if len(sys.argv) > 1:
        expr = " ".join(sys.argv[1:])
    else:
        print("Vajra Calculator (type 'quit' to exit)")
        print("Supports: + - * / % ** sqrt() vedic(a,b)")
        while True:
            try:
                expr = input(">>> ").strip()
                if expr.lower() in ["quit", "exit", "q"]:
                    break
                if not expr:
                    continue
                if expr.startswith("vedic("):
                    import re
                    m = re.match(r"vedic\((\d+),\s*(\d+)\)", expr)
                    if m:
                        a, b = int(m.group(1)), int(m.group(2))
                        print(f"  Vedic multiply: {a} x {b} = {vedic_multiply(a, b)}")
                        continue
                if "sqrt" in expr:
                    expr = expr.replace("sqrt", "__import__('math').sqrt")
                result = eval(expr, {"__builtins__": {"abs": abs, "round": round, "min": min, "max": max, "pow": pow, "int": int, "float": float}})
                print(f"  = {result}")
            except Exception as e:
                print(f"  Error: {e}")
        return
    try:
        if "sqrt" in expr:
            expr = expr.replace("sqrt", "__import__('math').sqrt")
        result = eval(expr, {"__builtins__": {"abs": abs, "round": round, "min": min, "max": max, "pow": pow, "int": int, "float": float}})
        print(result)
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()
