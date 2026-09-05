#!/bin/bash
# Vajra OS — Digital Forensics Toolkit
case "${1:-help}" in
    disk-image)
        DEV="$2"; OUT="${3:-/tmp/vajra-disk.dd}"
        [ -z "$DEV" ] && echo "  Usage: vajra-forensics disk-image <device> [output]" && exit 1
        echo "  Creating forensic image of $DEV ..."
        sudo dcfldd if="$DEV" of="$OUT" hash=sha256 2>/dev/null || sudo dd if="$DEV" of="$OUT"
        echo "  Image saved to $OUT"
        ;;
    file-carve)
        FILE="$2"; OUT="${3:-/tmp/vajra-carved}"
        [ -z "$FILE" ] && echo "  Usage: vajra-forensics file-carve <image> [output-dir]" && exit 1
        mkdir -p "$OUT"
        foremost -i "$FILE" -o "$OUT" 2>/dev/null && echo "  Files carved to $OUT" || echo "  Install foremost: sudo apt-get install foremost"
        ;;
    memory-dump)
        echo "  Capturing memory..."
        sudo dd if=/dev/mem of=/tmp/vajra-mem.dump bs=1M count=512 2>/dev/null
        echo "  Memory dump saved"
        ;;
    timeline)
        DIR="${2:-.}"
        echo "  Creating file timeline for $DIR ..."
        fls -r "$DIR" 2>/dev/null | head -50 || find "$DIR" -printf "%T+ %p\n" | sort | head -50
        ;;
    hash-verify)
        FILE="$2"; HASH="${3:-}"
        [ -z "$FILE" ] && echo "  Usage: vajra-forensics hash-verify <file> [expected-hash]" && exit 1
        CALC=$(sha256sum "$FILE" | awk '{print $1}')
        echo "  File: $FILE"
        echo "  SHA-256: $CALC"
        [ -n "$HASH" ] && [ "$CALC" = "$HASH" ] && echo "  Hash matches!" || [ -n "$HASH" ] && echo "  Hash mismatch!"
        ;;
    help|*)
        echo "  Vajra OS - Digital Forensics Toolkit"
        echo "  Commands:"
        echo "    disk-image <device> [output]  - Create forensic disk image"
        echo "    file-carve <image> [out-dir]   - Carve deleted files"
        echo "    memory-dump                    - Capture RAM"
        echo "    timeline <dir>                 - File access timeline"
        echo "    hash-verify <file> [hash]       - Verify file integrity"
        ;;
esac
