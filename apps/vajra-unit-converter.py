#!/usr/bin/env python3
"""Vajra OS Unit Converter - Metric, Imperial, Indian units (local, free)."""

CONVERSIONS = {
    "length": {"meter": 1, "kilometer": 0.001, "centimeter": 100, "mile": 0.000621371, "foot": 3.28084, "inch": 39.3701, "yard": 1.09361},
    "weight": {"kilogram": 1, "gram": 1000, "pound": 2.20462, "ounce": 35.274, "ton": 0.001, "seer": 1.25, "maund": 0.025},
    "temperature": {"celsius": "C", "fahrenheit": "F", "kelvin": "K"},
    "area": {"sqmeter": 1, "sqkilometer": 0.000001, "acre": 0.000247105, "hectare": 0.0001, "bigha": 0.000395369},
    "volume": {"liter": 1, "milliliter": 1000, "gallon": 0.264172, "cubic_meter": 0.001},
}

def main():
    print("=" * 50)
    print("  Vajra OS Unit Converter")
    print("=" * 50)
    for i, cat in enumerate(CONVERSIONS, 1):
        print(f"  {i}. {cat.capitalize()}")
    choice = input("  Category: ").strip()
    cats = list(CONVERSIONS.keys())
    try:
        idx = int(choice) - 1
        cat = cats[idx]
    except (ValueError, IndexError):
        cat = "length"
    units = CONVERSIONS[cat]
    print(f"\n  {cat.capitalize()} units: {', '.join(units.keys())}")
    if cat == "temperature":
        val = float(input("  Value: "))
        from_u = input(f"  From [{list(units.keys())[0]}]: ").strip() or list(units.keys())[0]
        to_u = input(f"  To [{list(units.keys())[1]}]: ").strip() or list(units.keys())[1]
        if from_u == "celsius" and to_u == "fahrenheit": result = val * 9/5 + 32
        elif from_u == "fahrenheit" and to_u == "celsius": result = (val - 32) * 5/9
        elif from_u == "celsius" and to_u == "kelvin": result = val + 273.15
        elif from_u == "kelvin" and to_u == "celsius": result = val - 273.15
        else: result = val
        print(f"  {val} {from_u} = {result:.2f} {to_u}")
    else:
        val = float(input("  Value: "))
        from_u = input(f"  From [{list(units.keys())[0]}]: ").strip() or list(units.keys())[0]
        to_u = input(f"  To [{list(units.keys())[1]}]: ").strip() or list(units.keys())[1]
        base = val / units[from_u]
        result = base * units[to_u]
        print(f"  {val} {from_u} = {result:.4f} {to_u}")

if __name__ == "__main__":
    main()