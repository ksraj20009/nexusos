#!/bin/bash
# Vajra OS — Reverse Engineering Suite
case "${1:-help}" in
    strings)
        FILE="$2"
        [ -z "$FILE" ] && echo "  Usage: vajra-reverse strings <file>" && exit 1
        strings "$FILE" | head -50
        ;;
    disasm)
        FILE="$2"
        [ -z "$FILE" ] && echo "  Usage: vajra-reverse disasm <file>" && exit 1
        objdump -d "$FILE" 2>/dev/null | head -100
        ;;
    hexdump)
        FILE="$2"
        [ -z "$FILE" ] && echo "  Usage: vajra-reverse hexdump <file>" && exit 1
        xxd "$FILE" 2>/dev/null | head -50 || hexdump -C "$FILE" | head -50
        ;;
    info)
        FILE="$2"
        [ -z "$FILE" ] && echo "  Usage: vajra-reverse info <file>" && exit 1
        file "$FILE"
        readelf -h "$FILE" 2>/dev/null || echo "  (not an ELF file)"
        ;;
    gdb)
        FILE="$2"
        [ -z "$FILE" ] && echo "  Usage: vajra-reverse gdb <file>" && exit 1
        echo "  Launching GDB on $FILE ..."
        gdb "$FILE"
        ;;
    help|*)
        echo "  Vajra OS - Reverse Engineering Suite"
        echo "  Commands: strings <file>, disasm <file>, hexdump <file>, info <file>, gdb <file>"
        ;;
esac
