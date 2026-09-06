#!/usr/bin/env python3
"""Vajra OS Quiz App - General knowledge about India (local, free)."""

QUIZZES = [
    {"q": "What is the capital of India?", "options": ["Mumbai", "New Delhi", "Kolkata", "Chennai"], "answer": 1},
    {"q": "How many states are in India?", "options": ["27", "28", "29", "30"], "answer": 1},
    {"q": "Who wrote the Indian national anthem?", "options": ["Gandhi", "Tagore", "Nehru", "Bose"], "answer": 1},
    {"q": "What is the national animal of India?", "options": ["Lion", "Elephant", "Tiger", "Peacock"], "answer": 2},
    {"q": "Which is the longest river in India?", "options": ["Yamuna", "Ganga", "Godavari", "Narmada"], "answer": 1},
    {"q": "What is the currency of India?", "options": ["Dollar", "Rupee", "Taka", "Rial"], "answer": 1},
    {"q": "Which festival is called the festival of colors?", "options": ["Diwali", "Holi", "Navratri", "Pongal"], "answer": 1},
    {"q": "Who was the first PM of India?", "options": ["Gandhi", "Patel", "Nehru", "Ambedkar"], "answer": 2},
]

def main():
    print("=" * 50)
    print("  Vajra OS Quiz - India GK")
    print("=" * 50)
    score = 0
    for i, q in enumerate(QUIZZES, 1):
        print(f"\n  Q{i}: {q['q']}")
        for j, opt in enumerate(q['options']):
            print(f"    {j+1}. {opt}")
        ans = input("  Answer: ").strip()
        try:
            if int(ans) - 1 == q['answer']:
                print("  Correct!")
                score += 1
            else:
                print(f"  Wrong. Answer: {q['options'][q['answer']]}")
        except (ValueError, IndexError):
            print(f"  Wrong. Answer: {q['options'][q['answer']]}")
    print(f"\n  Score: {score}/{len(QUIZZES)}")
    if score == len(QUIZZES): print("  Perfect! Bharat Mata Ki Jai!")
    elif score >= 6: print("  Great job!")
    else: print("  Keep learning!")

if __name__ == "__main__":
    main()