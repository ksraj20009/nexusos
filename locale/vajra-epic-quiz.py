#!/usr/bin/env python3
"""Vajra OS Epic Quiz - Ramayana and Mahabharata quiz (local, free)."""

QUIZ = [
    {"q": "Who is the hero of the Ramayana?", "a": ["Rama", "Krishna", "Arjuna", "Yudhishthira"], "correct": 0},
    {"q": "Who wrote the Mahabharata?", "a": ["Valmiki", "Vyasa", "Tulsidas", "Kalidasa"], "correct": 1},
    {"q": "How many Kaurava brothers were there?", "a": ["100", "99", "101", "50"], "correct": 0},
    {"q": "What is Rama's bow called?", "a": ["Gandiva", "Sharanga", "Kodanda", "Pinaka"], "correct": 2},
    {"q": "Who was Arjuna's charioteer?", "a": ["Bhishma", "Drona", "Krishna", "Karna"], "correct": 2},
    {"q": "What is the name of Hanuman's father?", "a": ["Vayu", "Surya", "Agni", "Indra"], "correct": 0},
    {"q": "How many chapters are in the Bhagavad Gita?", "a": ["12", "18", "24", "108"], "correct": 1},
    {"q": "Who is the wife of Rama?", "a": ["Draupadi", "Sita", "Rukmini", "Radha"], "correct": 1},
    {"q": "What was Karna's divine armor called?", "a": ["Kavach Kundal", "Divya Astra", "Vajra", "Chakra"], "correct": 0},
    {"q": "Who built the bridge to Lanka?", "a": ["Rama", "Hanuman", "Nala", "Sugriva"], "correct": 2},
]

def main():
    print("=" * 55)
    print("  Vajra OS Epic Quiz - Ramayana & Mahabharata")
    print("=" * 55)
    score = 0
    for i, q in enumerate(QUIZ, 1):
        print(f"\n  Q{i}: {q['q']}")
        for j, a in enumerate(q['a'], 1):
            print(f"    {j}. {a}")
        ans = input("  Answer: ").strip()
        try:
            if int(ans) - 1 == q['correct']:
                print("  Correct!"); score += 1
            else:
                print(f"  Answer: {q['a'][q['correct']]}")
        except: print(f"  Answer: {q['a'][q['correct']]}")
    print(f"\n  Score: {score}/{len(QUIZ)}")
    if score == len(QUIZ): print("  Perfect! You know your epics!")
    elif score >= 7: print("  Well done!")
    else: print("  Read more about our epics!")

if __name__ == "__main__":
    main()