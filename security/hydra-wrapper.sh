#!/bin/bash
# Vajra OS — Hydra Brute Force Tool Wrapper
set -e
echo "◆ Vajra OS — Hydra Wrapper"
SD_DIR="/opt/vajra/security"
mkdir -p "$SD_DIR"

cat > "$SD_DIR/hydra-wrapper.sh" << 'HYDRA'
#!/bin/bash
case "${1:-help}" in
    ssh)
        HOST="$2"; USER="$3"; WL="${4:-/usr/share/wordlists/rockyou.txt}"
        [ -z "$HOST" ] || [ -z "$USER" ] && echo "  Usage: vajra-hydra ssh <host> <user> [wordlist]" && exit 1
        echo "  Brute forcing SSH on $HOST ..."
        hydra -l "$USER" -P "$WL" ssh://"$HOST" 2>/dev/null
        ;;
    ftp)
        HOST="$2"; USER="$3"; WL="${4:-/usr/share/wordlists/rockyou.txt}"
        [ -z "$HOST" ] || [ -z "$USER" ] && echo "  Usage: vajra-hydra ftp <host> <user> [wordlist]" && exit 1
        hydra -l "$USER" -P "$WL" ftp://"$HOST" 2>/dev/null
        ;;
    http)
        URL="$2"; USER="$3"; WL="${4:-/usr/share/wordlists/rockyou.txt}"
        [ -z "$URL" ] || [ -z "$USER" ] && echo "  Usage: vajra-hydra http <url> <user> [wordlist]" && exit 1
        hydra -l "$USER" -P "$WL" http-post-form "$URL" 2>/dev/null
        ;;
    help|*)
        echo "  Vajra OS - Hydra Brute Force Tool"
        echo "  Commands:"
        echo "    vajra-hydra ssh <host> <user> [wl]  - SSH brute force"
        echo "    vajra-hydra ftp <host> <user> [wl]  - FTP brute force"
        echo "    vajra-hydra http <url> <user> [wl]  - HTTP form brute force"
        echo ""
        echo "  WARNING: Only attack systems you own or have permission to test."
        ;;
esac
HYDRA
chmod +x "$SD_DIR/hydra-wrapper.sh"
ln -sf "$SD_DIR/hydra-wrapper.sh" /usr/local/bin/vajra-hydra 2>/dev/null || true
echo "  ✓ Hydra wrapper installed"
echo "◆ Done"
