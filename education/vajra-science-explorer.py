#!/usr/bin/env python3
"""Vajra OS Science Explorer - ISRO missions and Indian science (local, free)."""

ISRO_MISSIONS = [
    {"name": "Chandrayaan-3", "year": 2023, "desc": "First spacecraft to land on lunar south pole"},
    {"name": "Mangalyaan (MOM)", "year": 2013, "desc": "First Asian mission to reach Mars orbit"},
    {"name": "Aryabhata", "year": 1975, "desc": "India's first satellite"},
    {"name": "PSLV", "year": 1994, "desc": "Workhorse launch vehicle, 50+ successful launches"},
    {"name": "GSLV Mk III", "year": 2014, "desc": "Heavy-lift launch vehicle"},
    {"name": "NavIC", "year": 2018, "desc": "India's own GPS alternative (7 satellites)"},
    {"name": "Aditya-L1", "year": 2023, "desc": "First Indian solar observation mission"},
]

SCIENTISTS = [
    {"name": "C.V. Raman", "field": "Physics", "desc": "Nobel Prize 1930 - Raman Effect"},
    {"name": "Homi Bhabha", "field": "Nuclear Physics", "desc": "Father of Indian nuclear program"},
    {"name": "Vikram Sarabhai", "field": "Space", "desc": "Father of Indian space program"},
    {"name": "A.P.J. Abdul Kalam", "field": "Aerospace", "desc": "Missile Man of India, President"},
    {"name": "Srinivasa Ramanujan", "field": "Mathematics", "desc": "Self-taught genius, number theory"},
    {"name": "Jagadish Chandra Bose", "field": "Physics/Botany", "desc": "Pioneer of radio and plant science"},
]

def main():
    print("=" * 55)
    print("  Vajra OS Science Explorer - India in Science")
    print("=" * 55)
    print("\n  1. ISRO Missions")
    print("  2. Indian Scientists")
    print("  3. Exit")
    c = input("  Choice: ").strip()
    if c == "1":
        print(f"\n  {'Mission':20s} {'Year':6s} {'Description'}")
        print("  " + "-" * 55)
        for m in ISRO_MISSIONS:
            print(f"  {m['name']:20s} {m['year']:6d} {m['desc']}")
    elif c == "2":
        print(f"\n  {'Name':25s} {'Field':20s} {'Description'}")
        print("  " + "-" * 55)
        for s in SCIENTISTS:
            print(f"  {s['name']:25s} {s['field']:20s} {s['desc']}")

if __name__ == "__main__":
    main()