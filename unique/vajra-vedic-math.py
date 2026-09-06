#!/usr/bin/env python3
"""Vajra OS Vedic Math Trainer - Learn mental math tricks from ancient Indian mathematics."""

TRICKS = [
    {"name": "Squaring numbers ending in 5", "trick": "n5^2 = n*(n+1) followed by 25",
     "example": "35^2 = 3*4=12, so 1225", "test": "What is 75^2?", "answer": 5625},
    {"name": "Multiply by 11", "trick": "For ab*11: sum=a+b, result = a-sum-b (carry if needed)",
     "example": "23*11: 2+3=5, so 253", "test": "What is 45*11?", "answer": 495},
    {"name": "Squaring numbers near 100", "trick": "(100-n)^2 = 100-2n | n^2",
     "example": "97^2: 100-97=3, 100-6=94, 3^2=09, so 9409", "test": "What is 96^2?", "answer": 9216},
    {"name": "Multiply near 100", "trick": "(100-a)(100-b) = 100-a-b | a*b",
     "example": "97*96: 100-97-96=97-93 wait... 97-4=93, 3*4=12, so 9312", "test": "What is 98*97?", "answer": 9506},
    {"name": "Digit sum check", "trick": "Sum digits repeatedly to get single digit. Same = correct",
     "example": "123*456=56088: 1+2+3=6, 4+5+6=15->6, 6*6=36->9, 5+6+0+8+8=27->9. Match!", "test": "Is 345*678=233910 correct? (y/n)", "answer": "y"},
    {"name": "Subtract from 1000", "trick": "Subtract each digit from 9, last from 10",
     "example": "1000-357: 9-3=6, 9-5=4, 10-7=3, so 643", "test": "What is 1000-478?", "answer": 522},
]

def main():
    print("=" * 55)
    print("  Vajra OS Vedic Math Trainer")
    print("=" * 55)
    score = 0
    for i, t in enumerate(TRICKS, 1):
        print(f"\n  --- Trick {i}: {t['name']} ---")
        print(f"  Rule: {t['trick']}")
        print(f"  Example: {t['example']}")
        ans = input(f"\n  {t['test']} ").strip()
        if str(t['answer']) == ans:
            print("  Correct! Well done!")
            score += 1
        else:
            print(f"  Answer: {t['answer']}")
    print(f"\n  Score: {score}/{len(TRICKS)}")
    if score == len(TRICKS): print("  Excellent! You are a human calculator!")
    elif score >= 4: print("  Great job!")
    else: print("  Keep practicing!")

if __name__ == "__main__":
    main()