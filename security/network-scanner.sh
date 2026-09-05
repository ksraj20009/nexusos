#!/bin/bash
# Vajra OS — Network Scanner (discovery + mapping)
case "${1:-help}" in
    discover)
        SUBNET="${2:-192.168.1.0/24}"
        echo "  Discovering hosts on $SUBNET ..."
        nmap -sn "$SUBNET" 2>/dev/null | grep "Nmap scan report"
        ;;
    map)
        SUBNET="${2:-192.168.1.0/24}"
        echo "  Mapping network $SUBNET ..."
        nmap -sP "$SUBNET" -oG - 2>/dev/null | grep "Up" | awk '{print $2}'
        ;;
    arp)
        echo "  ARP table:"
        arp -a 2>/dev/null || ip neigh 2>/dev/null
        ;;
    ports)
        HOST="${2:-localhost}"
        echo "  Open ports on $HOST:"
        nmap -sT -p- "$HOST" 2>/dev/null | grep "open"
        ;;
    services)
        HOST="${2:-localhost}"
        echo "  Running services on $HOST:"
        nmap -sV "$HOST" 2>/dev/null
        ;;
    help|*)
        echo "  Vajra OS - Network Scanner"
        echo "  Commands: discover <subnet>, map <subnet>, arp, ports <host>, services <host>"
        ;;
esac
