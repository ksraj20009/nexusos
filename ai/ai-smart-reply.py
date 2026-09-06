#!/usr/bin/env python3
"""Vajra OS AI Smart Reply - Generate quick replies (local, free, no API)."""

REPLIES = {
    "greeting": ["Namaste! How can I help?", "Hello! What can I do for you?", "Hi there! How are you?"],
    "thanks": ["You're welcome!", "My pleasure!", "Anytime!"],
    "bye": ["See you soon!", "Take care!", "Until next time!"],
    "yes": ["Absolutely!", "Of course!", "Sure thing!"],
    "no": ["I understand.", "No problem.", "That's okay."],
    "question": ["Let me check that for you.", "Good question! Let me think...", "I'll look into it."],
    "apology": ["No worries at all!", "It's completely fine.", "Don't mention it!"],
}

def detect_intent(text):
    t = text.lower()
    if any(w in t for w in ["hello", "hi", "namaste", "hey"]): return "greeting"
    if any(w in t for w in ["thank", "thanks", "dhanyavaad"]): return "thanks"
    if any(w in t for w in ["bye", "goodbye", "alvida"]): return "bye"
    if "yes" in t or "ok" in t or "sure" in t: return "yes"
    if "no" in t or "nope" in t: return "no"
    if "?" in t: return "question"
    if "sorry" in t or "apolog" in t: return "apology"
    return "greeting"

def main():
    print("=" * 50)
    print("  Vajra OS AI Smart Reply (Buddhi)")
    print("=" * 50)
    msg = input("  Received message: ").strip()
    if not msg: return
    intent = detect_intent(msg)
    replies = REPLIES.get(intent, REPLIES["greeting"])
    print(f"\n  Intent: {intent}")
    print(f"  Suggested replies:")
    for i, r in enumerate(replies, 1):
        print(f"    {i}. {r}")

if __name__ == "__main__":
    main()