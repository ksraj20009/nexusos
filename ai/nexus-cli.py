# NexusOS AI Assistant — CLI wrapper
# Provides a convenient command-line interface to the AI service
#!/usr/bin/env python3
"""Nexus AI CLI — command-line interface to the Nexus AI assistant."""

import sys
import json
import urllib.request

API_URL = "http://127.0.0.1:5210"

def main():
    if len(sys.argv) > 1:
        # Single query mode
        query = " ".join(sys.argv[1:])
        response = send_query(query)
        print(response)
    else:
        # Interactive mode
        print()
        print("  ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆")
        print()
        print("        Nexus AI CLI")
        print()
        print("  ◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆")
        print()
        print("  Type 'help' for commands, 'exit' to quit.")
        print()
        
        while True:
            try:
                query = input("\033[36mraj@nexusos:~$ \033[0m").strip()
            except (EOFError, KeyboardInterrupt):
                print("\nGoodbye!")
                break
            
            if not query:
                continue
            if query.lower() in ("exit", "quit", "bye"):
                break
            
            response = send_query(query)
            print()
            print(response)

def send_query(query):
    """Send a query to the Nexus AI API."""
    try:
        data = json.dumps({"query": query}).encode("utf-8")
        req = urllib.request.Request(
            f"{API_URL}/query",
            data=data,
            headers={"Content-Type": "application/json"},
            method="POST"
        )
        with urllib.request.urlopen(req, timeout=30) as resp:
            result = json.loads(resp.read().decode("utf-8"))
            return result.get("data", {}).get("response", "No response")
    except urllib.error.URLError:
        return "AI service is not running. Start with: systemctl --user start nexus-ai"
    except Exception as e:
        return f"Error: {str(e)}"

if __name__ == "__main__":
    main()