#!/usr/bin/env python3
"""Vajra OS Jyotish (Vedic Astrology) Calculator - Basic Rashi (Zodiac) (local, free)."""

RASHIS = [
    {"name": "Mesha (Aries)", "range": (3, 21, 4, 19), "element": "Fire", "lord": "Mars", "traits": "Bold, energetic, leadership"},
    {"name": "Vrishabha (Taurus)", "range": (4, 20, 5, 20), "element": "Earth", "lord": "Venus", "traits": "Patient, reliable, practical"},
    {"name": "Mithuna (Gemini)", "range": (5, 21, 6, 20), "element": "Air", "lord": "Mercury", "traits": "Communicative, curious, adaptable"},
    {"name": "Karka (Cancer)", "range": (6, 21, 7, 22), "element": "Water", "lord": "Moon", "traits": "Emotional, nurturing, intuitive"},
    {"name": "Simha (Leo)", "range": (7, 23, 8, 22), "element": "Fire", "lord": "Sun", "traits": "Confident, generous, charismatic"},
    {"name": "Kanya (Virgo)", "range": (8, 23, 9, 22), "element": "Earth", "lord": "Mercury", "traits": "Analytical, precise, helpful"},
    {"name": "Tula (Libra)", "range": (9, 23, 10, 22), "element": "Air", "lord": "Venus", "traits": "Diplomatic, balanced, social"},
    {"name": "Vrishchika (Scorpio)", "range": (10, 23, 11, 21), "element": "Water", "lord": "Mars", "traits": "Intense, passionate, determined"},
    {"name": "Dhanu (Sagittarius)", "range": (11, 22, 12, 21), "element": "Fire", "lord": "Jupiter", "traits": "Optimistic, philosophical, adventurous"},
    {"name": "Makara (Capricorn)", "range": (12, 22, 1, 19), "element": "Earth", "lord": "Saturn", "traits": "Disciplined, ambitious, patient"},
    {"name": "Kumbha (Aquarius)", "range": (1, 20, 2, 18), "element": "Air", "lord": "Saturn", "traits": "Independent, humanitarian, innovative"},
    {"name": "Meena (Pisces)", "range": (2, 19, 3, 20), "element": "Water", "lord": "Jupiter", "traits": "Compassionate, artistic, intuitive"},
]

def get_rashi(month, day):
    for r in RASHIS:
        sm, sd, em, ed = r["range"]
        if sm <= month <= em:
            if sm == em:
                if sd <= day <= ed: return r
            elif month == sm and day >= sd: return r
            elif month == em and day <= ed: return r
            elif sm < month < em: return r
    return RASHIS[-1]

def main():
    print("=" * 55)
    print("  Vajra OS Jyotish Calculator (Vedic Rashi)")
    print("=" * 55)
    dob = input("  Birth date (DD/MM): ").strip()
    try:
        day, month = map(int, dob.split("/"))
    except:
        print("  Use format DD/MM (e.g. 15/08)")
        return
    rashi = get_rashi(month, day)
    print(f"\n  Your Rashi: {rashi['name']}")
    print(f"  Element: {rashi['element']}")
    print(f"  Lord: {rashi['lord']}")
    print(f"  Traits: {rashi['traits']}")

if __name__ == "__main__":
    main()