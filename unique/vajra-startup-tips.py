#!/usr/bin/env python3
"""Vajra OS Startup Tips - Shows useful tips on every login."""
import random, datetime

TIPS = [
    "Press Super+A to ask Buddhi AI anything.",
    "Press Super+Space to switch between English and Hindi keyboards.",
    "Type 'sudo vj-update' in terminal to update your system.",
    "Use 'vj-ai' in terminal to start Buddhi AI assistant.",
    "Press Ctrl+Alt+T to open terminal quickly.",
    "Type 'vj-panchang' to see today's Hindu calendar.",
    "Use 'vj-gst' to calculate GST on any amount.",
    "Press Super+L to lock your screen instantly.",
    "Type 'vj-weather' to check weather in your city.",
    "Use 'vj-yoga' to start a guided yoga session.",
    "Type 'vj-sec' to run a security scan on your system.",
    "Use 'vj-train' to check Indian Railways train status.",
    "Press Super+V to toggle voice control.",
    "Type 'vj-news' to read latest Indian news headlines.",
    "Use 'vj-ayurveda' to look up Ayurvedic remedies.",
    "Enable firewall: sudo ufw enable (protects from hackers).",
    "Back up regularly: vj-backup in terminal.",
    "Use 'vj-vedic' to learn Vedic math tricks!",
    "Two modes: Beginner (safe) and Pro (full access).",
    "Type 'buddhi' in any terminal for AI assistance.",
]

SECURITY_TIPS = [
    "Check your security score: vj-sec-dashboard",
    "Enable fail2ban to block brute-force SSH attacks.",
    "Use strong passwords: at least 12 characters.",
    "Enable disk encryption for sensitive data.",
    "Keep your system updated for security patches.",
]

INDIAN_TIPS = [
    "Today's Panchang: vj-panchang",
    "GST calculator: vj-gst",
    "Train status: vj-train",
    "News headlines: vj-news",
    "Vedic math: vj-vedic",
    "Yoga timer: vj-yoga",
    "Ayurveda guide: vj-ayurveda",
]

def main():
    today = datetime.date.today()
    print()
    print("  " + "=" * 50)
    print(f"  Welcome to Vajra OS!")
    print(f"  {today.strftime('%A, %d %B %Y')}")
    print("  " + "=" * 50)
    print()
    tip = random.choice(TIPS)
    print(f"  Tip: {tip}")
    print()
    if random.random() < 0.3:
        st = random.choice(SECURITY_TIPS)
        print(f"  Security: {st}")
        print()
    if random.random() < 0.3:
        it = random.choice(INDIAN_TIPS)
        print(f"  Indian Feature: {it}")
        print()

if __name__ == "__main__":
    main()