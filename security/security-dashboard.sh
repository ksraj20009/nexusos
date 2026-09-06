#!/bin/bash
# Vajra OS Security Dashboard
# Visual overview of all security settings
set -e
echo "=== Vajra OS Security Dashboard ==="
echo ""
echo "  Firewall:"
ufw status 2>/dev/null || echo "    Not installed"
echo ""
echo "  Failed SSH logins (last 24h):"
grep "Failed password" /var/log/auth.log 2>/dev/null | wc -l || echo "    N/A"
echo ""
echo "  System updates:"
apt list --upgradable 2>/dev/null | wc -l
echo ""
echo "  Antivirus:"
clamscan --version 2>/dev/null || echo "    Not installed"
echo ""
echo "  Open ports:"
ss -tlnp 2>/dev/null | head -10
echo ""
echo "  Users with sudo:"
grep -Po "^sudo:[^:]+:([0-9]+)" /etc/group | cut -d: -f4
echo ""
echo "=== Security Score ==="
SCORE=0
ufw status 2>/dev/null | grep -q "active" && SCORE=$((SCORE+20))
[ -f /etc/ssh/sshd_config ] && grep -q "PermitRootLogin no" /etc/ssh/sshd_config && SCORE=$((SCORE+20))
grep -q "PasswordAuthentication no" /etc/ssh/sshd_config 2>/dev/null && SCORE=$((SCORE+15))
dpkg -l | grep -q fail2ban && SCORE=$((SCORE+15))
dpkg -l | grep -q clamav && SCORE=$((SCORE+10))
dpkg -l | grep -q rkhunter && SCORE=$((SCORE+10))
echo "  Score: $SCORE/100"
if [ $SCORE -ge 80 ]; then echo "  Rating: EXCELLENT"
elif [ $SCORE -ge 60 ]; then echo "  Rating: GOOD"
elif [ $SCORE -ge 40 ]; then echo "  Rating: FAIR"
else echo "  Rating: NEEDS IMPROVEMENT"
fi