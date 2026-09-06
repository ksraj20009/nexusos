#!/usr/bin/env python3
"""
Vajra OS Yoga Timer with Asana Guide
Guided yoga sessions with timers and posture descriptions.
"""

import time, sys, os

ASANAS = [
    {"name": "Tadasana (Mountain Pose)", "duration": 30, "desc": "Stand tall, feet together, arms at sides.", "benefits": "Posture, awareness"},
    {"name": "Vrikshasana (Tree Pose)", "duration": 30, "desc": "Stand on one leg, foot on inner thigh, hands in prayer.", "benefits": "Balance, concentration"},
    {"name": "Adho Mukha Svanasana (Downward Dog)", "duration": 45, "desc": "Hands and feet on ground, hips raised. Inverted V.", "benefits": "Stretches hamstrings, calms mind"},
    {"name": "Bhujangasana (Cobra Pose)", "duration": 30, "desc": "Lie on stomach, lift chest with hands.", "benefits": "Strengthens spine, opens chest"},
    {"name": "Balasana (Child's Pose)", "duration": 60, "desc": "Kneel, sit on heels, bend forward.", "benefits": "Relieves stress, calms mind"},
    {"name": "Virabhadrasana (Warrior Pose)", "duration": 30, "desc": "Lunge with one foot forward, arms raised.", "benefits": "Strengthens legs, builds stamina"},
    {"name": "Setu Bandhasana (Bridge Pose)", "duration": 45, "desc": "Lie on back, bend knees, lift hips.", "benefits": "Strengthens back, reduces anxiety"},
    {"name": "Savasana (Corpse Pose)", "duration": 120, "desc": "Lie flat on back, arms at sides, eyes closed.", "benefits": "Deep relaxation, stress relief"},
]

PRANAYAMA = [
    {"name": "Anulom Vilom (Alternate Nostril)", "duration": 120, "desc": "Close right nostril, inhale left. Alternate."},
    {"name": "Bhramari (Bee Breath)", "duration": 60, "desc": "Close ears, hum on exhale."},
    {"name": "Kapalabhati (Skull Shine)", "duration": 60, "desc": "Forceful exhales, rapid belly contractions."},
]

def run_timer(name, duration, desc=""):
    print(f"\n  {name} ({duration}s)")
    if desc: print(f"  How: {desc}")
    for remaining in range(duration, 0, -1):
        mins, secs = remaining // 60, remaining % 60
        print(f"\r  Time: {mins:02d}:{secs:02d}", end="", flush=True)
        time.sleep(1)
    print("\r  Done!                    ")

def main():
    print("=" * 55)
    print("  Vajra OS Yoga Timer")
    print("=" * 55)
    print("\n  1. Full Yoga Session  2. Pranayama  3. Quick Stretch  4. Meditation  5. Browse  6. Exit")
    while True:
        choice = input("\n  Choice: ").strip()
        if choice == "1":
            print("\n  Starting Full Yoga Session...")
            time.sleep(2)
            for asana in ASANAS:
                run_timer(asana["name"], asana["duration"], asana["desc"])
                print(f"  Benefits: {asana['benefits']}")
                time.sleep(3)
            print("\n  Session complete! Namaste.")
        elif choice == "2":
            print("\n  Starting Pranayama...")
            time.sleep(2)
            for pr in PRANAYAMA:
                run_timer(pr["name"], pr["duration"], pr["desc"])
                time.sleep(3)
            print("\n  Pranayama complete!")
        elif choice == "3":
            print("\n  Quick 5-minute stretch...")
            for asana in ASANAS[:4]:
                run_timer(asana["name"], 30, asana["desc"])
                time.sleep(2)
            print("\n  Stretch complete!")
        elif choice == "4":
            mins = int(input("  Meditation duration (minutes): ") or "10")
            run_timer("Meditation", mins * 60, "Sit comfortably, focus on breath")
            print("\n  Meditation complete!")
        elif choice == "5":
            print("\n  --- Asana Guide ---")
            for i, asana in enumerate(ASANAS, 1):
                print(f"  {i}. {asana['name']} ({asana['duration']}s)")
                print(f"     {asana['desc']}")
                print(f"     Benefits: {asana['benefits']}")
        elif choice == "6":
            print("\n  Namaste!")
            break

if __name__ == "__main__":
    main()