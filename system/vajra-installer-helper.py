#!/usr/bin/env python3
"""
Vajra OS - Interactive Installer Helper
Every installation asks questions, shows info, gets confirmation.
"""

import subprocess
import sys
import os

# App database with detailed info
APP_DATABASE = {
    "firefox-esr": {
        "name": "Firefox ESR Browser",
        "category": "Web Browser",
        "description": "Privacy-focused web browser with Extended Support Release. Built-in tracking protection, no telemetry by default.",
        "size": "350 MB",
        "pros": ["Privacy hardened", "Open source", "Customizable", "Vast extension library", "Built-in tracking protection", "No ads"],
        "cons": ["Can be heavy on RAM (~500MB)", "Some sites break with strict tracking protection", "Not as fast as Chrome on some benchmarks"],
        "permissions": ["Network access", "File system read/write", "Microphone (if granted)", "Camera (if granted)"],
        "recommended": True,
        "alt": ["chromium", "epiphany", "torbrowser-launcher"],
    },
    "thunderbird": {
        "name": "Thunderbird Mail",
        "category": "Email Client",
        "description": "Full-featured email client with calendar, RSS feeds, and chat. Supports PGP encryption.",
        "size": "250 MB",
        "pros": ["Open source", "Excellent privacy", "Built-in encryption (PGP)", "Vast addon support", "Multi-account support", "No ads"],
        "cons": ["UI feels dated", "Heavy on RAM (~300MB)", "Setup can be complex for new users", "Some Exchange features missing"],
        "permissions": ["Network access", "Contacts read", "File system read/write", "Notifications"],
        "recommended": True,
        "alt": ["geary", "evolution"],
    },
    "vlc": {
        "name": "VLC Media Player",
        "category": "Media Player",
        "description": "Plays any video or audio format. No codec packs needed. Streaming, subtitles, screen recording.",
        "size": "100 MB",
        "pros": ["Plays literally everything", "Lightweight", "No ads", "Free and open source", "Streaming support", "Subtitle support", "Screen recording"],
        "cons": ["Minimal UI design", "Some advanced features hard to find", "Cannot edit video"],
        "permissions": ["File system read", "Network access (for streaming)", "Audio output"],
        "recommended": True,
        "alt": ["mpv", "totem"],
    },
    "libreoffice": {
        "name": "LibreOffice Suite",
        "category": "Office Suite",
        "description": "Complete office suite: Writer (word), Calc (spreadsheet), Impress (presentations), Draw, Base, Math.",
        "size": "600 MB",
        "pros": ["Full office suite", "Free and open source", "Opens Microsoft formats", "No telemetry", "Powerful macros", "PDF export built-in"],
        "cons": ["UI not as polished as MS Office", "Some complex Excel formulas dont convert perfectly", "Large install size"],
        "permissions": ["File system read/write", "Printer access", "Network access (optional updates)"],
        "recommended": True,
        "alt": ["abiword", "gnumeric"],
    },
    "gimp": {
        "name": "GIMP Image Editor",
        "category": "Image Editor",
        "description": "Professional photo and image editing. Layers, masks, filters, brushes, supports PSD files.",
        "size": "300 MB",
        "pros": ["Powerful editing", "Free and open source", "Supports layers and masks", "Plugin ecosystem", "Handles PSD files", "Scriptable"],
        "cons": ["Steep learning curve", "UI different from Photoshop", "Some pro features missing (CMYK)", "Can be slow on large images"],
        "permissions": ["File system read/write", "Display access"],
        "recommended": True,
        "alt": ["inkscape", "krita"],
    },
    "obs-studio": {
        "name": "OBS Studio",
        "category": "Screen Recorder / Streaming",
        "description": "Professional screen recording and live streaming. Multi-scene support, streaming to YouTube/Twitch.",
        "size": "250 MB",
        "pros": ["Professional quality", "Free and open source", "Multi-scene support", "No watermarks", "Plugin support", "GPU encoding"],
        "cons": ["Complex setup", "Can be CPU intensive", "Learning curve for streaming"],
        "permissions": ["Screen capture", "Audio capture", "Network access (for streaming)", "File system write"],
        "recommended": True,
        "alt": ["simplescreenrecorder", "kazam"],
    },
    "code": {
        "name": "Visual Studio Code",
        "category": "Code Editor",
        "description": "Lightweight but powerful code editor with extensions, integrated terminal, Git integration, and debugging.",
        "size": "200 MB",
        "pros": ["Lightweight", "Huge extension marketplace", "Integrated terminal", "Git integration", "Debugging", "AI assistance available"],
        "cons": ["Microsoft telemetry (can be disabled)", "Some extensions are heavy", "Electron-based (uses more RAM than native editors)"],
        "permissions": ["File system read/write", "Network access", "Terminal access", "Git access"],
        "recommended": True,
        "alt": ["neovim", "sublime-text", "atom"],
    },
    "docker.io": {
        "name": "Docker Container Engine",
        "category": "Developer Tool",
        "description": "Run applications in isolated containers. Consistent environments, easy deployment, microservices.",
        "size": "500 MB",
        "pros": ["App isolation", "Consistent environments", "Easy deployment", "Huge image registry", "Microservices friendly"],
        "cons": ["Uses significant RAM (~1GB idle)", "Large images", "Security considerations", "Requires root or docker group"],
        "permissions": ["Network access", "File system access", "Root privileges", "Process management"],
        "recommended": False,
        "alt": ["podman", "lxc"],
    },
    "steam": {
        "name": "Steam Gaming",
        "category": "Gaming",
        "description": "Game store and launcher. Thousands of games, cloud saves, auto-updates, Proton for Linux gaming.",
        "size": "1 GB",
        "pros": ["Huge game library", "Cloud saves", "Auto-updates", "Proton for Linux gaming", "Regular sales", "Community features"],
        "cons": ["DRM (you dont own games)", "Heavy on RAM (~500MB)", "Store has tracking/telemetry", "Requires account", "Large downloads for games"],
        "permissions": ["Network access", "File system read/write", "GPU access", "Usage tracking"],
        "recommended": False,
        "alt": ["lutris", "heroic"],
    },
    "discord": {
        "name": "Discord Chat",
        "category": "Communication",
        "description": "Voice and text chat for communities. Screen sharing, bot support, free voice chat.",
        "size": "200 MB",
        "pros": ["Great for communities", "Screen sharing", "Free voice chat", "Bot support", "Good audio quality"],
        "cons": ["Telemetry and tracking", "Electron (RAM ~300MB)", "Requires account", "No end-to-end encryption", "Data sold to advertisers"],
        "permissions": ["Network access", "Audio capture", "Screen capture", "Usage tracking", "Contacts read"],
        "recommended": False,
        "alt": ["signal-desktop", "element", "telegram-desktop"],
    },
    "spotify": {
        "name": "Spotify Music",
        "category": "Music Streaming",
        "description": "Music streaming with millions of songs, playlists, podcasts, and offline mode.",
        "size": "200 MB",
        "pros": ["Huge library", "Discovery features", "Playlists", "Podcasts", "Offline mode (premium)"],
        "cons": ["Ads in free version", "Telemetry/tracking", "Requires account", "DRM (you dont own music)", "Uses data for recommendations"],
        "permissions": ["Network access", "Audio playback", "Usage tracking", "File system (offline)"],
        "recommended": False,
        "alt": ["clementine", "audacious", "rhythmbox"],
    },
    "torbrowser-launcher": {
        "name": "Tor Browser",
        "category": "Web Browser (Anonymous)",
        "description": "Anonymous web browsing through the Tor network. Your IP is hidden, traffic is encrypted 3 times.",
        "size": "200 MB",
        "pros": ["Maximum anonymity", "Access .onion sites", "Bypasses censorship", "No tracking", "Free", "No account needed"],
        "cons": ["Slow browsing (5-10x slower)", "Many sites block Tor", "Streaming doesnt work", "CAPTCHAs frequent", "Cannot use for gaming"],
        "permissions": ["Network access (through Tor)", "File system read/write"],
        "recommended": True,
        "alt": ["firefox-esr"],
    },
    "blender": {
        "name": "Blender 3D",
        "category": "3D Editor",
        "description": "Professional 3D modeling, animation, rendering, video editing, and game creation suite.",
        "size": "500 MB",
        "pros": ["Professional 3D suite", "Free and open source", "Video editing built-in", "Huge community", "GPU rendering", "Game engine"],
        "cons": ["Very steep learning curve", "Requires good GPU", "Can be overwhelming", "Large install size"],
        "permissions": ["File system read/write", "GPU access", "Network access (optional)"],
        "recommended": False,
        "alt": ["openscad", "freecad"],
    },
    "audacity": {
        "name": "Audacity Audio Editor",
        "category": "Audio Editor",
        "description": "Record and edit audio. Multi-track editing, noise reduction, podcast-friendly. Export to MP3/WAV/FLAC.",
        "size": "100 MB",
        "pros": ["Simple and powerful", "Free and open source", "Multi-track editing", "Noise reduction", "Podcast friendly", "Multiple export formats"],
        "cons": ["UI is basic", "No native MIDI support", "Real-time effects limited", "No multi-channel recording"],
        "permissions": ["Audio capture", "File system read/write"],
        "recommended": True,
        "alt": ["ardour", "lmms"],
    },
    "neovim": {
        "name": "Neovim Text Editor",
        "category": "Text Editor",
        "description": "Modern Vim-based text editor. Fast, highly customizable, Lua scripting, LSP support.",
        "size": "30 MB",
        "pros": ["Fast", "Highly customizable", "Lua scripting", "LSP support", "Git integration", "Very lightweight"],
        "cons": ["Learning curve (Vim keys)", "Not for beginners", "Requires configuration"],
        "permissions": ["File system read/write", "Terminal access"],
        "recommended": True,
        "alt": ["code", "nano"],
    },
    "qbittorrent": {
        "name": "qBittorrent",
        "category": "Download Tool",
        "description": "BitTorrent client with built-in search, RSS support, and bandwidth scheduling. No ads.",
        "size": "50 MB",
        "pros": ["No ads", "Free and open source", "Built-in search", "RSS support", "Bandwidth scheduling", "Lightweight"],
        "cons": ["Legal risks if downloading copyrighted material", "ISP may throttle your connection", "Some torrents have malware"],
        "permissions": ["Network access", "File system read/write"],
        "recommended": False,
        "alt": ["transmission", "deluge"],
    },
}

def show_app_info(pkg_name):
    """Show detailed app information including pros, cons, permissions."""
    info = APP_DATABASE.get(pkg_name)
    if not info:
        print(f"\n  APP: {pkg_name}")
        print(f"  Status: Not in Vajra database")
        print(f"  WARNING: This app is not in Vajra's database.")
        print(f"  We cannot show pros/cons for it.")
        print(f"  Only install if you trust the source.\n")
        return False
    print(f"\n  APP INFORMATION")
    print(f"  Package: {pkg_name}")
    print(f"  Name: {info['name']}")
    print(f"  Category: {info['category']}")
    print(f"  Description: {info['description']}")
    print(f"  Download Size: {info['size']}")
    print(f"\n  PROS:")
    for p in info["pros"]:
        print(f"    + {p}")
    print(f"\n  CONS:")
    for c in info["cons"]:
        print(f"    - {c}")
    print(f"\n  PERMISSIONS REQUIRED:")
    for perm in info["permissions"]:
        print(f"    * {perm}")
    if info["recommended"]:
        print(f"\n  RECOMMENDED by Vajra")
    else:
        print(f"\n  Install only if you need it")
    if info.get("alt"):
        print(f"  Alternatives: {', '.join(info['alt'])}")
    print()
    return True

def ask_question(question, options=None, default=None):
    """Ask a question and get user response."""
    print(f"\n  {question}")
    if options:
        for i, opt in enumerate(options, 1):
            print(f"    [{i}] {opt}")
        if default:
            print(f"    (Default: {default})")
        choice = input("  Your choice: ").strip()
        if not choice and default:
            return default
        try:
            idx = int(choice) - 1
            if 0 <= idx < len(options):
                return options[idx]
        except ValueError:
            pass
        return choice
    else:
        return input("  Your answer: ").strip()

def install_package(pkg_name):
    """Full interactive installation with questions."""
    show_app_info(pkg_name)
    answer = ask_question(
        f"Do you want to download and install {pkg_name}?",
        ["YES - Install it now", "NO - Cancel", "Show apt info first", "Show alternatives"],
    )
    if "NO" in answer:
        print(f"\n  Cancelled. {pkg_name} was NOT installed.")
        return
    if "apt info" in answer.lower():
        print("\n  Detailed package information:")
        subprocess.run(["apt-cache", "show", pkg_name], capture_output=False)
        answer = ask_question(f"\nInstall {pkg_name} now?", ["YES", "NO"])
        if "NO" in answer:
            print(f"  Cancelled.")
            return
    if "alternatives" in answer.lower():
        info = APP_DATABASE.get(pkg_name, {})
        alts = info.get("alt", [])
        if alts:
            print(f"\n  Alternatives to {pkg_name}:")
            for i, alt in enumerate(alts, 1):
                alt_info = APP_DATABASE.get(alt, {})
                alt_name = alt_info.get("name", alt)
                alt_size = alt_info.get("size", "?")
                print(f"    [{i}] {alt} - {alt_name} ({alt_size})")
            choice = ask_question("\nInstall which?", alts + ["Cancel"])
            if "Cancel" in choice:
                print("  Cancelled.")
                return
            pkg_name = choice
            show_app_info(pkg_name)
            answer = ask_question(f"Install {pkg_name}?", ["YES", "NO"])
            if "NO" in answer:
                return
        else:
            print(f"\n  No alternatives found for {pkg_name}.")
            answer = ask_question(f"Install {pkg_name} anyway?", ["YES", "NO"])
            if "NO" in answer:
                return
    # Confirm understanding
    print("\n  Before installing, please confirm:")
    print("    - You have read the pros and cons")
    print("    - You understand the permissions")
    print("    - You trust this software")
    print("    - You have enough disk space")
    confirm = ask_question("\n  Do you confirm? (type 'yes' to proceed)")
    if confirm.lower() not in ["yes", "y"]:
        print(f"\n  Cancelled. {pkg_name} was NOT installed.")
        return
    # Install
    print(f"\n  Starting download and installation of {pkg_name}...")
    print(f"  This may take a few minutes depending on the size.\n")
    result = subprocess.run(["sudo", "apt-get", "install", "-y", pkg_name], capture_output=True, text=True)
    if result.returncode == 0:
        print(f"\n  SUCCESS: {pkg_name} installed successfully!\n")
    else:
        print(f"\n  FAILED: Installation of {pkg_name} failed.")
        print(f"  Try: sudo apt-get install {pkg_name}\n")
        print(f"  Error: {result.stderr[:200]}")

def remove_package(pkg_name):
    """Interactive removal with questions."""
    print(f"\n  WARNING: UNINSTALL {pkg_name}")
    print(f"  You are about to remove: {pkg_name}")
    print(f"  This will:")
    print(f"    - Remove the application")
    print(f"    - Free up disk space")
    print(f"    - Remove configuration (optional)")
    print(f"  Your personal files will NOT be deleted.")
    print(f"  But app settings/preferences will be lost.\n")
    confirm = ask_question(f"\n  Remove {pkg_name}? (yes/no)")
    if confirm.lower() not in ["yes", "y"]:
        print(f"  Cancelled. {pkg_name} was NOT removed.")
        return
    purge = ask_question("  Also remove config files?", ["yes", "no"])
    if "yes" in purge.lower():
        subprocess.run(["sudo", "apt-get", "purge", "-y", pkg_name], capture_output=True)
        print(f"  {pkg_name} fully removed (with config files).")
    else:
        subprocess.run(["sudo", "apt-get", "remove", "-y", pkg_name], capture_output=True)
        print(f"  {pkg_name} removed (config files kept).")

def browse_apps():
    """Browse apps by category."""
    categories = {}
    for pkg, info in APP_DATABASE.items():
        cat = info["category"]
        if cat not in categories:
            categories[cat] = []
        categories[cat].append((pkg, info))
    print("\n  Vajra App Browser\n")
    cats = sorted(categories.keys())
    for i, cat in enumerate(cats, 1):
        count = len(categories[cat])
        print(f"    [{i}] {cat} ({count} apps)")
    choice = ask_question("\n  Choose a category (number)")
    try:
        cat = cats[int(choice) - 1]
    except (ValueError, IndexError):
        print("  Invalid choice.")
        return
    print(f"\n  Apps in {cat}:\n")
    for i, (pkg, info) in enumerate(categories[cat], 1):
        rec = "[REC]" if info["recommended"] else "     "
        print(f"    {rec} [{i}] {info['name']} ({pkg}) - {info['size']}")
    choice = ask_question("\n  Which app to view? (number)")
    try:
        pkg = categories[cat][int(choice) - 1][0]
    except (ValueError, IndexError):
        print("  Invalid choice.")
        return
    show_app_info(pkg)
    answer = ask_question(f"\n  Install {pkg}?", ["YES", "NO"])
    if "YES" in answer:
        install_package(pkg)

def main():
    if len(sys.argv) < 2:
        print("Vajra OS - Interactive Installer Helper\n")
        print("Usage:")
        print("  vajra-installer install <pkg>  - Show info + ask before installing")
        print("  vajra-installer remove <pkg>   - Show warning + ask before removing")
        print("  vajra-installer info <pkg>    - Show app info, pros, cons")
        print("  vajra-installer browse        - Browse apps by category")
        print("  vajra-installer list          - List all known apps")
        return
    cmd = sys.argv[1]
    if cmd == "install":
        if len(sys.argv) < 3:
            print("  Usage: vajra-installer install <package>")
            return
        install_package(sys.argv[2])
    elif cmd == "remove":
        if len(sys.argv) < 3:
            print("  Usage: vajra-installer remove <package>")
            return
        remove_package(sys.argv[2])
    elif cmd == "info":
        if len(sys.argv) < 3:
            print("  Usage: vajra-installer info <package>")
            return
        show_app_info(sys.argv[2])
    elif cmd == "browse":
        browse_apps()
    elif cmd == "list":
        print("\n  Apps in Vajra database:\n")
        for pkg, info in sorted(APP_DATABASE.items(), key=lambda x: x[1]["category"]):
            rec = "[REC]" if info["recommended"] else "     "
            print(f"    {rec} {pkg} - {info['name']} ({info['size']})")
    else:
        print(f"  Unknown command: {cmd}")
        print("  Use: vajra-installer {install|remove|info|browse|list}")

if __name__ == "__main__":
    main()
