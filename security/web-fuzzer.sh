#!/bin/bash
# Vajra OS — Web Application Fuzzer
case "${1:-help}" in
    fuzz)
        URL="$2"
        [ -z "$URL" ] && echo "  Usage: vajra-fuzzer fuzz <url>" && exit 1
        echo "  Fuzzing $URL ..."
        if command -v wfuzz &>/dev/null; then
            wfuzz -c -w /usr/share/wordlists/dirb/common.txt "$URL/FUZZ" 2>/dev/null
        else
            echo "  Installing wfuzz..."
            sudo apt-get install -y wfuzz 2>/dev/null
            wfuzz -c -w /usr/share/wordlists/dirb/common.txt "$URL/FUZZ" 2>/dev/null
        fi
        ;;
    dirb)
        URL="$2"
        [ -z "$URL" ] && echo "  Usage: vajra-fuzzer dirb <url>" && exit 1
        echo "  Directory brute force on $URL ..."
        dirb "$URL" 2>/dev/null || echo "  Install dirb: sudo apt-get install dirb"
        ;;
    xss)
        URL="$2"
        [ -z "$URL" ] && echo "  Usage: vajra-fuzzer xss <url>" && exit 1
        echo "  Testing XSS on $URL ..."
        if command -v dalfox &>/dev/null; then
            dalfox url "$URL" 2>/dev/null
        else
            echo "  Install dalfox: go install github.com/hahwul/dalfox/v2@latest"
        fi
        ;;
    help|*)
        echo "  Vajra OS - Web Application Fuzzer"
        echo "  Commands: fuzz <url>, dirb <url>, xss <url>"
        ;;
esac
