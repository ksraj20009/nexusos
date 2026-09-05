#!/bin/bash
# Vajra OS — John the Ripper Password Cracker Wrapper
set -e
echo "◆ Vajra OS — John the Ripper Wrapper"
SD_DIR="/opt/vajra/security"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/john-wrapper.sh" << 'JOHN'
#!/bin/bash
case "${1:-help}" in
    crack)
        FILE="$2"
        [ -z "$FILE" ] && echo "  Usage: vajra-john crack <hash-file>" && exit 1
        echo "  Cracking hashes in $FILE ..."
        john "$FILE" 2>/dev/null
        ;;
    wordlist)
        FILE="$2"; WL="${3:-/usr/share/wordlists/rockyou.txt}"
        [ -z "$FILE" ] && echo "  Usage: vajra-john wordlist <hash-file> [wordlist]" && exit 1
        echo "  Dictionary attack using $WL ..."
        john --wordlist="$WL" "$FILE" 2>/dev/null
        ;;
    show)
        FILE="$2"
        [ -z "$FILE" ] && echo "  Usage: vajra-john show <hash-file>" && exit 1
        john --show "$FILE" 2>/dev/null
        ;;
    shadow)
        echo "  Cracking /etc/shadow (requires root)..."
        sudo unshadow /etc/passwd /etc/shadow > /tmp/vajra-shadow.txt
        john /tmp/vajra-shadow.txt
        ;;
    zip)
        FILE="$2"
        [ -z "$FILE" ] && echo "  Usage: vajra-john zip <file.zip>" && exit 1
        zip2john "$FILE" > /tmp/vajra-zip.hash 2>/dev/null
        john /tmp/vajra-zip.hash
        ;;
    help|*)
        echo "  Vajra OS - John the Ripper Password Cracker"
        echo "  Commands:"
        echo "    vajra-john crack <file>              - Default crack"
        echo "    vajra-john wordlist <file> [wl]      - Dictionary attack"
        echo "    vajra-john show <file>               - Show cracked passwords"
        echo "    vajra-john shadow                    - Crack /etc/shadow"
        echo "    vajra-john zip <file.zip>            - Crack ZIP password"
        echo ""
        echo "  WARNING: Only crack passwords you own or have permission to test."
        ;;
esac
JOHN
chmod +x "$SD_DIR/john-wrapper.sh"
ln -sf "$SD_DIR/john-wrapper.sh" /usr/local/bin/vajra-john 2>/dev/null || true
echo "  ✓ John the Ripper wrapper installed"
echo "◆ Done"
