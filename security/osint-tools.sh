#!/bin/bash
# Vajra OS — OSINT (Open Source Intelligence) Tools
case "${1:-help}" in
    whois)
        DOMAIN="$2"
        [ -z "$DOMAIN" ] && echo "  Usage: vajra-osint whois <domain>" && exit 1
        whois "$DOMAIN" 2>/dev/null | head -50
        ;;
    dns)
        DOMAIN="$2"
        [ -z "$DOMAIN" ] && echo "  Usage: vajra-osint dns <domain>" && exit 1
        echo "  DNS records for $DOMAIN:"
        dig "$DOMAIN" ANY +short 2>/dev/null
        ;;
    ip-info)
        IP="${2:-}"
        if [ -z "$IP" ]; then
            echo "  Your public IP:"
            curl -s ifconfig.me 2>/dev/null
        else
            echo "  Info for $IP:"
            curl -s "https://ipinfo.io/$IP" 2>/dev/null
        fi
        ;;
    headers)
        URL="$2"
        [ -z "$URL" ] && echo "  Usage: vajra-osint headers <url>" && exit 1
        curl -sI "$URL" 2>/dev/null | head -20
        ;;
    subdomain)
        DOMAIN="$2"
        [ -z "$DOMAIN" ] && echo "  Usage: vajra-osint subdomain <domain>" && exit 1
        echo "  Enumerating subdomains for $DOMAIN ..."
        if command -v sublist3r &>/dev/null; then
            sublist3r -d "$DOMAIN" 2>/dev/null
        else
            echo "  Install sublist3r: pip install sublist3r"
        fi
        ;;
    help|*)
        echo "  Vajra OS - OSINT Tools"
        echo "  Commands: whois <domain>, dns <domain>, ip-info [ip], headers <url>, subdomain <domain>"
        ;;
esac
