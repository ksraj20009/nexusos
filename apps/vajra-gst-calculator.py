#!/usr/bin/env python3
"""
Vajra OS GST Calculator
Calculate GST (Goods and Services Tax) for Indian transactions.
"""

GST_RATES = {"0": 0, "0.25": 0.25, "3": 3, "5": 5, "12": 12, "18": 18, "28": 28}

def calculate_gst(amount, rate, mode="exclusive"):
    rate_pct = GST_RATES.get(str(rate), rate)
    gst_amount = amount * rate_pct / 100
    if mode == "exclusive":
        total = amount + gst_amount
        return {"base": amount, "gst_rate": rate_pct, "gst_amount": gst_amount,
                "cgst": gst_amount/2, "sgst": gst_amount/2, "igst": gst_amount,
                "total": total, "mode": "Exclusive (GST added to base)"}
    else:
        base = amount / (1 + rate_pct / 100)
        gst_amount = amount - base
        return {"base": base, "gst_rate": rate_pct, "gst_amount": gst_amount,
                "cgst": gst_amount/2, "sgst": gst_amount/2, "igst": gst_amount,
                "total": amount, "mode": "Inclusive (GST included in amount)"}

def main():
    print("=" * 50)
    print("  Vajra OS GST Calculator")
    print("  Indian GST (CGST + SGST / IGST)")
    print("=" * 50)
    while True:
        try:
            amount = float(input("\n  Enter amount (Rs): "))
            print("  GST rates: 0%, 0.25%, 3%, 5%, 12%, 18%, 28%")
            rate = input("  Enter GST rate (e.g. 18): ").strip() or "18"
            mode = input("  Mode: (1) Exclusive, (2) Inclusive [1]: ").strip() or "1"
            calc_mode = "exclusive" if mode == "1" else "inclusive"
            r = calculate_gst(amount, rate, calc_mode)
            print(f"\n  --- Results ({r['mode']}) ---")
            print(f"  Base Amount:     Rs {r['base']:.2f}")
            print(f"  GST Rate:        {r['gst_rate']}%")
            print(f"  GST Amount:      Rs {r['gst_amount']:.2f}")
            print(f"    CGST:          Rs {r['cgst']:.2f}")
            print(f"    SGST:          Rs {r['sgst']:.2f}")
            print(f"  IGST:            Rs {r['igst']:.2f}")
            print(f"  Total Amount:    Rs {r['total']:.2f}")
            if input("\n  Calculate another? (y/n): ").strip().lower() != "y":
                break
        except ValueError:
            print("  Invalid input. Please enter numbers.")
        except KeyboardInterrupt:
            break

if __name__ == "__main__":
    main()