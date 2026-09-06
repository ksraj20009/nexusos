#!/usr/bin/env python3
"""Vajra OS AI Code Assistant - Buddhi helps you write code (local, free)."""

def main():
    print("=" * 50)
    print("  Vajra OS AI Code Assistant (Buddhi)")
    print("=" * 50)
    lang = input("  Language (python/bash/javascript/c): ").strip() or "python"
    task = input("  What do you want to code? ").strip()
    if not task: return
    print(f"\n  Generating {lang} code for: {task}")
    print()
    templates = {
        "python": f"# {task}\nimport os\n\ndef main():\n    pass  # TODO: implement\n\nif __name__ == '__main__':\n    main()",
        "bash": f"#!/bin/bash\n# {task}\nset -e\necho 'TODO: implement'",
        "javascript": f"// {task}\nfunction main() {{\n  // TODO: implement\n}}\nmain();",
        "c": f"// {task}\n#include <stdio.h>\nint main() {{\n  // TODO: implement\n  return 0;\n}}",
    }
    code = templates.get(lang, templates["python"])
    print("  " + code.replace("\n", "\n  "))
    save = input("\n  Save to file? (y/n): ").strip()
    if save == "y":
        ext = {"python": "py", "bash": "sh", "javascript": "js", "c": "c"}.get(lang, "py")
        fname = f"vajra-ai-code.{ext}"
        with open(fname, "w") as f: f.write(code)
        print(f"  [+] Saved to {fname}")

if __name__ == "__main__":
    main()