#!/bin/bash
# Vajra OS - Built-in Image Viewer
case "${1:-help}" in
    open)
        FILE="$2"; [ -z "$FILE" ] && echo "  Usage: vajra-image open <file>" && exit 1
        if command -v feh &>/dev/null; then feh "$FILE"
        elif command -v display &>/dev/null; then display "$FILE"
        elif command -v eog &>/dev/null; then eog "$FILE"
        else echo "  Install: sudo apt-get install feh"; fi
        ;;
    info)
        FILE="$2"; [ -z "$FILE" ] && echo "  Usage: vajra-image info <file>" && exit 1
        file "$FILE"; identify "$FILE" 2>/dev/null || echo "  (ImageMagick not installed)"
        ;;
    convert)
        SRC="$2"; FMT="$3"
        [ -z "$SRC" ] || [ -z "$FMT" ] && echo "  Usage: vajra-image convert <file> <format>" && exit 1
        OUT="${SRC%.*}.$FMT"; convert "$SRC" "$OUT" 2>/dev/null && echo "  Converted to $OUT" || echo "  ImageMagick not installed"
        ;;
    help|*) echo "  Vajra OS - Image Viewer: open <file>, info <file>, convert <file> <format>" ;;
esac
