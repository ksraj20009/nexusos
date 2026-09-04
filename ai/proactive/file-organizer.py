#!/usr/bin/env python3
"""
Vajra OS — Buddhi File Organizer
Auto-organizes downloads, tags files by type, date.
"""
import os, shutil, json
from datetime import datetime
from pathlib import Path

CATEGORIES = {
    "Images": [".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp", ".svg", ".tiff"],
    "Documents": [".pdf", ".doc", ".docx", ".txt", ".odt", ".rtf", ".pages"],
    "Spreadsheets": [".xls", ".xlsx", ".csv", ".ods"],
    "Presentations": [".ppt", ".pptx", ".odp", ".key"],
    "Videos": [".mp4", ".avi", ".mkv", ".mov", ".wmv", ".flv", ".webm"],
    "Audio": [".mp3", ".wav", ".flac", ".aac", ".ogg", ".m4a"],
    "Archives": [".zip", ".tar", ".gz", ".bz2", ".xz", ".rar", ".7z"],
    "Code": [".py", ".js", ".ts", ".html", ".css", ".cpp", ".c", ".h", ".java", ".go", ".rs", ".sh"],
    "Software": [".deb", ".rpm", ".appimage", ".exe", ".msi", ".dmg"],
    "Fonts": [".ttf", ".otf", ".woff", ".woff2"],
}

def organize(directory=None):
    if directory is None:
        directory = os.path.expanduser("~/Downloads")
    if not os.path.isdir(directory):
        return f"Directory not found: {directory}"
    moved = 0
    log_lines = [f"Vajra File Organizer\nDirectory: {directory}\n"]
    for item in os.listdir(directory):
        item_path = os.path.join(directory, item)
        if os.path.isfile(item_path):
            ext = Path(item).suffix.lower()
            category = "Others"
            for cat, exts in CATEGORIES.items():
                if ext in exts:
                    category = cat
                    break
            dest_dir = os.path.join(directory, category)
            os.makedirs(dest_dir, exist_ok=True)
            dest_path = os.path.join(dest_dir, item)
            if os.path.exists(dest_path):
                name = Path(item).stem
                suffix = Path(item).suffix
                timestamp = datetime.now().strftime("%H%M%S")
                dest_path = os.path.join(dest_dir, f"{name}_{timestamp}{suffix}")
            shutil.move(item_path, dest_path)
            moved += 1
            log_lines.append(f"  {item} -> {category}/")
    log_lines.append(f"\nMoved {moved} file(s).")
    return "\n".join(log_lines)

def tag_file(filepath, tags):
    tag_file_path = filepath + ".vajra-tags"
    existing = {}
    try:
        with open(tag_file_path) as f:
            existing = json.load(f)
    except:
        pass
    existing["tags"] = list(set(existing.get("tags", []) + tags))
    existing["tagged_at"] = datetime.now().isoformat()
    with open(tag_file_path, 'w') as f:
        json.dump(existing, f, indent=2)
    return f"Tagged {filepath} with: {', '.join(tags)}"

def find_by_tag(directory, tag):
    results = []
    for root, dirs, files in os.walk(directory):
        for f in files:
            tag_file = os.path.join(root, f + ".vajra-tags")
            if os.path.exists(tag_file):
                try:
                    with open(tag_file) as tf:
                        data = json.load(tf)
                    if tag.lower() in [t.lower() for t in data.get("tags", [])]:
                        results.append(os.path.join(root, f))
                except:
                    pass
    return results

if __name__ == "__main__":
    import sys
    if len(sys.argv) > 1:
        cmd = sys.argv[1]
        if cmd == "organize":
            directory = sys.argv[2] if len(sys.argv) > 2 else None
            print(organize(directory))
        elif cmd == "tag":
            print(tag_file(sys.argv[2], sys.argv[3:]))
        elif cmd == "find":
            results = find_by_tag(sys.argv[2], sys.argv[3])
            print(f"Found {len(results)} files with tag '{sys.argv[3]}':")
            for r in results:
                print(f"  {r}")
        else:
            print("Usage: file-organizer.py [organize [dir]|tag <file> <tags...>|find <dir> <tag>]")
    else:
        print(organize())
