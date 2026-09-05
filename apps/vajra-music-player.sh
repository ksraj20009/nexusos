#!/bin/bash
# Vajra OS - Built-in Music Player
case "${1:-help}" in
    play)
        FILE="$2"; [ -z "$FILE" ] && echo "  Usage: vajra-music play <file>" && exit 1
        if command -v mpg123 &>/dev/null; then mpg123 "$FILE"
        elif command -v mpv &>/dev/null; then mpv --no-video "$FILE"
        elif command -v ffplay &>/dev/null; then ffplay -nodisp "$FILE"
        else echo "  Install: sudo apt-get install mpg123"; fi
        ;;
    play-dir)
        DIR="${2:-.}"
        echo "  Playing all audio in $DIR ..."
        for f in "$DIR"/*.mp3 "$DIR"/*.ogg "$DIR"/*.wav "$DIR"/*.flac; do
            [ -f "$f" ] && echo "  Playing: $(basename "$f")" && mpg123 -q "$f" 2>/dev/null
        done
        ;;
    help|*) echo "  Vajra OS - Music Player: play <file>, play-dir <dir>" ;;
esac
