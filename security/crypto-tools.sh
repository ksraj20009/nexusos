#!/bin/bash
# Vajra OS — Cryptography Tools
case "${1:-help}" in
    encrypt)
        FILE="$2"
        [ -z "$FILE" ] && echo "  Usage: vajra-crypto encrypt <file>" && exit 1
        echo "  Encrypting $FILE with AES-256..."
        openssl enc -aes-256-cbc -salt -in "$FILE" -out "$FILE.enc"
        echo "  Encrypted: $FILE.enc"
        ;;
    decrypt)
        FILE="$2"
        [ -z "$FILE" ] && echo "  Usage: vajra-crypto decrypt <file.enc>" && exit 1
        OUT="${FILE%.enc}"
        openssl enc -d -aes-256-cbc -in "$FILE" -out "$OUT"
        echo "  Decrypted: $OUT"
        ;;
    hash)
        FILE="$2"
        [ -z "$FILE" ] && echo "  Usage: vajra-crypto hash <file>" && exit 1
        echo "  MD5:    $(md5sum "$FILE" | awk '{print $1}')"
        echo "  SHA-1:  $(sha1sum "$FILE" | awk '{print $1}')"
        echo "  SHA-256:$(sha256sum "$FILE" | awk '{print $1}')"
        echo "  SHA-512:$(sha512sum "$FILE" | awk '{print $1}')"
        ;;
    gen-key)
        echo "  Generating RSA 4096-bit key pair..."
        openssl genrsa -out /tmp/vajra-private.key 4096 2>/dev/null
        openssl rsa -in /tmp/vajra-private.key -pubout -out /tmp/vajra-public.key 2>/dev/null
        echo "  Private key: /tmp/vajra-private.key"
        echo "  Public key:  /tmp/vajra-public.key"
        ;;
    help|*)
        echo "  Vajra OS - Cryptography Tools"
        echo "  Commands: encrypt <file>, decrypt <file.enc>, hash <file>, gen-key"
        ;;
esac
