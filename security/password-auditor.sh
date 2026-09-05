#!/bin/bash
# Vajra OS — Password Strength Auditor
case "${1:-help}" in
    strength)
        echo "  Enter password to audit:"
        read -s pass
        len=${#pass}
        score=0
        [[ "$pass" =~ [a-z] ]] && score=$((score+1))
        [[ "$pass" =~ [A-Z] ]] && score=$((score+1))
        [[ "$pass" =~ [0-9] ]] && score=$((score+1))
        [[ "$pass" =~ [^a-zA-Z0-9] ]] && score=$((score+1))
        [ $len -ge 8 ] && score=$((score+1))
        [ $len -ge 12 ] && score=$((score+1))
        [ $len -ge 16 ] && score=$((score+1))
        echo "  Length: $len"
        echo "  Complexity: $score/7"
        case $score in
            [0-2]) echo "  Rating: WEAK - easily cracked" ;;
            [3-4]) echo "  Rating: MODERATE - could be better" ;;
            5) echo "  Rating: GOOD" ;;
            [6-7]) echo "  Rating: STRONG" ;;
        esac
        ;;
    check-hash)
        echo "  Enter password:"
        read -s pass
        echo "$pass" | sha256sum | awk '{print "  SHA-256: "$1}'
        echo "$pass" | md5sum | awk '{print "  MD5:     "$1}'
        ;;
    help|*)
        echo "  Vajra OS - Password Auditor"
        echo "  Commands: strength, check-hash"
        ;;
esac
