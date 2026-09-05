#!/bin/bash
# Vajra OS — Hashcat GPU Password Cracker Wrapper
set -e
echo "◆ Vajra OS — Hashcat Wrapper"
SD_DIR="/opt/vajra/security"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/hashcat-wrapper.sh" << 'HASH'
#!/bin/bash
case "${1:-help}" in
    benchmark)
        echo "  Running GPU benchmark..."
        hashcat -b 2>/dev/null || hashcat --benchmark 2>/dev/null
        ;;
    dictionary)
        HASH_FILE="$2"; WL="${3:-/usr/share/wordlists/rockyou.txt}"
        [ -z "$HASH_FILE" ] && echo "  Usage: vajra-hashcat dictionary <hash-file> [wordlist]" && exit 1
        hashcat -m 0 -a 0 "$HASH_FILE" "$WL" 2>/dev/null
        ;;
    brute)
        HASH_FILE="$2"; MASK="${3:?a?a?a?a?a?a}"
        [ -z "$HASH_FILE" ] && echo "  Usage: vajra-hashcat brute <hash-file> [mask]" && exit 1
        hashcat -m 0 -a 3 "$HASH_FILE" "$MASK" 2>/dev/null
        ;;
    show)
        HASH_FILE="$2"
        [ -z "$HASH_FILE" ] && echo "  Usage: vajra-hashcat show <hash-file>" && exit 1
        hashcat -m 0 "$HASH_FILE" --show 2>/dev/null
        ;;
    help|*)
        echo "  Vajra OS - Hashcat GPU Password Cracker"
        echo "  Commands:"
        echo "    vajra-hashcat benchmark              - Test GPU cracking speed"
        echo "    vajra-hashcat dictionary <file> [wl] - Dictionary attack"
        echo "    vajra-hashcat brute <file> [mask]    - Brute force attack"
        echo "    vajra-hashcat show <file>            - Show cracked hashes"
        echo ""
        echo "  WARNING: Only crack hashes you own or have permission to test."
        ;;
esac
HASH
chmod +x "$SD_DIR/hashcat-wrapper.sh"
ln -sf "$SD_DIR/hashcat-wrapper.sh" /usr/local/bin/vajra-hashcat 2>/dev/null || true
echo "  ✓ Hashcat wrapper installed"
echo "◆ Done"
