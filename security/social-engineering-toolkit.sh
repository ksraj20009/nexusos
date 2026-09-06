#!/bin/bash
# Vajra OS Social Engineering Toolkit (Educational)
# WARNING: For educational purposes only
set -e
echo "=== Vajra OS Social Engineering Toolkit ==="
echo "WARNING: This tool is for EDUCATIONAL PURPOSES ONLY!"
echo "         Only use in authorized training environments."
echo ""
echo "  1. Educational phishing simulation (safe)"
echo "  2. Create awareness training quiz"
echo "  3. Generate security awareness report"
echo "  4. View Indian IT Act sections"
echo "  5. Exit"
read -p "Choice: " choice
case "$choice" in
    1) echo "Phishing simulation creates a safe test page to train users to recognize phishing."
       echo "No real credentials are collected. All data stays local."
       echo "Run: python3 /opt/vajra/security/phishing-simulation.py" ;;
    2) echo "Launching security awareness quiz..."
       python3 /opt/vajra/security/cyber-academy.sh --lesson 15 ;;
    3) echo "Generating security awareness report..."
       bash /opt/vajra/security/security-audit-checklist.sh ;;
    4) echo "Indian IT Act 2000 sections:"
       echo "  Section 43: Penalty for damage to computer systems"
       echo "  Section 66: Computer related offenses (imprisonment up to 3 years)"
       echo "  Section 66A: Punishment for sending offensive messages (repealed 2015)"
       echo "  Section 67: Obscene material in electronic form"
       echo "  Section 72: Breach of confidentiality" ;;
    5) exit 0 ;;
esac