#!/usr/bin/env python3
"""Vajra OS - AI Code Reviewer
Problem: Beginners don't know if their code is good or has bugs.
"""
import sys, os

def review_python(code):
    issues = []
    suggestions = []
    good = []
    if "import os" in code and "os.system" in code:
        issues.append("SECURITY: os.system() is unsafe. Use subprocess.run() instead.")
    if "eval(" in code:
        issues.append("SECURITY: eval() is dangerous with user input.")
    if "exec(" in code:
        issues.append("SECURITY: exec() is dangerous.")
    if "except:" in code and "pass" in code:
        issues.append("ANTI-PATTERN: Bare except + pass swallows errors.")
    if "def " in code:
        good.append("Uses functions for code organization.")
    if "input(" in code:
        good.append("Accepts user input.")
    if "__name__" in code:
        good.append("Uses if __name__ == '__main__' guard - good practice.")
    if len(code.split('\n')) > 50:
        suggestions.append("Consider splitting into multiple files (>50 lines).")
    if "rm -rf" in code:
        issues.append("DANGER: rm -rf found in code!")
    return issues, suggestions, good

def main():
    if len(sys.argv) < 2:
        print("  Vajra AI Code Reviewer")
        print("  Usage: vajra-code-review <file>  or  vajra-code-review -s <code>")
        return
    if sys.argv[1] == "-s":
        code = " ".join(sys.argv[2:])
    else:
        with open(sys.argv[1], 'r') as f:
            code = f.read()
    issues, suggestions, good = review_python(code)
    print("\n  === AI Code Review ===\n")
    if issues:
        print("  ISSUES (fix these):")
        for i in issues: print(f"    [!] {i}")
    else:
        print("  ISSUES: None found!")
    if suggestions:
        print("\n  SUGGESTIONS:")
        for s in suggestions: print(f"    [~] {s}")
    if good:
        print("\n  GOOD PRACTICES:")
        for g in good: print(f"    [+] {g}")
    if not issues and not suggestions:
        print("\n  Code looks good!")

if __name__ == "__main__":
    main()
