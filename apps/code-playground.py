#!/usr/bin/env python3
"""Vajra OS - Code Playground
Problem: People want to try code without setting up a full dev environment.
"""
import subprocess, sys, os

def main():
    if len(sys.argv) < 2:
        print("  Vajra Code Playground")
        print("  Usage:")
        print("    vajra-playground python  - Interactive Python REPL")
        print("    vajra-playground bash    - Interactive Bash")
        print("    vajra-playground run <file>  - Run a code file")
        print("    vajra-playground eval <lang> <code>  - Eval code")
        return
    cmd = sys.argv[1]
    if cmd == "python":
        subprocess.run(["python3", "-i"])
    elif cmd == "bash":
        subprocess.run(["bash"])
    elif cmd == "run":
        if len(sys.argv) < 3: print("  Usage: vajra-playground run <file>"); return
        f = sys.argv[2]; ext = os.path.splitext(f)[1]
        if ext == ".py": subprocess.run(["python3", f])
        elif ext == ".sh": subprocess.run(["bash", f])
        elif ext == ".js": subprocess.run(["node", f])
        else: print(f"  Unsupported: {ext}")
    elif cmd == "eval":
        if len(sys.argv) < 4: print("  Usage: vajra-playground eval <lang> <code>"); return
        lang = sys.argv[2]; code = " ".join(sys.argv[3:])
        if lang == "python": subprocess.run(["python3", "-c", code])
        elif lang == "bash": subprocess.run(["bash", "-c", code])
        elif lang == "js": subprocess.run(["node", "-e", code])
        else: print(f"  Unsupported: {lang}")
    else:
        print(f"  Unknown: {cmd}")

if __name__ == "__main__":
    main()
